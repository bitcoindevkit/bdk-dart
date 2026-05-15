import 'package:bdk_demo/features/transactions/models/demo_tx_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class TransactionsRepository {
  Future<List<DemoTxDetails>> loadTransactions();
  Future<DemoTxDetails?> loadTransactionByTxid(String txid);
}

final transactionsRepositoryProvider = Provider<TransactionsRepository>(
  (ref) => DemoTransactionsRepository(),
);

class DemoTransactionsRepository implements TransactionsRepository {
  DemoTransactionsRepository({
    this.delay = const Duration(milliseconds: 150),
    List<DemoTxDetails>? transactions,
  }) : _transactions = transactions ?? _defaultTransactions;

  final Duration delay;
  final List<DemoTxDetails> _transactions;

  static final _defaultTransactions = <DemoTxDetails>[
    DemoTxDetails(
      txid: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      sent: 0,
      received: 42000,
      pending: false,
      blockHeight: 120,
      confirmationTime: DateTime(2024, 1, 2, 3, 4),
    ),
    const DemoTxDetails(
      txid: 'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
      sent: 1600,
      received: 0,
      pending: true,
    ),
  ];

  @override
  Future<List<DemoTxDetails>> loadTransactions() async {
    await Future<void>.delayed(delay);
    return List.unmodifiable(_transactions);
  }

  @override
  Future<DemoTxDetails?> loadTransactionByTxid(String txid) async {
    final transactions = await loadTransactions();
    for (final transaction in transactions) {
      if (transaction.txid == txid) return transaction;
    }
    return null;
  }
}
