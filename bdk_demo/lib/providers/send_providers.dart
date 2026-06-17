import 'package:bdk_dart/bdk.dart';
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

class SendTransactionDraft {
  const SendTransactionDraft({required this.feeSat, required this.broadcast});

  final int? feeSat;
  final Future<String> Function(BlockchainClient client) broadcast;
}

typedef SendTransactionDraftBuilder =
    Future<SendTransactionDraft> Function({
      required WalletRecord record,
      required Wallet wallet,
      required String recipientAddress,
      required int amountSat,
      required int feeRateSatPerVb,
    });

final sendTransactionDraftBuilderProvider =
    Provider<SendTransactionDraftBuilder>((ref) {
      final walletService = ref.read(walletServiceProvider);
      return ({
        required record,
        required wallet,
        required recipientAddress,
        required amountSat,
        required feeRateSatPerVb,
      }) async {
        final psbt = await walletService.buildTransaction(
          record,
          wallet,
          recipientAddress,
          amountSat,
          feeRateSatPerVb,
        );
        return SendTransactionDraft(
          feeSat: psbt.fee(),
          broadcast: (client) async => (await walletService.signAndBroadcast(
            record,
            wallet,
            psbt,
            client,
          )).toString(),
        );
      };
    });

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
