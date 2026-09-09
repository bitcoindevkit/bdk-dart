import 'package:bdk_demo/core/utils/formatters.dart';

class TransactionHistoryItem {
  final String txid;
  final int sent;
  final int received;
  final bool pending;
  final int? blockHeight;
  final DateTime? confirmationTime;

  const TransactionHistoryItem({
    required this.txid,
    required this.sent,
    required this.received,
    this.pending = true,
    this.blockHeight,
    this.confirmationTime,
  });

  int get netAmount => received - sent;

  String get shortTxid => Formatters.abbreviateTxid(txid);

  String get statusLabel => pending ? 'pending' : 'confirmed';
}
