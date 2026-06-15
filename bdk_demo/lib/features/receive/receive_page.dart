import 'package:bdk_demo/features/receive/receive_address_card.dart';
import 'package:bdk_demo/features/receive/receive_error_panel.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/address_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            : _buildWalletContent(context, ref, record, receiveState),
      ),
    );
  }

  Widget _buildWalletContent(
    BuildContext context,
    WidgetRef ref,
    WalletRecord record,
    ReceiveAddressState receiveState,
  ) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Receive on ${record.network.displayName}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(record.name, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        if (receiveState.address case final address?)
          ReceiveAddressCard(address: address, index: receiveState.index)
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
          ReceiveErrorPanel(message: error),
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
    );
  }
}
