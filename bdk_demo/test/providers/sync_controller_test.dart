import 'dart:async';
import 'dart:io';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/blockchain_providers.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:bdk_demo/services/wallet_sync_job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _testExtendedPrivKey =
    'tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B';

Wallet _createTestWallet() {
  final descriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
    networkKind: NetworkKind.test,
  );
  final changeDescriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
    networkKind: NetworkKind.test,
  );
  return Wallet(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    network: Network.testnet,
    persister: Persister.newInMemory(),
    lookahead: 25,
  );
}

Future<ProviderContainer> _createContainer([
  List<dynamic>? extraOverrides,
]) async {
  final dir = await Directory.systemTemp.createTemp('sync_controller_test_');
  WalletStoragePaths.setDocumentsRootOverride(dir);
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs: prefs);
  final walletService = WalletService(storage: storage, uuid: const Uuid());

  final container = ProviderContainer(
    overrides: [
      storageServiceProvider.overrideWithValue(storage),
      walletServiceProvider.overrideWithValue(walletService),
      ...(extraOverrides ?? const []),
    ],
  );
  addTearDown(() async {
    container.dispose();
    WalletStoragePaths.setDocumentsRootOverride(null);
    if (dir.existsSync()) await dir.delete(recursive: true);
  });
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SyncController', () {
    test(
      'second sync after first full scan uses incremental request',
      () async {
        final requests = <bool>[];
        final container = await _createContainer([
          walletSyncJobRunnerProvider.overrideWithValue((
            WalletSyncRequest req,
          ) async {
            requests.add(req.fullScanCompleted);
            return WalletSyncResult.success(
              walletId: req.walletId,
              performedFullScan: !req.fullScanCompleted,
            );
          }),
        ]);
        final walletService = container.read(walletServiceProvider);

        final (record, wallet) = await walletService.createWallet(
          'Repeat Sync',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );

        container.read(walletRecordsProvider.notifier).refresh();
        container.read(activeWalletRecordProvider.notifier).set(record);
        container.read(activeWalletProvider.notifier).set(wallet);

        await container
            .read(syncControllerProvider.notifier)
            .syncActiveWallet();
        await container
            .read(syncControllerProvider.notifier)
            .syncActiveWallet();

        expect(requests, [false, true]);
        expect(
          container.read(activeWalletRecordProvider)?.fullScanCompleted,
          isTrue,
        );
      },
    );

    test(
      'idle -> syncing -> synced and balance snapshot comes from reloaded wallet',
      () async {
        final container = await _createContainer([
          walletSyncJobRunnerProvider.overrideWithValue((
            WalletSyncRequest req,
          ) async {
            return WalletSyncResult.success(
              walletId: req.walletId,
              performedFullScan: true,
            );
          }),
        ]);
        final storage = container.read(storageServiceProvider);
        final walletService = container.read(walletServiceProvider);

        final (record, wallet) = await walletService.createWallet(
          'Sync A',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );

        container.read(walletRecordsProvider.notifier).refresh();
        container.read(activeWalletRecordProvider.notifier).set(record);
        container.read(activeWalletProvider.notifier).set(wallet);

        await container
            .read(syncControllerProvider.notifier)
            .syncActiveWallet();

        expect(container.read(syncStatusProvider), SyncStatus.synced);
        final snap = container.read(balanceSnapshotProvider);
        expect(snap, isNotNull);
        expect(snap!.walletId, record.id);
        expect(snap.confirmedSat, 0);

        final updated = storage.getWalletRecords().firstWhere(
          (r) => r.id == record.id,
        );
        expect(updated.fullScanCompleted, isTrue);
        expect(container.read(syncProgressProvider).phase, SyncPhase.upToDate);
      },
    );

    test('advances sync progress phases during sync', () async {
      final gate = Completer<void>();
      SyncPhase? phaseWhenRunnerStarts;
      addTearDown(() {
        if (!gate.isCompleted) gate.complete();
      });

      late ProviderContainer container;
      container = await _createContainer([
        walletSyncJobRunnerProvider.overrideWithValue((
          WalletSyncRequest req,
        ) async {
          phaseWhenRunnerStarts = container.read(syncProgressProvider).phase;
          await gate.future;
          return WalletSyncResult.success(
            walletId: req.walletId,
            performedFullScan: true,
          );
        }),
      ]);
      final walletService = container.read(walletServiceProvider);
      final (record, wallet) = await walletService.createWallet(
        'Progress Wallet',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(walletRecordsProvider.notifier).refresh();
      container.read(activeWalletRecordProvider.notifier).set(record);
      container.read(activeWalletProvider.notifier).set(wallet);

      final syncFuture = container
          .read(syncControllerProvider.notifier)
          .syncActiveWallet();

      while (phaseWhenRunnerStarts == null) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(phaseWhenRunnerStarts, SyncPhase.scanning);

      gate.complete();
      await syncFuture;

      expect(container.read(syncProgressProvider).phase, SyncPhase.upToDate);
    });

    test('switching wallets clears snapshot for previous wallet', () async {
      final container = await _createContainer([
        walletSyncJobRunnerProvider.overrideWithValue((
          WalletSyncRequest req,
        ) async {
          return WalletSyncResult.success(
            walletId: req.walletId,
            performedFullScan: true,
          );
        }),
      ]);
      final walletService = container.read(walletServiceProvider);

      final (recordA, walletA) = await walletService.createWallet(
        'Wallet Snapshot A',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      final (recordB, walletB) = await walletService.createWallet(
        'Wallet Snapshot B',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(walletRecordsProvider.notifier).refresh();
      container.read(activeWalletRecordProvider.notifier).set(recordA);
      container.read(activeWalletProvider.notifier).set(walletA);

      await container.read(syncControllerProvider.notifier).syncActiveWallet();
      expect(container.read(balanceSnapshotProvider)?.walletId, recordA.id);

      container.read(activeWalletRecordProvider.notifier).set(recordB);
      container.read(activeWalletProvider.notifier).set(walletB);

      expect(container.read(balanceSnapshotProvider), isNull);
    });

    test('failure path sets error', () async {
      final container = await _createContainer([
        walletSyncJobRunnerProvider.overrideWithValue((
          WalletSyncRequest req,
        ) async {
          return WalletSyncResult.failure(
            walletId: req.walletId,
            errorMessage: 'boom',
            performedFullScan: false,
          );
        }),
      ]);
      final walletService = container.read(walletServiceProvider);

      final (record, wallet) = await walletService.createWallet(
        'Sync B',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(walletRecordsProvider.notifier).refresh();
      container.read(activeWalletRecordProvider.notifier).set(record);
      container.read(activeWalletProvider.notifier).set(wallet);

      await container.read(syncControllerProvider.notifier).syncActiveWallet();

      expect(container.read(syncStatusProvider), SyncStatus.error);
    });

    test('path resolution failure normalizes syncing to error', () async {
      final container = await _createContainer([
        walletSqlitePathResolverProvider.overrideWithValue((_) async {
          throw StateError('path boom');
        }),
      ]);
      final walletService = container.read(walletServiceProvider);

      final (record, wallet) = await walletService.createWallet(
        'Path Failure',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(walletRecordsProvider.notifier).refresh();
      container.read(activeWalletRecordProvider.notifier).set(record);
      container.read(activeWalletProvider.notifier).set(wallet);

      await container.read(syncControllerProvider.notifier).syncActiveWallet();

      expect(container.read(syncStatusProvider), SyncStatus.error);
    });

    test('missing secrets sets error', () async {
      final container = await _createContainer([
        walletSyncJobRunnerProvider.overrideWithValue((_) async {
          fail('runner should not be invoked');
        }),
      ]);

      final record = WalletRecord(
        id: 'no-secrets',
        name: 'Ghost',
        network: WalletNetwork.testnet,
        scriptType: ScriptType.p2wpkh,
      );

      container.read(activeWalletRecordProvider.notifier).set(record);
      container.read(activeWalletProvider.notifier).set(_createTestWallet());

      await container.read(syncControllerProvider.notifier).syncActiveWallet();

      expect(container.read(syncStatusProvider), SyncStatus.error);
    });

    test('stale completion resets sync status to idle', () async {
      final completer = Completer<WalletSyncResult>();
      final container = await _createContainer([
        walletSyncJobRunnerProvider.overrideWithValue((_) async {
          return completer.future;
        }),
      ]);
      final walletService = container.read(walletServiceProvider);

      final (recordA, walletA) = await walletService.createWallet(
        'Wallet A',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      final (recordB, walletB) = await walletService.createWallet(
        'Wallet B',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(walletRecordsProvider.notifier).refresh();
      container.read(activeWalletRecordProvider.notifier).set(recordA);
      container.read(activeWalletProvider.notifier).set(walletA);

      final syncFuture = container
          .read(syncControllerProvider.notifier)
          .syncActiveWallet();

      expect(container.read(syncStatusProvider), SyncStatus.syncing);

      container.read(activeWalletRecordProvider.notifier).set(recordB);
      container.read(activeWalletProvider.notifier).set(walletB);

      completer.complete(
        WalletSyncResult.success(walletId: recordA.id, performedFullScan: true),
      );

      await syncFuture;

      expect(container.read(syncStatusProvider), SyncStatus.idle);
      expect(container.read(balanceSnapshotProvider), isNull);
      expect(container.read(activeWalletRecordProvider)?.id, recordB.id);
    });

    test('times out slow sync and records timeout error kind', () async {
      final container = await _createContainer([
        walletSyncJobRunnerProvider.overrideWithValue((
          WalletSyncRequest req,
        ) async {
          return WalletSyncResult.failure(
            walletId: req.walletId,
            performedFullScan: true,
            errorMessage: 'sync timed out',
            failureKind: WalletSyncFailureKind.timeout,
          );
        }),
      ]);
      final walletService = container.read(walletServiceProvider);
      final (record, wallet) = await walletService.createWallet(
        'Timeout Wallet',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(walletRecordsProvider.notifier).refresh();
      container.read(activeWalletRecordProvider.notifier).set(record);
      container.read(activeWalletProvider.notifier).set(wallet);

      await container.read(syncControllerProvider.notifier).syncActiveWallet();

      expect(container.read(syncStatusProvider), SyncStatus.error);
      expect(container.read(syncErrorKindProvider), SyncErrorKind.timeout);
    });
  });
}
