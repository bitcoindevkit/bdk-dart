import 'dart:isolate';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/wallet_network_mapper.dart';
import 'package:bdk_demo/services/wallet_sqlite_persistence.dart';

class WalletSyncRequest {
  const WalletSyncRequest({
    required this.walletId,
    required this.descriptor,
    required this.changeDescriptor,
    required this.walletNetworkName,
    required this.sqlitePath,
    required this.fullScanCompleted,
  });

  final String walletId;
  final String descriptor;
  final String changeDescriptor;
  final String walletNetworkName;
  final String sqlitePath;
  final bool fullScanCompleted;
}

class WalletSyncResult {
  const WalletSyncResult._({
    required this.success,
    required this.walletId,
    required this.performedFullScan,
    this.errorMessage,
    this.immatureSat = 0,
    this.trustedPendingSat = 0,
    this.untrustedPendingSat = 0,
    this.confirmedSat = 0,
    this.trustedSpendableSat = 0,
    this.totalSat = 0,
  });

  factory WalletSyncResult.success({
    required String walletId,
    required bool performedFullScan,
    required int immatureSat,
    required int trustedPendingSat,
    required int untrustedPendingSat,
    required int confirmedSat,
    required int trustedSpendableSat,
    required int totalSat,
  }) => WalletSyncResult._(
    success: true,
    walletId: walletId,
    performedFullScan: performedFullScan,
    immatureSat: immatureSat,
    trustedPendingSat: trustedPendingSat,
    untrustedPendingSat: untrustedPendingSat,
    confirmedSat: confirmedSat,
    trustedSpendableSat: trustedSpendableSat,
    totalSat: totalSat,
  );

  factory WalletSyncResult.failure({
    required String walletId,
    required String errorMessage,
    required bool performedFullScan,
  }) => WalletSyncResult._(
    success: false,
    walletId: walletId,
    performedFullScan: performedFullScan,
    errorMessage: errorMessage,
  );

  final bool success;
  final String walletId;
  final bool performedFullScan;
  final String? errorMessage;
  final int immatureSat;
  final int trustedPendingSat;
  final int untrustedPendingSat;
  final int confirmedSat;
  final int trustedSpendableSat;
  final int totalSat;
}

typedef WalletSyncJobRunner =
    Future<WalletSyncResult> Function(WalletSyncRequest request);
typedef WalletSyncBackendFactory =
    WalletSyncBackend Function(WalletNetwork walletNetwork);

Future<WalletSyncResult> defaultWalletSyncJobRunner(WalletSyncRequest request) {
  return Isolate.run(() async {
    return executeWalletSync(request);
  });
}

abstract interface class WalletSyncBackend {
  WalletSyncExecution fullScan(Wallet wallet);

  WalletSyncExecution incrementalSync(Wallet wallet);

  void dispose();
}

class WalletSyncExecution {
  const WalletSyncExecution({required this.apply});

  final void Function(Wallet wallet) apply;
}

final class EsploraWalletSyncBackend implements WalletSyncBackend {
  EsploraWalletSyncBackend(this._client);

  final EsploraClient _client;

  @override
  WalletSyncExecution fullScan(Wallet wallet) {
    final request = wallet.startFullScan().build();
    final update = _client.fullScan(
      request: request,
      stopGap: AppConstants.fullScanStopGap,
      parallelRequests: AppConstants.syncParallelRequests,
    );
    return WalletSyncExecution(
      apply: (wallet) {
        try {
          wallet.applyUpdate(update: update);
        } finally {
          update.dispose();
        }
      },
    );
  }

  @override
  WalletSyncExecution incrementalSync(Wallet wallet) {
    final request = wallet.startSyncWithRevealedSpks().build();
    final update = _client.sync_(
      request: request,
      parallelRequests: AppConstants.syncParallelRequests,
    );
    return WalletSyncExecution(
      apply: (wallet) {
        try {
          wallet.applyUpdate(update: update);
        } finally {
          update.dispose();
        }
      },
    );
  }

  @override
  void dispose() => _client.dispose();
}

final class ElectrumWalletSyncBackend implements WalletSyncBackend {
  ElectrumWalletSyncBackend(this._client);

  final ElectrumClient _client;

