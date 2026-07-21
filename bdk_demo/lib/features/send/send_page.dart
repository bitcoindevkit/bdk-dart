import 'dart:math' as math;
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/features/shared/widgets/wallet_ui_helpers.dart';
import 'package:bdk_demo/providers/blockchain_providers.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/send_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/features/transactions/transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _SendAmountUnit { sats, bitcoin }

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
  _SendAmountUnit _amountUnit = _SendAmountUnit.sats;
  var _isBuilding = false;
  var _isBroadcasting = false;

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
    final isBusy = _isBuilding || _isBroadcasting;
    final canReview =
        record != null &&
        wallet != null &&
        isOnline &&
        _hasValidInput &&
        !isBusy;

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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          decoration: InputDecoration(
                            labelText: 'Amount ($_amountUnitLabel)',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: _amountUnit == _SendAmountUnit.sats
                              ? TextInputType.number
                              : const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                          inputFormatters: _amountUnit == _SendAmountUnit.sats
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'),
                                  ),
                                ],
                          textInputAction: TextInputAction.next,
                          validator: _validateAmount,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<_SendAmountUnit>(
                          key: const Key('send-amount-unit-switcher'),
                          segments: const [
                            ButtonSegment(
                              value: _SendAmountUnit.sats,
                              label: Text('sats'),
                            ),
                            ButtonSegment(
                              value: _SendAmountUnit.bitcoin,
                              label: Text('BTC'),
                            ),
                          ],
                          selected: {_amountUnit},
                          onSelectionChanged: (selection) =>
                              _setAmountUnit(selection.single),
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
                          child: Text(_reviewButtonLabel),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  static const _satsPerBitcoin = 100000000;

  String get _reviewButtonLabel {
    if (_isBuilding) return 'Building transaction...';
    if (_isBroadcasting) return 'Broadcasting...';
    return 'Review transaction';
  }

  String get _amountUnitLabel =>
      _amountUnit == _SendAmountUnit.sats ? 'sats' : 'BTC';

  bool get _hasValidInput =>
      _validateAddress(_addressController.text) == null &&
      _validateAmount(_amountController.text) == null &&
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

  String? _validateAmount(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Amount is required.';
    if (_amountUnit == _SendAmountUnit.sats) {
      final parsed = int.tryParse(trimmed);
      if (parsed == null || parsed <= 0) {
        return 'Amount must be greater than zero.';
      }
      return null;
    }

    if (!_isValidBtcInputShape(trimmed)) {
      return 'Amount must be a valid BTC value.';
    }
    final parts = trimmed.split('.');
    if (parts.length == 2 && parts[1].length > 8) {
      return 'BTC amount cannot exceed 8 decimal places.';
    }
    final sat = _tryParseBtcToSat(trimmed);
    if (sat == null || sat <= 0) {
      return 'Amount must be greater than zero.';
    }
    return null;
  }

  bool _isValidBtcInputShape(String value) {
    if (value == '.') return false;
    return RegExp(r'^\d+(\.\d*)?$').hasMatch(value);
  }

  int? _tryParseAmountSat() {
    final trimmed = _amountController.text.trim();
    if (_amountUnit == _SendAmountUnit.sats) {
      return int.tryParse(trimmed);
    }
    return _tryParseBtcToSat(trimmed);
  }

  int? _tryParseBtcToSat(String value) {
    if (!_isValidBtcInputShape(value)) return null;
    final parts = value.split('.');
    if (parts.length > 2) return null;
    final whole = int.tryParse(parts[0]);
    if (whole == null) return null;
    final fraction = parts.length == 2 ? parts[1] : '';
    if (fraction.length > 8) return null;
    final fractionSat = int.parse(fraction.padRight(8, '0'));
    return whole * _satsPerBitcoin + fractionSat;
  }

  String _formatBtc(int amountSat) {
    final whole = amountSat ~/ _satsPerBitcoin;
    final fraction = amountSat % _satsPerBitcoin;
    if (fraction == 0) return '$whole';
    final fractionText = fraction.toString().padLeft(8, '0');
    return '$whole.${fractionText.replaceFirst(RegExp(r'0+$'), '')}';
  }

  void _setAmountUnit(_SendAmountUnit unit) {
    if (unit == _amountUnit) return;
    final amountSat = _tryParseAmountSat();
    if (amountSat != null && amountSat > 0) {
      _amountController.text = unit == _SendAmountUnit.sats
          ? amountSat.toString()
          : _formatBtc(amountSat);
    }
    setState(() {
      _amountUnit = unit;
    });
  }

  void _applyFeeRate(double feeRate) {
    _feeRateController.text = math.max(1, feeRate.ceil()).toString();
    setState(() {});
  }

  Future<void> _handleReview() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final record = ref.read(activeWalletRecordProvider);
    final wallet = ref.read(activeWalletProvider);
    final isOnline = ref.read(isOnlineProvider);
    final amountSat = _tryParseAmountSat();
    final feeRateSatPerVb = int.tryParse(_feeRateController.text.trim());

    if (record == null || wallet == null) {
      _showSnackBar('Load a wallet before sending bitcoin.');
      return;
    }
    if (!isOnline) {
      _showSnackBar('Connect to the internet before sending bitcoin.');
      return;
    }
    if (amountSat == null || amountSat <= 0 || feeRateSatPerVb == null) {
      _showSnackBar('Check the amount and fee rate before continuing.');
      return;
    }

    setState(() => _isBuilding = true);
    SendTransactionDraft draft;
    try {
      draft = await ref.read(sendTransactionDraftBuilderProvider)(
        record: record,
        wallet: wallet,
        recipientAddress: _addressController.text,
        amountSat: amountSat,
        feeRateSatPerVb: feeRateSatPerVb,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isBuilding = false);
      _showSnackBar(
        'Could not build transaction. Check the address, amount, and fee rate.',
      );
      return;
    }
    if (!mounted) return;
    setState(() => _isBuilding = false);

    final confirmed = await _confirmTransaction(
      recipientAddress: _addressController.text.trim(),
      amountSat: amountSat,
      feeRateSatPerVb: feeRateSatPerVb,
      feeSat: draft.feeSat,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isBroadcasting = true);
    final client = ref
        .read(blockchainClientFactoryProvider)
        .call(record.network);
    try {
      await draft.broadcast(client);
      if (!mounted) return;
      ref
          .read(balanceSnapshotProvider.notifier)
          .applyFromWallet(wallet, record.id);
      ref
          .read(transactionsControllerProvider(record.id).notifier)
          .loadTransactions(isBackgroundRefresh: true);
      _showSnackBar('Transaction broadcast successfully.');
      context.go(AppRoutes.home);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar(
        'Could not broadcast transaction. Check your connection and try again.',
      );
    } finally {
      client.dispose();
      if (mounted) {
        setState(() => _isBroadcasting = false);
      }
    }
  }

  Future<bool?> _confirmTransaction({
    required String recipientAddress,
    required int amountSat,
    required int feeRateSatPerVb,
    required int? feeSat,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ConfirmationRow(label: 'Recipient', value: recipientAddress),
            _ConfirmationRow(label: 'Amount', value: _amountSummary(amountSat)),
            _ConfirmationRow(
              label: 'Fee rate',
              value: '$feeRateSatPerVb sat/vB',
            ),
            _ConfirmationRow(
              label: 'Fee',
              value: feeSat == null ? 'Unavailable' : '$feeSat sats',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  String _amountSummary(int amountSat) {
    if (_amountUnit == _SendAmountUnit.sats) {
      return '$amountSat sats';
    }
    return '${_formatBtc(amountSat)} BTC ($amountSat sats)';
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ConfirmationRow extends StatelessWidget {
  const _ConfirmationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          SelectableText(value),
        ],
      ),
    );
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
