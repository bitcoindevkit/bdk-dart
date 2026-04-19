import 'package:bdk_demo/features/transactions/models/demo_tx_details.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';

class FakeTransactionsRepository implements TransactionsRepository {
  FakeTransactionsRepository({
    required this.transactions,
    this.throwOnLoad = false,
  });

  final List<DemoTxDetails> transactions;
  final bool throwOnLoad;

  @override
  Future<List<DemoTxDetails>> loadTransactions() async {
    if (throwOnLoad) {
      throw Exception('forced transaction load failure');
    }
    return transactions;
  }

  @override
  Future<DemoTxDetails?> loadTransactionByTxid(String txid) async {
    final items = await loadTransactions();
    for (final transaction in items) {
      if (transaction.txid == txid) return transaction;
    }
    return null;
  }
}
