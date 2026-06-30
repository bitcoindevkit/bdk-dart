import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class TransactionsRepository {
  Future<List<TransactionHistoryItem>> loadTransactions();
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid);
}

final transactionsRepositoryProvider = Provider<TransactionsRepository>(
  (ref) => DemoTransactionsRepository(),
);

class DemoTransactionsRepository implements TransactionsRepository {
  DemoTransactionsRepository({
    this.delay = const Duration(milliseconds: 150),
    List<TransactionHistoryItem>? transactions,
  }) : _transactions = transactions ?? _defaultTransactions;

  final Duration delay;
  final List<TransactionHistoryItem> _transactions;

  static final _defaultTransactions = <TransactionHistoryItem>[
    TransactionHistoryItem(
      txid: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      sent: 0,
      received: 42000,
      pending: false,
      blockHeight: 120,
      confirmationTime: DateTime(2024, 1, 2, 3, 4),
    ),
    const TransactionHistoryItem(
      txid: 'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
      sent: 1600,
      received: 0,
      pending: true,
    ),
  ];

  @override
  Future<List<TransactionHistoryItem>> loadTransactions() async {
    await Future<void>.delayed(delay);
    return List.unmodifiable(_transactions);
  }

  @override
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid) async {
    final transactions = await loadTransactions();
    for (final transaction in transactions) {
      if (transaction.txid == txid) return transaction;
    }
    return null;
  }
}
