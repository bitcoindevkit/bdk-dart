import 'package:bdk_demo/features/transactions/transaction_history_mapper.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTransactionHistorySource implements TransactionHistorySource {
  _FakeTransactionHistorySource(this.records);

  final List<TransactionHistoryRecord> records;

  @override
  List<TransactionHistoryRecord> transactions() => records;

  @override
  TransactionHistoryRecord? transactionByTxid(String txid) {
    for (final transaction in records) {
      if (transaction.txid == txid) return transaction;
    }
    return null;
  }
}

void main() {
  group('WalletTransactionsRepository', () {
    test('returns empty history when no active wallet is available', () async {
      final repository = WalletTransactionsRepository(source: null);

      final transactions = await repository.loadTransactions();

      expect(transactions, isEmpty);
    });

    test('maps wallet transaction records into history items', () async {
      final repository = WalletTransactionsRepository(
        source: _FakeTransactionHistorySource([
          const TransactionHistoryRecord(
            txid:
                '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
            sent: 1200,
            received: 42000,
            position: ConfirmedTransactionPosition(
              blockHeight: 120,
              confirmationTime: 1704164640,
            ),
          ),
          const TransactionHistoryRecord(
            txid:
                'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
            sent: 1600,
            received: 0,
            position: UnconfirmedTransactionPosition(),
          ),
        ]),
      );

      final transactions = await repository.loadTransactions();

      expect(transactions, hasLength(2));
      expect(transactions.first.txid, startsWith('123456'));
      expect(transactions.first.netAmount, 40800);
      expect(transactions.first.pending, isFalse);
      expect(transactions.first.blockHeight, 120);
      expect(transactions.last.netAmount, -1600);
      expect(transactions.last.pending, isTrue);
    });

    test('loads a transaction detail by txid from wallet records', () async {
      final repository = WalletTransactionsRepository(
        source: _FakeTransactionHistorySource([
          const TransactionHistoryRecord(
            txid:
                '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
            sent: 0,
            received: 42000,
            position: ConfirmedTransactionPosition(
              blockHeight: 120,
              confirmationTime: 1704164640,
            ),
          ),
        ]),
      );

      final transaction = await repository.loadTransactionByTxid(
        '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      );

      expect(transaction, isNotNull);
      expect(transaction!.received, 42000);
    });
  });
}