  @override
  WalletSyncExecution fullScan(Wallet wallet) {
    final request = wallet.startFullScan().build();
    final update = _client.fullScan(
      request: request,
      stopGap: AppConstants.fullScanStopGap,
      batchSize: AppConstants.electrumSyncBatchSize,
      fetchPrevTxouts: AppConstants.electrumFetchPrevTxouts,
    );
    return WalletSyncExecution(
      apply: (wallet) {
        try {
          wallet.applyUpdate(update: update);
        } finally {
          update.dispose();
        }
      },
    );
  }

  @override
  WalletSyncExecution incrementalSync(Wallet wallet) {
    final request = wallet.startSyncWithRevealedSpks().build();
    final update = _client.sync_(
      request: request,
      batchSize: AppConstants.electrumSyncBatchSize,
      fetchPrevTxouts: AppConstants.electrumFetchPrevTxouts,
    );
    return WalletSyncExecution(
      apply: (wallet) {
        try {
          wallet.applyUpdate(update: update);
        } finally {
          update.dispose();
        }
      },
    );
  }

  @override
  void dispose() => _client.dispose();
}

WalletSyncBackend _defaultWalletSyncBackendFactory(
  WalletNetwork walletNetwork,
) {
  final endpoint = defaultEndpoints[walletNetwork]!;
  return switch (endpoint.clientType) {
    ClientType.esplora => EsploraWalletSyncBackend(
      EsploraClient(url: endpoint.url, proxy: null),
    ),
    ClientType.electrum => ElectrumWalletSyncBackend(
      ElectrumClient(url: endpoint.url, socks5: null),
    ),
  };
}

Wallet _defaultWalletLoadRunner({
  required Descriptor descriptor,
  required Descriptor changeDescriptor,
  required Persister persister,
  required int lookahead,
}) {
  return Wallet.load(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    persister: persister,
    lookahead: lookahead,
  );
}

Future<bool> _defaultPersistRunner(Wallet wallet, Persister persister) async =>
    wallet.persist(persister: persister);

Future<WalletSyncResult> executeWalletSync(
  WalletSyncRequest req, {
  WalletSyncBackendFactory? backendFactory,
  SqliteLoadRunner? walletLoadRunner,
  SqlitePersistRunner? persistRunner,
}) async {
  Wallet? wallet;
  WalletSyncBackend? backend;

  final performedFullScan = !req.fullScanCompleted;

  try {
    final walletNetwork = WalletNetwork.values.byName(req.walletNetworkName);
    final bdkNetwork = walletNetwork.toBdkNetwork();
    final loadRunner = walletLoadRunner ?? _defaultWalletLoadRunner;
    final effectivePersistRunner = persistRunner ?? _defaultPersistRunner;

    final descriptor = Descriptor(
      descriptor: req.descriptor,
      network: bdkNetwork,
    );
    final changeDescriptor = Descriptor(
      descriptor: req.changeDescriptor,
      network: bdkNetwork,
    );

    final persister = Persister.newSqlite(path: req.sqlitePath);
    wallet = loadRunner(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      persister: persister,
      lookahead: AppConstants.walletLookahead,
    );

    backend = (backendFactory ?? _defaultWalletSyncBackendFactory)(
      walletNetwork,
    );
    final execution = performedFullScan
        ? backend.fullScan(wallet)
        : backend.incrementalSync(wallet);
    execution.apply(wallet);

    await persistWalletSqliteWithReopenVerify(
      wallet: wallet,
      persister: persister,
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      dbPath: req.sqlitePath,
      persistRunner: effectivePersistRunner,
      loadRunner: loadRunner,
    );

    final balance = wallet.balance();
    return WalletSyncResult.success(
      walletId: req.walletId,
      performedFullScan: performedFullScan,
      immatureSat: balance.immature.toSat(),
      trustedPendingSat: balance.trustedPending.toSat(),
      untrustedPendingSat: balance.untrustedPending.toSat(),
      confirmedSat: balance.confirmed.toSat(),
      trustedSpendableSat: balance.trustedSpendable.toSat(),
      totalSat: balance.total.toSat(),
    );
  } catch (e, st) {
    return WalletSyncResult.failure(
      walletId: req.walletId,
      performedFullScan: performedFullScan,
      errorMessage: '$e\n$st',
    );
  } finally {
    wallet?.dispose();
    backend?.dispose();
  }
}
