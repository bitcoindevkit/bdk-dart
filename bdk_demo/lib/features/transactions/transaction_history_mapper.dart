import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';

sealed class TransactionHistoryPosition {
  const TransactionHistoryPosition();
}

class ConfirmedTransactionPosition extends TransactionHistoryPosition {
  final int blockHeight;
  final int confirmationTime;

  const ConfirmedTransactionPosition({
    required this.blockHeight,
    required this.confirmationTime,
  });
}

class UnconfirmedTransactionPosition extends TransactionHistoryPosition {
  final int? timestamp;

  const UnconfirmedTransactionPosition({this.timestamp});
}

class TransactionHistoryMapper {
  const TransactionHistoryMapper._();

  static TransactionHistoryItem fromWalletData({
    required String txid,
    required int sent,
    required int received,
    required TransactionHistoryPosition position,
  }) {
    return switch (position) {
      ConfirmedTransactionPosition() => TransactionHistoryItem(
        txid: txid,
        sent: sent,
        received: received,
        pending: false,
        blockHeight: position.blockHeight,
        confirmationTime: DateTime.fromMillisecondsSinceEpoch(
          position.confirmationTime * 1000,
          isUtc: true,
        ),
      ),
      UnconfirmedTransactionPosition() => TransactionHistoryItem(
        txid: txid,
        sent: sent,
        received: received,
        pending: true,
      ),
    };
  }
}
