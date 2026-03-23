import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
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
  late final Future<TxDetails?> _transactionFuture;

  @override
  void initState() {
    super.initState();
    _transactionFuture = ref
        .read(walletServiceProvider)
        .loadTransactionByTxid(widget.txid);
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
              return const _StateCard(
                icon: Icons.hourglass_bottom,
                title: 'Loading transaction',
                message: 'Preparing placeholder transaction details...',
                showSpinner: true,
              );
            }

            if (snapshot.hasError) {
              return _StateCard(
                icon: Icons.error_outline,
                title: 'Transaction unavailable',
                message:
                    'The scaffold could not load placeholder transaction details.',
                accentColor: theme.colorScheme.error,
              );
            }

            final transaction = snapshot.data;
            if (transaction == null) {
              return _StateCard(
                icon: Icons.search_off,
                title: 'Transaction not found',
                message:
                    'No placeholder transaction was found for this txid.\n\n${widget.txid}',
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
                            _StatusChip(status: transaction.statusLabel),
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
                        _DetailRow(
                          label: 'Amount',
                          value: _formatAmount(transaction),
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Status',
                          value: transaction.statusLabel,
                        ),
                        if (transaction.blockHeight != null) ...[
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Block height',
                            value: '${transaction.blockHeight}',
                          ),
                        ],
                        if (transaction.confirmationTime != null) ...[
                          const SizedBox(height: 12),
                          _DetailRow(
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

class _StateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color? accentColor;
  final bool showSpinner;

  const _StateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.accentColor,
    this.showSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showSpinner
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(message, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(170),
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = status == 'pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isPending
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.primaryContainer,
      ),
      child: Text(
        status,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isPending
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
