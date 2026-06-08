import 'dart:async';
import 'dart:io';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/wallet_sqlite_persistence.dart';
import 'package:bdk_demo/services/wallet_sync_job.dart';
import 'package:flutter_test/flutter_test.dart';

const _testExtendedPrivKey =
    'tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B';

Network _bdkNetwork(WalletNetwork walletNetwork) => switch (walletNetwork) {
  WalletNetwork.signet => Network.signet,
  WalletNetwork.testnet => Network.testnet,
  WalletNetwork.regtest => Network.regtest,
};

Future<({String dbPath, String descriptor, String changeDescriptor})>
_createSqliteWalletFixture(WalletNetwork walletNetwork) async {
  final dir = await Directory.systemTemp.createTemp('wallet_sync_job_');
  addTearDown(() async {
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  });

  final bdkNetwork = _bdkNetwork(walletNetwork);
  final descriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
    networkKind: NetworkKind.test,
  );
  final changeDescriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
    networkKind: NetworkKind.test,
  );
  final dbPath = '${dir.path}/wallet.sqlite';
  final persister = Persister.newSqlite(path: dbPath);
  final wallet = Wallet(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    network: bdkNetwork,
    persister: persister,
    lookahead: AppConstants.walletLookahead,
  );
  await persistWalletSqliteWithReopenVerify(
    wallet: wallet,
    persister: persister,
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    dbPath: dbPath,
  );
  wallet.dispose();

  return (
    dbPath: dbPath,
    descriptor: descriptor.toStringWithSecret(),
    changeDescriptor: changeDescriptor.toStringWithSecret(),
  );
}

final class _FakeSyncBackend implements WalletSyncBackend {
  _FakeSyncBackend({this.onFullScan, this.onIncrementalSync});

  final void Function()? onFullScan;
  final void Function()? onIncrementalSync;

  @override
  void dispose() {}

  @override
  WalletSyncExecution fullScan(Wallet wallet) {
    onFullScan?.call();
    return const WalletSyncExecution(apply: _noopApply);
  }

  @override
  WalletSyncExecution incrementalSync(Wallet wallet) {
    onIncrementalSync?.call();
    return const WalletSyncExecution(apply: _noopApply);
  }
}

void _noopApply(Wallet wallet) {}

WalletSyncRequest _syncRequest({
  required String walletId,
  required String descriptor,
  required String changeDescriptor,
  required String walletNetworkName,
  required String sqlitePath,
  required bool fullScanCompleted,
  int? syncTimeoutSeconds,
}) {
  final network = WalletNetwork.values.byName(walletNetworkName);
  final endpoint = defaultEndpoints[network]!;
  return WalletSyncRequest(
    walletId: walletId,
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    walletNetworkName: walletNetworkName,
    sqlitePath: sqlitePath,
    fullScanCompleted: fullScanCompleted,
    endpointUrl: endpoint.url,
    endpointClientType: endpoint.clientType,
    syncTimeoutSeconds:
        syncTimeoutSeconds ?? AppConstants.syncTimeout.inSeconds,
  );
}

