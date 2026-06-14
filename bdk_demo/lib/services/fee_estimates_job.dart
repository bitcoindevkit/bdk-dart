import 'dart:isolate';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/services/blockchain_service.dart';

class FeeEstimatesRequest {
  const FeeEstimatesRequest({
    required this.clientTypeName,
    required this.url,
    required this.timeoutSeconds,
  });

  final String clientTypeName;
  final String url;
  final int timeoutSeconds;
}

typedef FeeEstimatesJobRunner =
    Future<Map<int, double>> Function(FeeEstimatesRequest request);

Future<Map<int, double>> defaultFeeEstimatesJobRunner(
  FeeEstimatesRequest request,
) {
  return Isolate.run(() => executeFeeEstimatesFetch(request));
}

Map<int, double> executeFeeEstimatesFetch(FeeEstimatesRequest request) {
  final clientType = ClientType.values.byName(request.clientTypeName);
  final endpoint = EndpointConfig(clientType: clientType, url: request.url);
  final client = _createBlockchainClient(
    endpoint,
    timeoutSeconds: request.timeoutSeconds,
  );
  try {
    return client.getFeeEstimates();
  } finally {
    client.dispose();
  }
}

BlockchainClient _createBlockchainClient(
  EndpointConfig endpoint, {
  required int timeoutSeconds,
}) {
  return switch (endpoint.clientType) {
    ClientType.esplora => EsploraBlockchainClient(
      EsploraClient(url: endpoint.url, proxy: null),
    ),
    ClientType.electrum => ElectrumBlockchainClient(
      ElectrumClient(
        url: endpoint.url,
        socks5: null,
        timeout: timeoutSeconds,
        retry: null,
        validateDomain: true,
      ),
    ),
  };
}

int defaultFeeEstimatesTimeoutSeconds() => AppConstants.syncTimeout.inSeconds;
