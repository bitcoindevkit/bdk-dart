import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/blockchain_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BlockchainClientFactory =
    BlockchainClient Function(WalletNetwork network);

final blockchainClientFactoryProvider = Provider<BlockchainClientFactory>(
  (ref) => BlockchainService.createClient,
);

final feeEstimatesProvider = FutureProvider<Map<int, double>>((ref) async {
  final record = ref.watch(activeWalletRecordProvider);
  if (record == null) return const {};

  final client = ref.read(blockchainClientFactoryProvider).call(record.network);
  try {
    return client.getFeeEstimates();
  } finally {
    client.dispose();
  }
});
