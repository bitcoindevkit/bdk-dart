import 'package:bdk_demo/features/transactions/models/demo_tx_details.dart';

final placeholderTransactions = <DemoTxDetails>[
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
