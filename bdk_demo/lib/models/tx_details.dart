class TxDetails {
  final String txid;
  final int sent;
  final int received;
  final int fee;
  final double? feeRate;
  final bool pending;
  final int? blockHeight;
  final DateTime? confirmationTime;

  const TxDetails({
    required this.txid,
    required this.sent,
    required this.received,
    this.fee = 0,
    this.feeRate,
    this.pending = true,
    this.blockHeight,
    this.confirmationTime,
  });

  int get netAmount => received - sent;

  String get shortTxid =>
      txid.length > 16
          ? '${txid.substring(0, 8)}...${txid.substring(txid.length - 8)}'
          : txid;
}
