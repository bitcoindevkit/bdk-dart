import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/models/currency_unit.dart';
import 'package:bdk_demo/models/wallet_balance_snapshot.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/blockchain_providers.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  CurrencyUnit _currencyUnit = CurrencyUnit.bitcoin;
  final Set<String> _autoSyncedWalletIds = {};
  var _initialAutoSyncQueued = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(activeWalletRecordProvider, (_, __) => _queueAutoSync());
    ref.listenManual(activeWalletProvider, (_, __) => _queueAutoSync());
    ref.listenManual(balanceSnapshotProvider, (_, __) => _queueAutoSync());
    ref.listenManual(syncStatusProvider, (_, __) => _queueAutoSync());
    ref.listenManual(isOnlineProvider, (previous, next) {
      if (next && previous != true) {
        final record = ref.read(activeWalletRecordProvider);
        final snapshot = ref.read(balanceSnapshotProvider);
        final syncStatus = ref.read(syncStatusProvider);
        if (record != null &&
            snapshot?.walletId != record.id &&
            syncStatus == SyncStatus.error) {
          _autoSyncedWalletIds.remove(record.id);
        }
      }
      _queueAutoSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialAutoSyncQueued) {
      _initialAutoSyncQueued = true;
      _queueAutoSync();
    }

    final record = ref.watch(activeWalletRecordProvider);
    final wallet = ref.watch(activeWalletProvider);
    final snapshot = ref.watch(balanceSnapshotProvider);
    final syncStatus = ref.watch(syncStatusProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Home'),
      body: SafeArea(
        child: record == null || wallet == null
            ? const WalletStateCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'No active wallet',
                message:
                    'Create or load a wallet to view balance and sync status.',
                centered: true,
              )
            : RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: [
                    _WalletHeader(record: record),
                    const SizedBox(height: 16),
                    _BalanceCard(
                      snapshot: _matchingSnapshot(snapshot, record.id),
                      syncStatus: syncStatus,
                      currencyUnit: _currencyUnit,
                      onToggleUnit: () {
                        setState(() {
                          _currencyUnit = _currencyUnit.toggled;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _SyncStateCard(syncStatus: syncStatus),
                    const SizedBox(height: 16),
                    _ActionRow(isOnline: isOnline),
                  ],
                ),
              ),
      ),
    );
  }

  void _queueAutoSync() {
    Future.microtask(_maybeAutoSync);
  }

  Future<void> _handleRefresh() async {
    final record = ref.read(activeWalletRecordProvider);
    final wallet = ref.read(activeWalletProvider);
    final syncStatus = ref.read(syncStatusProvider);
    final isOnline = ref.read(isOnlineProvider);

    if (record == null || wallet == null) return;
    if (!isOnline) return;
    if (syncStatus == SyncStatus.syncing) return;

    await ref.read(syncActiveWalletTriggerProvider).call();
  }

  void _maybeAutoSync() {
    if (!mounted) return;

    final record = ref.read(activeWalletRecordProvider);
    final wallet = ref.read(activeWalletProvider);
    final snapshot = ref.read(balanceSnapshotProvider);
    final syncStatus = ref.read(syncStatusProvider);
    final isOnline = ref.read(isOnlineProvider);

    if (record == null || wallet == null) return;
    if (snapshot?.walletId == record.id) {
      _autoSyncedWalletIds.remove(record.id);
      return;
    }
    if (!isOnline) return;
    if (syncStatus == SyncStatus.syncing) return;
    if (!_autoSyncedWalletIds.add(record.id)) return;

    ref.read(syncActiveWalletTriggerProvider).call();
  }

  WalletBalanceSnapshot? _matchingSnapshot(
    WalletBalanceSnapshot? snapshot,
    String walletId,
  ) {
    if (snapshot?.walletId != walletId) return null;
    return snapshot;
  }
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader({required this.record});

  final WalletRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.network.displayName} • ${record.scriptType.shortName}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(170),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.snapshot,
    required this.syncStatus,
    required this.currencyUnit,
    required this.onToggleUnit,
  });

  final WalletBalanceSnapshot? snapshot;
  final SyncStatus syncStatus;
  final CurrencyUnit currencyUnit;
  final VoidCallback onToggleUnit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSat = snapshot?.totalSat ?? 0;
    final trustedSpendableSat = snapshot?.trustedSpendableSat ?? 0;
    final hasSnapshot = snapshot != null;
    final subtitle = hasSnapshot
        ? 'Trusted spendable: ${Formatters.formatBalance(trustedSpendableSat, currencyUnit)}'
        : syncStatus == SyncStatus.syncing
        ? 'Syncing wallet...'
        : 'Balance will update after sync.';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onToggleUnit,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Balance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    currencyUnit.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                Formatters.formatBalance(totalSat, currencyUnit),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(170),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap balance to toggle units',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncStateCard extends StatelessWidget {
  const _SyncStateCard({required this.syncStatus});

  final SyncStatus syncStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, title, message, color) = switch (syncStatus) {
      SyncStatus.idle => (
        Icons.pause_circle_outline,
        'Sync idle',
        'Wallet sync will start automatically when needed.',
        theme.colorScheme.primary,
      ),
      SyncStatus.syncing => (
        Icons.sync,
        'Syncing wallet',
        'Fetching the latest wallet state.',
        theme.colorScheme.secondary,
      ),
      SyncStatus.synced => (
        Icons.check_circle_outline,
        'Wallet synced',
        'Balance reflects the latest successful sync.',
        Colors.green.shade700,
      ),
      SyncStatus.error => (
        Icons.error_outline,
        'Sync error',
        'Reconnect or revisit Home to try syncing again.',
        theme.colorScheme.error,
      ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _SyncStatusChip(syncStatus: syncStatus),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(message, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncStatusChip extends StatelessWidget {
  const _SyncStatusChip({required this.syncStatus});

  final SyncStatus syncStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = switch (syncStatus) {
      SyncStatus.idle => 'idle',
      SyncStatus.syncing => 'syncing',
      SyncStatus.synced => 'synced',
      SyncStatus.error => 'error',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.primaryContainer,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.push(AppRoutes.receive),
            icon: const Icon(Icons.call_received),
            label: const Text('Receive'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: isOnline ? () => context.push(AppRoutes.send) : null,
            icon: const Icon(Icons.call_made),
            label: const Text('Send'),
          ),
        ),
      ],
    );
  }
}
