import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';

class FakeTransactionsRepository implements TransactionsRepository {
  FakeTransactionsRepository({
    required this.transactions,
    this.throwOnLoad = false,
  });

  final List<TransactionHistoryItem> transactions;
  final bool throwOnLoad;

  @override
  Future<List<TransactionHistoryItem>> loadTransactions() async {
    if (throwOnLoad) {
      throw Exception('forced transaction load failure');
    }
    return transactions;
  }

  @override
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid) async {
    final items = await loadTransactions();
    for (final transaction in items) {
      if (transaction.txid == txid) return transaction;
    }
    return null;
  }
}
