import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/network_endpoint_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/blockchain_service.dart';
import 'package:bdk_demo/services/fee_estimates_job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BlockchainClientFactory =
    BlockchainClient Function(WalletNetwork network);

final blockchainClientFactoryProvider = Provider<BlockchainClientFactory>(
  (ref) => BlockchainService.createClient,
);

final feeEstimatesJobRunnerProvider = Provider<FeeEstimatesJobRunner>(
  (ref) => defaultFeeEstimatesJobRunner,
);

final feeEstimatesProvider = FutureProvider<Map<int, double>>((ref) async {
  final record = ref.watch(activeWalletRecordProvider);
  if (record == null) return const {};

  final endpoint = ref.watch(endpointConfigProvider(record.network));
  final runner = ref.read(feeEstimatesJobRunnerProvider);
  return runner(
    FeeEstimatesRequest(
      clientTypeName: endpoint.clientType.name,
      url: endpoint.url,
      timeoutSeconds: defaultFeeEstimatesTimeoutSeconds(),
    ),
  );
});