void main() {
  group('executeWalletSync', () {
    test('full scan path uses backend fullScan for regtest', () async {
      final fixture = await _createSqliteWalletFixture(WalletNetwork.regtest);
      var selectedNetwork = WalletNetwork.testnet;
      var fullScanCalls = 0;
      var incrementalCalls = 0;

      final result = await executeWalletSync(
        _syncRequest(
          walletId: 'wallet-a',
          descriptor: fixture.descriptor,
          changeDescriptor: fixture.changeDescriptor,
          walletNetworkName: WalletNetwork.regtest.name,
          sqlitePath: fixture.dbPath,
          fullScanCompleted: false,
        ),
        backendFactory: (walletNetwork, endpoint, syncTimeout) {
          selectedNetwork = walletNetwork;
          return _FakeSyncBackend(
            onFullScan: () => fullScanCalls += 1,
            onIncrementalSync: () => incrementalCalls += 1,
          );
        },
      );

      expect(result.success, isTrue);
      expect(result.performedFullScan, isTrue);
      expect(selectedNetwork, WalletNetwork.regtest);
      expect(fullScanCalls, 1);
      expect(incrementalCalls, 0);
    });

    test(
      'incremental path uses backend incremental sync for testnet',
      () async {
        final fixture = await _createSqliteWalletFixture(WalletNetwork.testnet);
        var selectedNetwork = WalletNetwork.regtest;
        var fullScanCalls = 0;
        var incrementalCalls = 0;

        final result = await executeWalletSync(
          _syncRequest(
            walletId: 'wallet-b',
            descriptor: fixture.descriptor,
            changeDescriptor: fixture.changeDescriptor,
            walletNetworkName: WalletNetwork.testnet.name,
            sqlitePath: fixture.dbPath,
            fullScanCompleted: true,
          ),
          backendFactory: (walletNetwork, endpoint, syncTimeout) {
            selectedNetwork = walletNetwork;
            return _FakeSyncBackend(
              onFullScan: () => fullScanCalls += 1,
              onIncrementalSync: () => incrementalCalls += 1,
            );
          },
        );

        expect(result.success, isTrue);
        expect(result.performedFullScan, isFalse);
        expect(selectedNetwork, WalletNetwork.testnet);
        expect(fullScanCalls, 0);
        expect(incrementalCalls, 1);
      },
    );

    test(
      'persistence failure after apply is returned as sync failure',
      () async {
        final fixture = await _createSqliteWalletFixture(WalletNetwork.testnet);
        var loadCalls = 0;

        final result = await executeWalletSync(
          _syncRequest(
            walletId: 'wallet-c',
            descriptor: fixture.descriptor,
            changeDescriptor: fixture.changeDescriptor,
            walletNetworkName: WalletNetwork.testnet.name,
            sqlitePath: fixture.dbPath,
            fullScanCompleted: false,
          ),
          backendFactory: (_, __, ___) => _FakeSyncBackend(onFullScan: () {}),
          walletLoadRunner:
              ({
                required Descriptor descriptor,
                required Descriptor changeDescriptor,
                required Persister persister,
                required int lookahead,
              }) {
                loadCalls += 1;
                if (loadCalls == 1) {
                  return Wallet.load(
                    descriptor: descriptor,
                    changeDescriptor: changeDescriptor,
                    persister: persister,
                    lookahead: lookahead,
                  );
                }
                throw StateError('reopen failed');
              },
          persistRunner: (_, __) async => false,
        );

        expect(result.success, isFalse);
        expect(
          result.errorMessage,
          contains('Wallet SQLite persistence returned false.'),
        );
      },
    );

    test('timeout inside sync job is returned as timeout failure', () async {
      final fixture = await _createSqliteWalletFixture(WalletNetwork.testnet);

      final result = await executeWalletSync(
        _syncRequest(
          walletId: 'wallet-timeout',
          descriptor: fixture.descriptor,
          changeDescriptor: fixture.changeDescriptor,
          walletNetworkName: WalletNetwork.testnet.name,
          sqlitePath: fixture.dbPath,
          fullScanCompleted: false,
        ),
        backendFactory: (_, __, ___) => _FakeSyncBackend(
          onFullScan: () => throw TimeoutException('sync timed out'),
        ),
      );

      expect(result.success, isFalse);
      expect(result.failureKind, WalletSyncFailureKind.timeout);
    });

    test(
      'near-timeout Electrum all-attempts failure is returned as timeout',
      () async {
        final fixture = await _createSqliteWalletFixture(WalletNetwork.signet);

        final result = await executeWalletSync(
          _syncRequest(
            walletId: 'wallet-all-attempts-timeout',
            descriptor: fixture.descriptor,
            changeDescriptor: fixture.changeDescriptor,
            walletNetworkName: WalletNetwork.signet.name,
            sqlitePath: fixture.dbPath,
            fullScanCompleted: false,
            syncTimeoutSeconds: 0,
          ),
          backendFactory: (_, __, ___) => _FakeSyncBackend(
            onFullScan: () =>
                throw StateError('AllAttemptsErroredElectrumException'),
          ),
        );

        expect(result.success, isFalse);
        expect(result.failureKind, WalletSyncFailureKind.timeout);
      },
    );
  });

  group('persistWalletSqliteWithReopenVerify', () {
    test(
      'throws when persist returns false and SQLite cannot be reopened',
      () async {
        final dir = await Directory.systemTemp.createTemp('persist_fail_');
        addTearDown(() async {
          if (dir.existsSync()) await dir.delete(recursive: true);
        });
        final dbPath = '${dir.path}/missing.sqlite';
        final descriptor = Descriptor(
          descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
          networkKind: NetworkKind.test,
        );
        final changeDescriptor = Descriptor(
          descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
          networkKind: NetworkKind.test,
        );
        final persister = Persister.newSqlite(path: dbPath);
        final wallet = Wallet(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: persister,
          lookahead: AppConstants.walletLookahead,
        );
        addTearDown(wallet.dispose);

        expect(
          () => persistWalletSqliteWithReopenVerify(
            wallet: wallet,
            persister: persister,
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            dbPath: dbPath,
            persistRunner: (_, __) async => false,
            loadRunner:
                ({
                  required Descriptor descriptor,
                  required Descriptor changeDescriptor,
                  required Persister persister,
                  required int lookahead,
                }) {
                  throw StateError('reopen failed');
                },
          ),
          throwsA(isA<StateError>()),
        );
      },
    );

    test('accepts persist false when reopen verification succeeds', () async {
      final dir = await Directory.systemTemp.createTemp('persist_ok_');
      addTearDown(() async {
        if (dir.existsSync()) await dir.delete(recursive: true);
      });
      final dbPath = '${dir.path}/ok.sqlite';
      final descriptor = Descriptor(
        descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
        networkKind: NetworkKind.test,
      );
      final changeDescriptor = Descriptor(
        descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
        networkKind: NetworkKind.test,
      );
      final persister = Persister.newSqlite(path: dbPath);
      final wallet = Wallet(
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        network: Network.testnet,
        persister: persister,
        lookahead: AppConstants.walletLookahead,
      );
      addTearDown(wallet.dispose);

      await persistWalletSqliteWithReopenVerify(
        wallet: wallet,
        persister: persister,
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        dbPath: dbPath,
      );

      await persistWalletSqliteWithReopenVerify(
        wallet: wallet,
        persister: persister,
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        dbPath: dbPath,
        persistRunner: (_, __) async => false,
      );
    });
  });
}
