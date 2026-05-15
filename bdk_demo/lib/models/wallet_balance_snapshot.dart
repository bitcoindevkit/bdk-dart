class WalletBalanceSnapshot {
  const WalletBalanceSnapshot({
    required this.walletId,
    required this.immatureSat,
    required this.trustedPendingSat,
    required this.untrustedPendingSat,
    required this.confirmedSat,
    required this.trustedSpendableSat,
    required this.totalSat,
  });

  final String walletId;
  final int immatureSat;
  final int trustedPendingSat;
  final int untrustedPendingSat;
  final int confirmedSat;
  final int trustedSpendableSat;
  final int totalSat;
}
