import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/models/currency_unit.dart';
import 'package:bdk_demo/models/tx_details.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';

class TransactionDetailPage extends ConsumerStatefulWidget {
  final String txid;

  const TransactionDetailPage({super.key, required this.txid});

  @override
  ConsumerState<TransactionDetailPage> createState() =>
      _TransactionDetailPageState();
}

class _TransactionDetailPageState extends ConsumerState<TransactionDetailPage> {
  late Future<TxDetails?> _transactionFuture;

  void _loadTransactionFuture() {
    _transactionFuture = ref
        .read(walletServiceProvider)
        .loadTransactionByTxid(widget.txid);
  }

  @override
  void initState() {
    super.initState();
    _loadTransactionFuture();
  }

  @override
  void didUpdateWidget(covariant TransactionDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.txid != widget.txid) {
      _loadTransactionFuture();
    }
  }

  String _formatAmount(TxDetails transaction) {
    final amount = transaction.netAmount;
    final prefix = amount >= 0 ? '+' : '-';
    final value = Formatters.formatBalance(amount.abs(), CurrencyUnit.satoshi);

    return '$prefix$value';
  }

  String _formatTimestamp(DateTime timestamp) {
    final unixSeconds = timestamp.millisecondsSinceEpoch ~/ 1000;
    return Formatters.formatTimestamp(unixSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Transaction Detail'),
      body: SafeArea(
        child: FutureBuilder<TxDetails?>(
          future: _transactionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const WalletStateCard(
                icon: Icons.hourglass_bottom,
                title: 'Loading transaction',
                message: 'Preparing placeholder transaction details...',
                showSpinner: true,
                centered: true,
              );
            }

            if (snapshot.hasError) {
              return WalletStateCard(
                icon: Icons.error_outline,
                title: 'Transaction unavailable',
                message:
                    'The scaffold could not load placeholder transaction details.',
                accentColor: theme.colorScheme.error,
                centered: true,
              );
            }

            final transaction = snapshot.data;
            if (transaction == null) {
              return WalletStateCard(
                icon: Icons.search_off,
                title: 'Transaction not found',
                message:
                    'No placeholder transaction was found for this txid.\n\n${widget.txid}',
                centered: true,
              );
            }

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _formatAmount(transaction),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            WalletStatusChip(status: transaction.statusLabel),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scaffolded placeholder detail view for the selected transaction.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(170),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full txid',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(170),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          transaction.txid,
                          style: AppTheme.monoStyle.copyWith(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WalletDetailRow(
                          label: 'Amount',
                          value: _formatAmount(transaction),
                        ),
                        const SizedBox(height: 12),
                        WalletDetailRow(
                          label: 'Status',
                          value: transaction.statusLabel,
                        ),
                        if (transaction.blockHeight != null) ...[
                          const SizedBox(height: 12),
                          WalletDetailRow(
                            label: 'Block height',
                            value: '${transaction.blockHeight}',
                          ),
                        ],
                        if (transaction.confirmationTime != null) ...[
                          const SizedBox(height: 12),
                          WalletDetailRow(
                            label: 'Timestamp',
                            value: _formatTimestamp(
                              transaction.confirmationTime!,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
