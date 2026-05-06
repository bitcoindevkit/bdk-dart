import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/models/wallet_record.dart';

enum BlockchainBackend { esplora, electrum }

typedef EsploraBlockchainClientFactory = BlockchainClient Function(String url);
typedef ElectrumBlockchainClientFactory = BlockchainClient Function(String url);

abstract final class BlockchainFeeNormalizer {
  static const stableConfirmationTargets = [1, 3, 6, 12, 24];

  static double electrumToSatPerVb(double electrumFeeBtcPerKvB) =>
      electrumFeeBtcPerKvB * 100000;

  static Map<int, double> stableFeesFromElectrumEstimates(
    double Function(int confirmationBlocks) estimateFee,
  ) {
    return {
      for (final n in stableConfirmationTargets)
        n: electrumToSatPerVb(estimateFee(n)),
    };
  }

  static Map<int, double> stableFeesFromEsploraRaw(Map<int, double> raw) {
    if (raw.isEmpty) {
      throw StateError('Esplora fee estimates map is empty.');
    }
    return {for (final n in stableConfirmationTargets) n: _pickNearest(raw, n)};
  }

  static double _pickNearest(Map<int, double> raw, int target) {
    if (raw.containsKey(target)) return raw[target]!;
    final sortedKeys = raw.keys.toList()..sort();
    int? lowerKey;
    int? upperKey;
    for (final k in sortedKeys) {
      if (k <= target) lowerKey = k;
      if (k >= target) {
        upperKey = k;
        break;
      }
    }
    if (lowerKey == null) return raw[upperKey]!;
    if (upperKey == null) return raw[lowerKey]!;
    if (lowerKey == upperKey) return raw[lowerKey]!;
    final lowerVal = raw[lowerKey]!;
    final upperVal = raw[upperKey]!;
    final span = upperKey - lowerKey;
    final t = span == 0 ? 0.0 : (target - lowerKey) / span;
    return lowerVal + (upperVal - lowerVal) * t;
  }

  static int tipHeightFromElectrumSubscribe(HeaderNotification notification) =>
      notification.height;
}

abstract interface class BlockchainClient {
  BlockchainBackend get backend;

  Map<int, double> getFeeEstimates();

  int getTipHeight();

  void dispose();
}

final class EsploraBlockchainClient implements BlockchainClient {
  EsploraBlockchainClient(this._client);

  final EsploraClient _client;

  @override
  BlockchainBackend get backend => BlockchainBackend.esplora;

  @override
  Map<int, double> getFeeEstimates() =>
      BlockchainFeeNormalizer.stableFeesFromEsploraRaw(
        _client.getFeeEstimates(),
      );

  @override
  int getTipHeight() => _client.getHeight();

  @override
  void dispose() => _client.dispose();
}

final class ElectrumBlockchainClient implements BlockchainClient {
  ElectrumBlockchainClient(this._client);

  final ElectrumClient _client;

  @override
  BlockchainBackend get backend => BlockchainBackend.electrum;

  @override
  Map<int, double> getFeeEstimates() =>
      BlockchainFeeNormalizer.stableFeesFromElectrumEstimates(
        (n) => _client.estimateFee(number: n),
      );

  @override
  int getTipHeight() => BlockchainFeeNormalizer.tipHeightFromElectrumSubscribe(
    _client.blockHeadersSubscribe(),
  );

  @override
  void dispose() => _client.dispose();
}

abstract final class BlockchainService {
  static BlockchainBackend backendForNetwork(WalletNetwork network) {
    final config = defaultEndpoints[network]!;
    return switch (config.clientType) {
      ClientType.esplora => BlockchainBackend.esplora,
      ClientType.electrum => BlockchainBackend.electrum,
    };
  }

  static BlockchainClient createClient(
    WalletNetwork network, {
    EsploraBlockchainClientFactory? esploraFactory,
    ElectrumBlockchainClientFactory? electrumFactory,
  }) {
    final config = defaultEndpoints[network]!;
    return switch (config.clientType) {
      ClientType.esplora =>
        esploraFactory?.call(config.url) ??
            EsploraBlockchainClient(
              EsploraClient(url: config.url, proxy: null),
            ),
      ClientType.electrum =>
        electrumFactory?.call(config.url) ??
            ElectrumBlockchainClient(
              ElectrumClient(url: config.url, socks5: null),
            ),
    };
  }
}
