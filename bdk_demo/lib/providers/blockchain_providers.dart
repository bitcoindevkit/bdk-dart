import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/models/wallet_balance_snapshot.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/wallet_sync_job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStatus { idle, syncing, synced, error }

typedef WalletSqlitePathResolver = Future<String> Function(String walletId);
typedef WalletFullScanMarker = Future<void> Function(String walletId);

final syncStatusProvider = NotifierProvider<SyncStatusNotifier, SyncStatus>(
  SyncStatusNotifier.new,
);

class SyncStatusNotifier extends Notifier<SyncStatus> {
  @override
  SyncStatus build() => SyncStatus.idle;

  void set(SyncStatus status) => state = status;
}

final balanceSnapshotProvider =
    NotifierProvider<BalanceSnapshotNotifier, WalletBalanceSnapshot?>(
      BalanceSnapshotNotifier.new,
    );

class BalanceSnapshotNotifier extends Notifier<WalletBalanceSnapshot?> {
  @override
  WalletBalanceSnapshot? build() {
    ref.listen<WalletRecord?>(activeWalletRecordProvider, (previous, next) {
      final snapshot = state;
      if (snapshot == null) return;
      if (next == null || snapshot.walletId != next.id) {
        state = null;
      }
    });
    return null;
  }

  void clear() => state = null;

  void applyFromWallet(Wallet wallet, String walletId) {
    final b = wallet.balance();
    state = WalletBalanceSnapshot(
      walletId: walletId,
      immatureSat: b.immature.toSat(),
      trustedPendingSat: b.trustedPending.toSat(),
      untrustedPendingSat: b.untrustedPending.toSat(),
      confirmedSat: b.confirmed.toSat(),
      trustedSpendableSat: b.trustedSpendable.toSat(),
      totalSat: b.total.toSat(),
    );
  }
}

final walletSyncJobRunnerProvider = Provider<WalletSyncJobRunner>((ref) {
  return defaultWalletSyncJobRunner;
});

final walletSqlitePathResolverProvider = Provider<WalletSqlitePathResolver>((
  ref,
) {
  return WalletStoragePaths.sqlitePathForWallet;
});

final walletFullScanMarkerProvider = Provider<WalletFullScanMarker>((ref) {
  return ref.read(walletRecordsProvider.notifier).setFullScanCompleted;
});

final syncControllerProvider = NotifierProvider<SyncController, int>(
  SyncController.new,
);

final syncActiveWalletTriggerProvider = Provider<Future<void> Function()>((
  ref,
) {
  return ref.read(syncControllerProvider.notifier).syncActiveWallet;
});

class SyncController extends Notifier<int> {
  bool _inFlight = false;

  @override
  int build() => 0;

  Future<void> syncActiveWallet() async {
    if (_inFlight) return;

    final record = ref.read(activeWalletRecordProvider);
    if (record == null) return;

    final walletId = record.id;
    Wallet? reloadedWallet;
    var transferredWallet = false;
    _inFlight = true;
    ref.read(syncStatusProvider.notifier).set(SyncStatus.syncing);

    try {
      final storage = ref.read(storageServiceProvider);
      final secrets = await storage.getSecrets(walletId);
      if (secrets == null) {
        if (_stillActive(walletId)) {
          ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
        } else {
          ref.read(syncStatusProvider.notifier).set(SyncStatus.idle);
        }
        return;
      }

      final sqlitePath = await ref
          .read(walletSqlitePathResolverProvider)
          .call(walletId);
      final request = WalletSyncRequest(
        walletId: walletId,
        descriptor: secrets.descriptor,
        changeDescriptor: secrets.changeDescriptor,
        walletNetworkName: record.network.name,
        sqlitePath: sqlitePath,
        fullScanCompleted: record.fullScanCompleted,
      );

      final runner = ref.read(walletSyncJobRunnerProvider);
      final WalletSyncResult result;
      try {
        result = await runner(request);
      } catch (e) {
        if (_stillActive(walletId)) {
          ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
        } else {
          ref.read(syncStatusProvider.notifier).set(SyncStatus.idle);
        }
        return;
      }

      if (!_stillActive(walletId)) {
        ref.read(syncStatusProvider.notifier).set(SyncStatus.idle);
        return;
      }

      if (!result.success) {
        ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
        return;
      }

      if (result.performedFullScan) {
        await ref.read(walletFullScanMarkerProvider).call(walletId);
      }

      if (!_stillActive(walletId)) {
        ref.read(syncStatusProvider.notifier).set(SyncStatus.idle);
        return;
      }

      final updatedRecord = _recordById(walletId) ?? record;
      ref.read(activeWalletRecordProvider.notifier).set(updatedRecord);

      final walletService = ref.read(walletServiceProvider);
      try {
        reloadedWallet = await walletService.loadWalletFromRecord(
          updatedRecord,
        );
      } catch (_) {
        if (_stillActive(walletId)) {
          ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
        } else {
          ref.read(syncStatusProvider.notifier).set(SyncStatus.idle);
        }
        return;
      }

      if (!_stillActive(walletId)) {
        reloadedWallet.dispose();
        ref.read(syncStatusProvider.notifier).set(SyncStatus.idle);
        return;
      }

      final syncedWallet = reloadedWallet;
      ref.read(activeWalletProvider.notifier).replaceWallet(syncedWallet);
      transferredWallet = true;
      ref
          .read(balanceSnapshotProvider.notifier)
          .applyFromWallet(syncedWallet, walletId);
      ref.read(syncStatusProvider.notifier).set(SyncStatus.synced);
    } catch (_) {
      if (!transferredWallet) {
        reloadedWallet?.dispose();
      }
      if (_stillActive(walletId)) {
        ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
      } else {
        ref.read(syncStatusProvider.notifier).set(SyncStatus.idle);
      }
    } finally {
      _inFlight = false;
    }
  }

  bool _stillActive(String walletId) =>
      ref.read(activeWalletRecordProvider)?.id == walletId;

  WalletRecord? _recordById(String walletId) {
    try {
      return ref
          .read(walletRecordsProvider)
          .firstWhere((r) => r.id == walletId);
    } catch (_) {
      return null;
    }
  }
}
