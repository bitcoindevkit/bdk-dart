import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/features/transactions/models/demo_tx_details.dart';
import 'package:bdk_demo/features/transactions/transactions_controller.dart';
import 'package:bdk_demo/models/currency_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionsListPage extends ConsumerWidget {
  const TransactionsListPage({super.key});

  void _openTransactionDetail(BuildContext context, DemoTxDetails transaction) {
    context.pushNamed(
      'transactionDetail',
      pathParameters: {'txid': transaction.txid},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(transactionsControllerProvider);
    final isLoading = state.status == TransactionsLoadState.loading;

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Transactions Demo'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Transactions Demo',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preview placeholder transaction list and detail states in a standalone transactions feature. This demo does not sync a real wallet or query the blockchain.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(180),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => ref
                                .read(transactionsControllerProvider.notifier)
                                .loadTransactions(),
                      icon: isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.download_rounded),
                      label: Text(
                        state.status == TransactionsLoadState.success ||
                                state.status == TransactionsLoadState.error
                            ? 'Reload Transactions'
                            : 'Load Transactions Demo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SectionHeading(
              title: 'Transactions',
              subtitle: 'Placeholder transaction list and detail navigation',
            ),
            const SizedBox(height: 12),
            _TransactionsBody(state: state, onTap: _openTransactionDetail),
          ],
        ),
      ),
    );
  }
}

class _TransactionsBody extends StatelessWidget {
  final TransactionsState state;
  final void Function(BuildContext context, DemoTxDetails transaction) onTap;

  const _TransactionsBody({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return switch (state.status) {
      TransactionsLoadState.idle => WalletStateCard(
        icon: Icons.info_outline,
        title: 'Transactions not loaded yet',
        message: state.statusMessage,
      ),
      TransactionsLoadState.loading => const WalletStateCard(
        icon: Icons.hourglass_bottom,
        title: 'Loading placeholder transactions...',
        message: 'Preparing scaffolded transaction rows.',
        showSpinner: true,
      ),
      TransactionsLoadState.error => WalletStateCard(
        icon: Icons.error_outline,
        title: 'Transaction demo failed',
        message: state.errorMessage ?? state.statusMessage,
        accentColor: theme.colorScheme.error,
      ),
      TransactionsLoadState.success =>
        state.transactions.isEmpty
            ? const WalletStateCard(
                icon: Icons.history_toggle_off,
                title: 'No transactions yet',
                message:
                    'The transaction demo loaded successfully, but no placeholder transactions are configured yet.',
              )
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < state.transactions.length;
                        index++
                      ) ...[
                        _TransactionRow(
                          transaction: state.transactions[index],
                          onTap: () =>
                              onTap(context, state.transactions[index]),
                        ),
                        if (index < state.transactions.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
    };
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(170),
          ),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final DemoTxDetails transaction;
  final VoidCallback onTap;

  const _TransactionRow({required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = transaction.netAmount;
    final isIncoming = amount >= 0;
    final accentColor = transaction.pending
        ? theme.colorScheme.secondary
        : isIncoming
        ? Colors.green.shade700
        : theme.colorScheme.primary;
    final amountLabel =
        '${amount >= 0 ? '+' : '-'}${Formatters.formatBalance(amount.abs(), CurrencyUnit.satoshi)}';
    final subtitle = transaction.pending
        ? 'Awaiting confirmation'
        : transaction.blockHeight == null
        ? 'Confirmed'
        : 'Block ${transaction.blockHeight}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      amountLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  WalletStatusChip(status: transaction.statusLabel),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                transaction.shortTxid,
                style: AppTheme.monoStyle.copyWith(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(170),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
