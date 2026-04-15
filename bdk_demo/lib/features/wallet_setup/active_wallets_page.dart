import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/models/currency_unit.dart';
import 'package:bdk_demo/models/tx_details.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/wallet_service.dart';

enum _LoadState { idle, loading, success, error }

class ActiveWalletsPage extends ConsumerStatefulWidget {
  const ActiveWalletsPage({super.key});

  @override
  ConsumerState<ActiveWalletsPage> createState() => _ActiveWalletsPageState();
}

class _ActiveWalletsPageState extends ConsumerState<ActiveWalletsPage> {
  _LoadState _walletState = _LoadState.idle;
  _LoadState _transactionState = _LoadState.idle;
  DemoWalletInfo? _walletInfo;
  List<TxDetails> _transactions = const [];
  String _statusMessage =
      'Load the reference scaffold to preview wallet details and transaction presentation.';
  String? _walletError;
  String? _transactionError;

  Future<void> _loadReferenceWallet() async {
    final walletService = ref.read(walletServiceProvider);

    setState(() {
      _walletState = _LoadState.loading;
      _transactionState = _LoadState.idle;
      _walletInfo = null;
      _transactions = const [];
      _walletError = null;
      _transactionError = null;
      _statusMessage = 'Preparing the wallet scaffold...';
    });

    try {
      final walletInfo = await walletService.loadReferenceWallet();
      if (!mounted) return;

      setState(() {
        _walletState = _LoadState.success;
        _transactionState = _LoadState.loading;
        _walletInfo = walletInfo;
        _statusMessage = 'Scaffold ready. Loading placeholder transactions...';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _walletState = _LoadState.error;
        _walletError = _readableError(error);
        _statusMessage = 'The wallet scaffold could not be loaded.';
      });
      return;
    }

    try {
      final transactions = await walletService.loadTransactions();
      if (!mounted) return;

      setState(() {
        _transactionState = _LoadState.success;
        _transactions = transactions;
        _statusMessage = transactions.isEmpty
            ? 'Scaffold loaded. No transactions yet.'
            : 'Scaffold loaded. Showing placeholder transaction rows for future UI work.';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _transactionState = _LoadState.error;
        _transactionError = _readableError(error);
        _statusMessage =
            'The wallet scaffold loaded, but placeholder transactions could not be shown.';
      });
    }
  }

  String _readableError(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  String _descriptorPreview(String descriptor) {
    if (descriptor.length <= 48) return descriptor;
    return '${descriptor.substring(0, 24)}...${descriptor.substring(descriptor.length - 18)}';
  }

  void _openTransactionDetail(TxDetails transaction) {
    context.pushNamed(
      'transactionDetail',
      pathParameters: {'txid': transaction.txid},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWalletLoading = _walletState == _LoadState.loading;

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Reference Wallet Scaffold'),
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
                        Icons.wallet_outlined,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reference Wallet Scaffold',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Load a lightweight scaffold that previews wallet details and transaction rows. This is placeholder UI for future transaction visibility work, not a synced or functional wallet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(180),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: isWalletLoading ? null : _loadReferenceWallet,
                      icon: isWalletLoading
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
                        _walletState == _LoadState.success ||
                                _walletState == _LoadState.error
                            ? 'Reload Wallet Data'
                            : 'Load Reference Scaffold',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SectionHeading(
              title: 'Wallet Snapshot',
              subtitle: 'Network, descriptor preview, and current status',
            ),
            const SizedBox(height: 12),
            _buildWalletSection(theme),
            const SizedBox(height: 24),
            const _SectionHeading(
              title: 'Transactions',
              subtitle: 'Placeholder transaction visibility for future work',
            ),
            const SizedBox(height: 12),
            _buildTransactionsSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSection(ThemeData theme) {
    return switch (_walletState) {
      _LoadState.idle => WalletStateCard(
        icon: Icons.info_outline,
        title: 'Wallet not loaded yet',
        message: _statusMessage,
      ),
      _LoadState.loading => const WalletStateCard(
        icon: Icons.hourglass_bottom,
        title: 'Loading wallet',
        message: 'Preparing placeholder wallet details...',
        showSpinner: true,
      ),
      _LoadState.error => WalletStateCard(
        icon: Icons.error_outline,
        title: 'Wallet load failed',
        message: _walletError ?? _statusMessage,
        accentColor: theme.colorScheme.error,
      ),
      _LoadState.success => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletDetailRow(label: 'Wallet', value: _walletInfo!.title),
              const SizedBox(height: 12),
              WalletDetailRow(
                label: 'Network',
                value: _walletInfo!.network.displayName,
              ),
              const SizedBox(height: 12),
              WalletDetailRow(
                label: _walletInfo!.descriptorLabel,
                value: _descriptorPreview(_walletInfo!.descriptor),
                monospace: true,
              ),
              const SizedBox(height: 12),
              WalletDetailRow(label: 'Status', value: _statusMessage),
            ],
          ),
        ),
      ),
    };
  }

  Widget _buildTransactionsSection(ThemeData theme) {
    if (_walletState == _LoadState.idle) {
      return const WalletStateCard(
        icon: Icons.receipt_long_outlined,
        title: 'Transactions will appear here',
        message:
            'Load the scaffold first, then the demo will show placeholder transaction UI.',
      );
    }

    if (_walletState == _LoadState.loading) {
      return const WalletStateCard(
        icon: Icons.hourglass_bottom,
        title: 'Waiting for wallet',
        message: 'Transaction UI becomes available after the scaffold loads.',
        showSpinner: true,
      );
    }

    if (_walletState == _LoadState.error) {
      return const WalletStateCard(
        icon: Icons.receipt_long_outlined,
        title: 'Transactions unavailable',
        message:
            'Fix the scaffold load error before retrying placeholder transactions.',
      );
    }

    return switch (_transactionState) {
      _LoadState.idle => const WalletStateCard(
        icon: Icons.receipt_long_outlined,
        title: 'Transactions not loaded yet',
        message:
            'Placeholder transaction rows will appear after the scaffold finishes loading.',
      ),
      _LoadState.loading => const WalletStateCard(
        icon: Icons.hourglass_bottom,
        title: 'Loading placeholder transactions...',
        message: 'Preparing scaffolded transaction rows.',
        showSpinner: true,
      ),
      _LoadState.error => WalletStateCard(
        icon: Icons.error_outline,
        title: 'Placeholder transactions failed',
        message:
            _transactionError ??
            'Unable to load the placeholder transaction UI.',
        accentColor: theme.colorScheme.error,
      ),
      _LoadState.success =>
        _transactions.isEmpty
            ? const WalletStateCard(
                icon: Icons.history_toggle_off,
                title: 'No transactions yet',
                message:
                    'The scaffold loaded successfully, but no placeholder transactions are configured yet.',
              )
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < _transactions.length;
                        index++
                      ) ...[
                        _TransactionRow(
                          transaction: _transactions[index],
                          onTap: () =>
                              _openTransactionDetail(_transactions[index]),
                        ),
                        if (index < _transactions.length - 1)
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
  final TxDetails transaction;
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
