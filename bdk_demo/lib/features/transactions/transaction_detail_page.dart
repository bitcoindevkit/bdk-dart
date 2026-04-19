import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/features/transactions/models/demo_tx_details.dart';
import 'package:bdk_demo/features/transactions/transactions_controller.dart';
import 'package:bdk_demo/models/currency_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionDetailPage extends ConsumerWidget {
  final String txid;

  const TransactionDetailPage({super.key, required this.txid});

  String _formatAmount(DemoTxDetails transaction) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transactionAsync = ref.watch(transactionDetailsProvider(txid));

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Transaction Detail'),
      body: SafeArea(
        child: transactionAsync.when(
          loading: () => const WalletStateCard(
            icon: Icons.hourglass_bottom,
            title: 'Loading transaction',
            message: 'Preparing placeholder transaction details...',
            showSpinner: true,
            centered: true,
          ),
          error: (_, __) => WalletStateCard(
            icon: Icons.error_outline,
            title: 'Transaction unavailable',
            message: 'The demo could not load placeholder transaction details.',
            accentColor: theme.colorScheme.error,
            centered: true,
          ),
          data: (transaction) {
            if (transaction == null) {
              return WalletStateCard(
                icon: Icons.search_off,
                title: 'Transaction not found',
                message:
                    'No placeholder transaction was found for this txid.\n\n$txid',
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
                          'Standalone transaction detail view for the selected placeholder transaction.',
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
