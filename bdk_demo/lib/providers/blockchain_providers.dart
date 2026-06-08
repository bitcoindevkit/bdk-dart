import 'dart:async';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/models/wallet_balance_snapshot.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/network_endpoint_providers.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/wallet_sync_job.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStatus { idle, syncing, synced, error }

enum SyncErrorKind { none, timeout, generic }

enum SyncPhase { idle, connecting, scanning, saving, upToDate }

class SyncProgress {
  const SyncProgress({this.phase = SyncPhase.idle, this.isFirstSync = false});

  final SyncPhase phase;
  final bool isFirstSync;
}

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

final syncProgressProvider =
    NotifierProvider<SyncProgressNotifier, SyncProgress>(
      SyncProgressNotifier.new,
    );

class SyncProgressNotifier extends Notifier<SyncProgress> {
  @override
  SyncProgress build() => const SyncProgress();

  void start({required bool isFirstSync}) {
    state = SyncProgress(phase: SyncPhase.connecting, isFirstSync: isFirstSync);
  }

  void setPhase(SyncPhase phase) {
    state = SyncProgress(phase: phase, isFirstSync: state.isFirstSync);
  }

  void reset() => state = const SyncProgress();
}

final syncErrorKindProvider =
    NotifierProvider<SyncErrorKindNotifier, SyncErrorKind>(
      SyncErrorKindNotifier.new,
    );

class SyncErrorKindNotifier extends Notifier<SyncErrorKind> {
  @override
  SyncErrorKind build() => SyncErrorKind.none;

  void set(SyncErrorKind kind) => state = kind;

  void reset() => state = SyncErrorKind.none;
}

final syncElapsedProvider = NotifierProvider<SyncElapsedNotifier, Duration>(
  SyncElapsedNotifier.new,
);

class SyncElapsedNotifier extends Notifier<Duration> {
  Timer? _timer;
  DateTime? _startedAt;

  @override
  Duration build() {
    ref.onDispose(_stopTimer);
    return Duration.zero;
  }

