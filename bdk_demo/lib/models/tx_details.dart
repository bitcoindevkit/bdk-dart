import 'package:bdk_demo/core/utils/formatters.dart';

class TxDetails {
  final String txid;
  final int sent;
  final int received;
  final int fee;
  final double? feeRate;
  final int? balanceDelta;
  final bool pending;
  final int? blockHeight;
  final DateTime? confirmationTime;

  const TxDetails({
    required this.txid,
    required this.sent,
    required this.received,
    this.fee = 0,
    this.feeRate,
    this.balanceDelta,
    this.pending = true,
    this.blockHeight,
    this.confirmationTime,
  });

  int get netAmount => balanceDelta ?? (received - sent);

  String get shortTxid => Formatters.abbreviateTxid(txid);

  String get statusLabel => pending ? 'pending' : 'confirmed';
}
