import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/home/network_endpoint_bottom_sheet.dart';
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
        final syncStatus = ref.read(syncStatusProvider);
        if (record != null && syncStatus == SyncStatus.error) {
          ref.read(autoSyncedWalletIdsProvider.notifier).unmark(record.id);
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
    final syncProgress = ref.watch(syncProgressProvider);
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
                    if (_supportsAutoSync(record.network)) ...[
                      const SizedBox(height: 16),
                      _SyncStateCard(
                        network: record.network,
                        syncStatus: syncStatus,
                        syncProgress: syncProgress,
                      ),
                    ],
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
    final autoSynced = ref.read(autoSyncedWalletIdsProvider.notifier);

    if (record == null || wallet == null) return;
    if (!_supportsAutoSync(record.network)) return;

    if (autoSynced.contains(record.id)) return;

    if (snapshot?.walletId == record.id || syncStatus == SyncStatus.synced) {
      autoSynced.mark(record.id);
      return;
    }

    if (!isOnline) return;
    if (syncStatus == SyncStatus.syncing) return;

    autoSynced.mark(record.id);
    ref.read(syncActiveWalletTriggerProvider).call();
  }

  WalletBalanceSnapshot? _matchingSnapshot(
    WalletBalanceSnapshot? snapshot,
    String walletId,
  ) {
    if (snapshot?.walletId != walletId) return null;
    return snapshot;
  }

  bool _supportsAutoSync(WalletNetwork network) =>
      network != WalletNetwork.regtest;
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

class _SyncStateCard extends ConsumerWidget {
  const _SyncStateCard({
    required this.network,
    required this.syncStatus,
    required this.syncProgress,
  });

  final WalletNetwork network;
  final SyncStatus syncStatus;
  final SyncProgress syncProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final syncElapsed = ref.watch(syncElapsedProvider);
    final syncErrorKind = ref.watch(syncErrorKindProvider);
    final showSlowBanner =
        syncStatus == SyncStatus.syncing &&
        syncElapsed >= AppConstants.syncSlowWarningAfter;
    final showProgressSteps =
        syncStatus == SyncStatus.syncing || syncStatus == SyncStatus.synced;
    final showChangeServer = syncStatus == SyncStatus.error;

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
        'This usually takes about 5–10 seconds.',
        theme.colorScheme.secondary,
      ),
      SyncStatus.synced => (
        Icons.check_circle_outline,
        'Wallet synced',
        'Balance reflects the latest successful sync.',
        Colors.green.shade700,
      ),
      SyncStatus.error => switch (syncErrorKind) {
        SyncErrorKind.timeout => (
          Icons.error_outline,
          'Change server',
          'Sync timed out. The server may be overloaded.',
          theme.colorScheme.error,
        ),
        SyncErrorKind.none || SyncErrorKind.generic => (
          Icons.error_outline,
          'Change server',
          'Could not sync with this server. Try another Electrum endpoint.',
          theme.colorScheme.error,
        ),
      },
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  if (showSlowBanner) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer.withAlpha(
                          120,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'First sync is taking longer than usual. Public servers can be slow — hang tight.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                  if (showProgressSteps) ...[
                    const SizedBox(height: 16),
                    _SyncProgressSteps(
                      syncStatus: syncStatus,
                      syncProgress: syncProgress,
                    ),
                  ],
                  if (showChangeServer) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: () => showNetworkEndpointBottomSheet(
                          context: context,
                          ref: ref,
                          network: network,
                        ),
                        icon: const Icon(Icons.dns_outlined),
                        label: const Text('Change server'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncProgressSteps extends StatelessWidget {
  const _SyncProgressSteps({
    required this.syncStatus,
    required this.syncProgress,
  });

  final SyncStatus syncStatus;
  final SyncProgress syncProgress;

  int get _activeStepIndex {
    if (syncStatus == SyncStatus.synced) return 3;
    return switch (syncProgress.phase) {
      SyncPhase.connecting => 0,
      SyncPhase.scanning => 1,
      SyncPhase.saving => 2,
      SyncPhase.upToDate => 3,
      SyncPhase.idle => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scanLabel = syncProgress.isFirstSync
        ? 'First sync (checking addresses)'
        : 'Updating wallet';
    final steps = [
      'Connecting to server',
      scanLabel,
      'Saving wallet',
      'Up to date',
    ];
    final activeIndex = _activeStepIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          _SyncProgressStep(
            label: steps[i],
            state: i < activeIndex
                ? _SyncStepState.complete
                : i == activeIndex
                ? (syncStatus == SyncStatus.synced
                      ? _SyncStepState.complete
                      : _SyncStepState.active)
                : _SyncStepState.pending,
            theme: theme,
          ),
      ],
    );
  }
}

enum _SyncStepState { pending, active, complete }

class _SyncProgressStep extends StatelessWidget {
  const _SyncProgressStep({
    required this.label,
    required this.state,
    required this.theme,
  });

  final String label;
  final _SyncStepState state;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final (icon, color, weight) = switch (state) {
      _SyncStepState.pending => (
        Icons.radio_button_unchecked,
        theme.colorScheme.onSurface.withAlpha(120),
        FontWeight.w400,
      ),
      _SyncStepState.active => (
        Icons.sync,
        theme.colorScheme.secondary,
        FontWeight.w600,
      ),
      _SyncStepState.complete => (
        Icons.check_circle_outline,
        Colors.green.shade700,
        FontWeight.w500,
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: weight,
              ),
            ),
          ),
        ],
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
