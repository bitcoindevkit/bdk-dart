import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActiveWalletsPage extends ConsumerStatefulWidget {
  const ActiveWalletsPage({super.key});

  @override
  ConsumerState<ActiveWalletsPage> createState() => _ActiveWalletsPageState();
}

class _ActiveWalletsPageState extends ConsumerState<ActiveWalletsPage> {
  String? _loadingWalletId;

  Future<void> _onLoadWallet(WalletRecord record) async {
    if (_loadingWalletId != null) return;

    setState(() => _loadingWalletId = record.id);
    final walletDisposer = ref.read(walletDisposerProvider);

    try {
      final wallet = await ref
          .read(walletServiceProvider)
          .loadWalletFromRecord(record);

      if (!mounted) {
        walletDisposer(wallet);
        return;
      }

      ref.read(activeWalletProvider.notifier).set(wallet);
      ref.read(activeWalletRecordProvider.notifier).set(record);
      context.go(AppRoutes.home);
    } on StateError {
      if (!mounted) return;
      _showSnackBar('Secrets not found for this wallet');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to load wallet. Please try again.');
    } finally {
      if (mounted) setState(() => _loadingWalletId = null);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(walletRecordsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Active Wallets'),
      body: records.isEmpty
          ? _buildEmptyState(theme)
          : _buildWalletList(records, theme),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withAlpha(102),
            ),
            const SizedBox(height: 16),
            Text(
              'No wallets yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () => context.push(AppRoutes.createWallet),
              child: const Text('Create a Wallet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletList(List<WalletRecord> records, ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final record = records[index];
        final isLoading = _loadingWalletId == record.id;
        final isDisabled = _loadingWalletId != null;

        return _WalletCard(
          record: record,
          isLoading: isLoading,
          isDisabled: isDisabled,
          onTap: () => _onLoadWallet(record),
        );
      },
    );
  }
}

class _WalletCard extends StatelessWidget {
  final WalletRecord record;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onTap;

  const _WalletCard({
    required this.record,
    required this.isLoading,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 36,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(
                            record.network.displayName,
                            style: theme.textTheme.labelSmall,
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Chip(
                          label: Text(
                            record.scriptType.shortName,
                            style: theme.textTheme.labelSmall,
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(102),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
