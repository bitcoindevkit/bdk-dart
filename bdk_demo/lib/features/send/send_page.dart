import 'dart:math' as math;
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/send_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendPage extends ConsumerStatefulWidget {
  const SendPage({super.key});

  @override
  ConsumerState<SendPage> createState() => _SendPageState();
}

class _SendPageState extends ConsumerState<SendPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _feeRateController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    _feeRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = ref.watch(activeWalletRecordProvider);
    final wallet = ref.watch(activeWalletProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final feeEstimates = ref.watch(feeEstimatesProvider);
    final canReview =
        record != null && wallet != null && isOnline && _hasValidInput;

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Send'),
      body: SafeArea(
        child: record == null || wallet == null
            ? const WalletStateCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'No active wallet',
                message: 'Load a wallet before sending bitcoin.',
                centered: true,
              )
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (!isOnline) ...[
                    const WalletStateCard(
                      icon: Icons.wifi_off_outlined,
                      title: 'Offline',
                      message: 'Connect to the internet before sending.',
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Send bitcoin',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a transaction for one recipient. Review and broadcast are handled in the next step.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          key: const Key('send-recipient-field'),
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Recipient address',
                            border: OutlineInputBorder(),
                          ),
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.next,
                          validator: _validateAddress,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('send-amount-field'),
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount (sats)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              _validatePositiveInt(value, 'Amount'),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('send-fee-rate-field'),
                          controller: _feeRateController,
                          decoration: const InputDecoration(
                            labelText: 'Fee rate (sat/vB)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.done,
                          validator: (value) =>
                              _validatePositiveInt(value, 'Fee rate'),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        _FeeSuggestions(
                          feeEstimates: feeEstimates,
                          onSelected: _applyFeeRate,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: canReview ? _handleReview : null,
                          child: const Text('Review transaction'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  bool get _hasValidInput =>
      _validateAddress(_addressController.text) == null &&
      _validatePositiveInt(_amountController.text, 'Amount') == null &&
      _validatePositiveInt(_feeRateController.text, 'Fee rate') == null;

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Recipient address is required.';
    }
    return null;
  }

  String? _validatePositiveInt(String? value, String label) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '$label is required.';
    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return '$label must be greater than zero.';
    }
    return null;
  }

  void _applyFeeRate(double feeRate) {
    _feeRateController.text = math.max(1, feeRate.ceil()).toString();
    setState(() {});
  }

  void _handleReview() {
    _formKey.currentState?.validate();
  }
}

class _FeeSuggestions extends StatelessWidget {
  const _FeeSuggestions({required this.feeEstimates, required this.onSelected});

  final AsyncValue<Map<int, double>> feeEstimates;
  final ValueChanged<double> onSelected;

  @override
  Widget build(BuildContext context) {
    return feeEstimates.when(
      data: (estimates) {
        if (estimates.isEmpty) {
          return const Text('Fee suggestions unavailable.');
        }

        final entries = estimates.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fee suggestions',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in entries)
                  ActionChip(
                    label: Text(
                      '${entry.key} ${entry.key == 1 ? 'block' : 'blocks'} · ${entry.value.ceil()} sat/vB',
                    ),
                    onPressed: () => onSelected(entry.value),
                  ),
              ],
            ),
          ],
        );
      },
      loading: () => const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Loading fee suggestions...'),
        ],
      ),
      error: (_, __) => const Text('Could not load fee suggestions.'),
    );
  }
}
