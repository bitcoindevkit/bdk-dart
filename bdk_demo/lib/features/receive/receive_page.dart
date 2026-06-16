import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/clipboard_util.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/shared/widgets/neutral_button.dart';
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
    final wallet = ref.watch(activeWalletProvider);
    final receiveState = ref.watch(currentReceiveAddressProvider);

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Receive'),
      body: SafeArea(
        child: record == null || wallet == null
            ? const WalletStateCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'No active wallet',
                message:
                    'Create or load a wallet before generating a receive address.',
                centered: true,
              )
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _IntroCard(walletName: record.name),
                  const SizedBox(height: 16),
                  _ReceiveAddressCard(state: receiveState),
                ],
              ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.walletName});

  final String walletName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.call_received, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receive bitcoin',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Generate an address for $walletName and share it with the sender.',
                    style: theme.textTheme.bodyMedium,
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

class _ReceiveAddressCard extends ConsumerWidget {
  const _ReceiveAddressCard({required this.state});

  final ReceiveAddressState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final address = state.address;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.isGenerating)
              const WalletStateCard(
                icon: Icons.qr_code_2,
                title: 'Generating address',
                message: 'Revealing and saving the next receive address...',
                showSpinner: true,
              )
            else if (address != null) ...[
              _GeneratedAddressDetails(address: address, index: state.index),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                WalletStateCard(
                  icon: Icons.error_outline,
                  title: 'Could not generate new address',
                  message: state.errorMessage!,
                  accentColor: theme.colorScheme.error,
                ),
              ],
            ] else if (state.errorMessage != null)
              WalletStateCard(
                icon: Icons.error_outline,
                title: 'Could not generate address',
                message: state.errorMessage!,
                accentColor: theme.colorScheme.error,
              )
            else if (address == null)
              const WalletStateCard(
                icon: Icons.qr_code_2,
                title: 'No receive address yet',
                message:
                    'Generate a new address when you are ready to receive funds.',
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: state.isGenerating
                  ? null
                  : () => ref
                        .read(currentReceiveAddressProvider.notifier)
                        .generateForActiveWallet(),
              icon: state.isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
              label: const Text('Generate New Address'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratedAddressDetails extends StatelessWidget {
  const _GeneratedAddressDetails({required this.address, required this.index});

  final String address;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedAddress = Formatters.formatAddress(address);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Current receive address',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: 220,
              height: 220,
              child: PrettyQrView.data(data: address),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          formattedAddress,
          textAlign: TextAlign.center,
          style: AppTheme.monoStyle.copyWith(
            fontSize: 13,
            color: theme.colorScheme.onSurface,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          index == null ? 'Address index unavailable' : 'Address index #$index',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(170),
          ),
        ),
        const SizedBox(height: 20),
        NeutralButton(
          label: 'Copy Address',
          icon: Icons.copy,
          onPressed: () => ClipboardUtil.copyAndNotify(
            context,
            address,
            message: 'Address copied',
          ),
        ),
      ],
    );
  }
}
