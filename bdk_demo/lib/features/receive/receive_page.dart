import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/clipboard_util.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/providers/address_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ReceivePage extends ConsumerWidget {
  const ReceivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(activeWalletRecordProvider);
    final receiveState = ref.watch(currentReceiveAddressProvider);

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Receive'),
      body: SafeArea(
        child: record == null
            ? const WalletStateCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'No active wallet',
                message: 'Load a wallet before generating a receive address.',
                centered: true,
              )
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Receive on ${record.network.displayName}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    record.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  if (receiveState.address case final address?)
                    _ReceiveAddressCard(
                      address: address,
                      index: receiveState.index,
                    )
                  else
                    WalletStateCard(
                      icon: Icons.qr_code_2,
                      title: receiveState.isGenerating
                          ? 'Generating address'
                          : 'Ready to receive',
                      message: receiveState.isGenerating
                          ? 'Revealing and saving the next external address.'
                          : 'Generate a fresh external address for this wallet.',
                      showSpinner: receiveState.isGenerating,
                    ),
                  if (receiveState.errorMessage case final error?) ...[
                    const SizedBox(height: 12),
                    _ReceiveError(message: error),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: receiveState.isGenerating
                        ? null
                        : () => ref
                              .read(currentReceiveAddressProvider.notifier)
                              .generateForActiveWallet(),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: Text(
                      receiveState.address != null
                          ? 'Generate new address'
                          : receiveState.errorMessage != null
                          ? 'Try again'
                          : 'Generate address',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ReceiveAddressCard extends StatelessWidget {
  const _ReceiveAddressCard({required this.address, required this.index});

  final String address;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 240,
              height: 240,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: PrettyQrView.data(
                key: const Key('receive-address-qr'),
                data: address,
              ),
            ),
            const SizedBox(height: 20),
            SelectableText(
              address,
              textAlign: TextAlign.center,
              style: AppTheme.monoStyle.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (index case final addressIndex?) ...[
              const SizedBox(height: 10),
              Text(
                'External index $addressIndex',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(170),
                ),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => ClipboardUtil.copyAndNotify(
                context,
                address,
                message: 'Address copied',
              ),
              icon: const Icon(Icons.copy_outlined),
              label: const Text('Copy address'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiveError extends StatelessWidget {
  const _ReceiveError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: const Key('receive-error'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