  void start() {
    _startedAt = DateTime.now();
    _stopTimer();
    state = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final startedAt = _startedAt;
      if (startedAt != null) {
        state = DateTime.now().difference(startedAt);
      }
    });
  }

  void stop() {
    _stopTimer();
    _startedAt = null;
    state = Duration.zero;
  }

  @visibleForTesting
  void setElapsed(Duration elapsed) {
    state = elapsed;
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

final syncTimeoutProvider = Provider<Duration>(
  (ref) => AppConstants.syncTimeout,
);

final autoSyncedWalletIdsProvider =
    NotifierProvider<AutoSyncedWalletIdsNotifier, Set<String>>(
      AutoSyncedWalletIdsNotifier.new,
    );

class AutoSyncedWalletIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  bool contains(String walletId) => state.contains(walletId);

  void mark(String walletId) {
    if (state.contains(walletId)) return;
    state = {...state, walletId};
  }

  void unmark(String walletId) {
    if (!state.contains(walletId)) return;
    state = state.where((id) => id != walletId).toSet();
  }
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

  void _setSyncStatus(SyncStatus status) {
    ref.read(syncStatusProvider.notifier).set(status);
    final progress = ref.read(syncProgressProvider.notifier);
    final errorKind = ref.read(syncErrorKindProvider.notifier);
    switch (status) {
      case SyncStatus.synced:
        progress.setPhase(SyncPhase.upToDate);
        errorKind.reset();
        ref.read(syncElapsedProvider.notifier).stop();
      case SyncStatus.idle:
        progress.reset();
        errorKind.reset();
        ref.read(syncElapsedProvider.notifier).stop();
      case SyncStatus.error:
        progress.reset();
        ref.read(syncElapsedProvider.notifier).stop();
      case SyncStatus.syncing:
        break;
    }
  }

  void _resetSyncErrorKind() {
    ref.read(syncErrorKindProvider.notifier).reset();
  }

  Future<void> syncActiveWallet() async {
    if (_inFlight) return;

    final record = ref.read(activeWalletRecordProvider);
    if (record == null) return;

    final walletId = record.id;
    final isFirstSync = !record.fullScanCompleted;
    Wallet? reloadedWallet;
    var transferredWallet = false;
    _inFlight = true;
    _resetSyncErrorKind();
    ref.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
    ref.read(syncProgressProvider.notifier).start(isFirstSync: isFirstSync);
    ref.read(syncElapsedProvider.notifier).start();

    try {
      final storage = ref.read(storageServiceProvider);
      final secrets = await storage.getSecrets(walletId);
      if (secrets == null) {
        if (_stillActive(walletId)) {
          ref.read(syncErrorKindProvider.notifier).set(SyncErrorKind.generic);
          _setSyncStatus(SyncStatus.error);
        } else {
          _setSyncStatus(SyncStatus.idle);
        }
        return;
      }

      final sqlitePath = await ref
          .read(walletSqlitePathResolverProvider)
          .call(walletId);
      final endpoint = ref.read(endpointConfigProvider(record.network));
      final request = WalletSyncRequest(
        walletId: walletId,
        descriptor: secrets.descriptor,
        changeDescriptor: secrets.changeDescriptor,
        walletNetworkName: record.network.name,
        sqlitePath: sqlitePath,
        fullScanCompleted: record.fullScanCompleted,
        endpointUrl: endpoint.url,
        endpointClientType: endpoint.clientType,
        syncTimeoutSeconds: ref.read(syncTimeoutProvider).inSeconds,
      );

      ref.read(syncProgressProvider.notifier).setPhase(SyncPhase.scanning);

      final runner = ref.read(walletSyncJobRunnerProvider);
      final WalletSyncResult result;
      final attemptStopwatch = Stopwatch()..start();
      try {
        result = await runner(request);
        attemptStopwatch.stop();
      } catch (e) {
        attemptStopwatch.stop();
        if (_stillActive(walletId)) {
          ref.read(syncErrorKindProvider.notifier).set(SyncErrorKind.generic);
          _setSyncStatus(SyncStatus.error);
        } else {
          _setSyncStatus(SyncStatus.idle);
        }
        return;
      }

      if (!_stillActive(walletId)) {
        _setSyncStatus(SyncStatus.idle);
        return;
      }

      if (!result.success) {
        ref.read(syncErrorKindProvider.notifier).set(
          switch (result.failureKind) {
            WalletSyncFailureKind.timeout => SyncErrorKind.timeout,
            _ => SyncErrorKind.generic,
          },
        );
        _setSyncStatus(SyncStatus.error);
        return;
      }

      ref.read(syncProgressProvider.notifier).setPhase(SyncPhase.saving);

      if (result.performedFullScan) {
        await ref.read(walletFullScanMarkerProvider).call(walletId);
      }

      if (!_stillActive(walletId)) {
        _setSyncStatus(SyncStatus.idle);
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
          ref.read(syncErrorKindProvider.notifier).set(SyncErrorKind.generic);
          _setSyncStatus(SyncStatus.error);
        } else {
          _setSyncStatus(SyncStatus.idle);
        }
        return;
      }

      if (!_stillActive(walletId)) {
        reloadedWallet.dispose();
        _setSyncStatus(SyncStatus.idle);
        return;
      }

      final syncedWallet = reloadedWallet;
      ref.read(activeWalletProvider.notifier).replaceWallet(syncedWallet);
      transferredWallet = true;
      ref
          .read(balanceSnapshotProvider.notifier)
          .applyFromWallet(syncedWallet, walletId);
      ref.read(autoSyncedWalletIdsProvider.notifier).mark(walletId);
      _setSyncStatus(SyncStatus.synced);
    } catch (_) {
      if (!transferredWallet) {
        reloadedWallet?.dispose();
      }
      if (_stillActive(walletId)) {
        ref.read(syncErrorKindProvider.notifier).set(SyncErrorKind.generic);
        _setSyncStatus(SyncStatus.error);
      } else {
        _setSyncStatus(SyncStatus.idle);
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
