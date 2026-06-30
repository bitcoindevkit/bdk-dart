import 'package:bdk_demo/features/transactions/transaction_history_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionHistoryMapper', () {
    test('maps confirmed wallet transaction data', () {
      final item = TransactionHistoryMapper.fromWalletData(
        txid: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
        sent: 1200,
        received: 42000,
        position: const ConfirmedTransactionPosition(
          blockHeight: 120,
          confirmationTime: 1704164640,
        ),
      );

      expect(
        item.txid,
        '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      );
      expect(item.sent, 1200);
      expect(item.received, 42000);
      expect(item.netAmount, 40800);
      expect(item.pending, isFalse);
      expect(item.blockHeight, 120);
      expect(
        item.confirmationTime,
        DateTime.fromMillisecondsSinceEpoch(1704164640000),
      );
      expect(item.statusLabel, 'confirmed');
    });

    test('maps unconfirmed wallet transaction data as pending', () {
      final item = TransactionHistoryMapper.fromWalletData(
        txid:
            'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
        sent: 1600,
        received: 0,
        position: const UnconfirmedTransactionPosition(timestamp: 1704164640),
      );

      expect(item.sent, 1600);
      expect(item.received, 0);
      expect(item.netAmount, -1600);
      expect(item.pending, isTrue);
      expect(item.blockHeight, isNull);
      expect(item.confirmationTime, isNull);
      expect(item.statusLabel, 'pending');
    });
  });
}
