import 'dart:async';
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
    required this.endpointUrl,
    required this.endpointClientType,
    required this.syncTimeoutSeconds,
  });

  final String walletId;
  final String descriptor;
  final String changeDescriptor;
  final String walletNetworkName;
  final String sqlitePath;
  final bool fullScanCompleted;
  final String endpointUrl;
  final ClientType endpointClientType;
  final int syncTimeoutSeconds;
}

enum WalletSyncFailureKind { generic, timeout }

class WalletSyncResult {
  const WalletSyncResult._({
    required this.success,
    required this.walletId,
    required this.performedFullScan,
    this.errorMessage,
    this.failureKind,
  });

  factory WalletSyncResult.success({
    required String walletId,
    required bool performedFullScan,
  }) => WalletSyncResult._(
    success: true,
    walletId: walletId,
    performedFullScan: performedFullScan,
  );

  factory WalletSyncResult.failure({
    required String walletId,
    required String errorMessage,
    required bool performedFullScan,
    WalletSyncFailureKind failureKind = WalletSyncFailureKind.generic,
  }) => WalletSyncResult._(
    success: false,
    walletId: walletId,
    performedFullScan: performedFullScan,
    errorMessage: errorMessage,
    failureKind: failureKind,
  );

  final bool success;
  final String walletId;
  final bool performedFullScan;
  final String? errorMessage;
  final WalletSyncFailureKind? failureKind;
}

typedef WalletSyncJobRunner =
    Future<WalletSyncResult> Function(WalletSyncRequest request);
typedef WalletSyncBackendFactory =
    WalletSyncBackend Function(
      WalletNetwork walletNetwork,
      EndpointConfig endpoint,
      int syncTimeoutSeconds,
    );

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
  EndpointConfig endpoint,
  int syncTimeoutSeconds,
) {
  return switch (endpoint.clientType) {
    ClientType.esplora => EsploraWalletSyncBackend(
      EsploraClient(url: endpoint.url, proxy: null),
    ),
    ClientType.electrum => ElectrumWalletSyncBackend(
      ElectrumClient(
        url: endpoint.url,
        socks5: null,
        timeout: syncTimeoutSeconds,
        retry: null,
        validateDomain: true,
      ),
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
  final syncStopwatch = Stopwatch()..start();
  Wallet? wallet;
  WalletSyncBackend? backend;
  Descriptor? descriptor;
  Descriptor? changeDescriptor;
  Persister? persister;

  final performedFullScan = !req.fullScanCompleted;

  try {
    final walletNetwork = WalletNetwork.values.byName(req.walletNetworkName);
    final bdkNetworkKind = walletNetwork.toBdkNetworkKind();
    final loadRunner = walletLoadRunner ?? _defaultWalletLoadRunner;
    final effectivePersistRunner = persistRunner ?? _defaultPersistRunner;

    descriptor = Descriptor(
      descriptor: req.descriptor,
      networkKind: bdkNetworkKind,
    );
    changeDescriptor = Descriptor(
      descriptor: req.changeDescriptor,
      networkKind: bdkNetworkKind,
    );

    persister = Persister.newSqlite(path: req.sqlitePath);
    wallet = loadRunner(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      persister: persister,
      lookahead: AppConstants.walletLookahead,
    );

    backend = (backendFactory ?? _defaultWalletSyncBackendFactory)(
      walletNetwork,
      EndpointConfig(clientType: req.endpointClientType, url: req.endpointUrl),
      req.syncTimeoutSeconds,
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

    return WalletSyncResult.success(
      walletId: req.walletId,
      performedFullScan: performedFullScan,
    );
  } on TimeoutException catch (e, st) {
    return WalletSyncResult.failure(
      walletId: req.walletId,
      performedFullScan: performedFullScan,
      errorMessage: '$e\n$st',
      failureKind: WalletSyncFailureKind.timeout,
    );
  } catch (e, st) {
    return WalletSyncResult.failure(
      walletId: req.walletId,
      performedFullScan: performedFullScan,
      errorMessage: '$e\n$st',
      failureKind: _classifySyncFailure(
        e,
        elapsed: syncStopwatch.elapsed,
        timeoutSeconds: req.syncTimeoutSeconds,
      ),
    );
  } finally {
    syncStopwatch.stop();
    wallet?.dispose();
    backend?.dispose();
    persister?.dispose();
    descriptor?.dispose();
    changeDescriptor?.dispose();
  }
}

WalletSyncFailureKind _classifySyncFailure(
  Object error, {
  required Duration elapsed,
  required int timeoutSeconds,
}) {
  final timeoutWindow = Duration(seconds: timeoutSeconds);
  final timeoutLikeBuffer = const Duration(seconds: 3);
  final timeoutLikeThreshold = timeoutWindow > timeoutLikeBuffer
      ? timeoutWindow - timeoutLikeBuffer
      : Duration.zero;
  final nearTimeout = elapsed >= timeoutLikeThreshold;
  final allAttemptsErrored = error.toString().contains(
    'AllAttemptsErroredElectrumException',
  );

  if (nearTimeout && allAttemptsErrored) {
    return WalletSyncFailureKind.timeout;
  }

  return WalletSyncFailureKind.generic;
}
