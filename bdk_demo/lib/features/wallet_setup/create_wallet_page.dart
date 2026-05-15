import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateWalletPage extends ConsumerStatefulWidget {
  const CreateWalletPage({super.key});

  @override
  ConsumerState<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends ConsumerState<CreateWalletPage> {
  final _nameController = TextEditingController();
  var _selectedNetwork = WalletNetwork.signet;
  var _selectedScriptType = ScriptType.p2tr;
  var _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSubmit => !_isCreating && _nameController.text.trim().isNotEmpty;

  Future<void> _onCreateWallet() async {
    final trimmedName = _nameController.text.trim();
    if (trimmedName.isEmpty) {
      _showSnackBar('Wallet name cannot be empty');
      return;
    }

    final existingRecords = ref.read(walletRecordsProvider);
    final isDuplicate = existingRecords.any(
      (r) => r.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (isDuplicate) {
      _showSnackBar('A wallet with that name already exists');
      return;
    }

    setState(() => _isCreating = true);
    final walletDisposer = ref.read(walletDisposerProvider);

    try {
      final (record, wallet) = await ref
          .read(walletServiceProvider)
          .createWallet(trimmedName, _selectedNetwork, _selectedScriptType);

      if (!mounted) {
        walletDisposer(wallet);
        return;
      }

      ref.read(activeWalletProvider.notifier).set(wallet);
      ref.read(activeWalletRecordProvider.notifier).set(record);
      ref.read(walletRecordsProvider.notifier).refresh();

      _showSnackBar('Wallet created');
      context.go(AppRoutes.home);
    } on ArgumentError {
      if (!mounted) return;
      _showSnackBar('Invalid wallet name');
    } on StateError {
      if (!mounted) return;
      _showSnackBar('Could not create wallet. Please try again.');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to create wallet. Please try again.');
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Create Wallet'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isCreating) _buildLoadingLogo(theme),

            TextField(
              controller: _nameController,
              enabled: !_isCreating,
              decoration: const InputDecoration(
                labelText: 'Wallet Name',
                hintText: 'e.g. My Testnet Wallet',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {
                if (_canSubmit) _onCreateWallet();
              },
            ),
            const SizedBox(height: 32),

            Text(
              'Network',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<WalletNetwork>(
                segments: WalletNetwork.values.map((network) {
                  return ButtonSegment(
                    value: network,
                    label: Text(network.displayName),
                  );
                }).toList(),
                selected: {_selectedNetwork},
                onSelectionChanged: _isCreating
                    ? null
                    : (selected) {
                        setState(() => _selectedNetwork = selected.first);
                      },
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Script Type',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<ScriptType>(
                segments: const [
                  ButtonSegment(
                    value: ScriptType.p2tr,
                    label: Text('P2TR (Taproot)'),
                  ),
                  ButtonSegment(
                    value: ScriptType.p2wpkh,
                    label: Text('P2WPKH (SegWit)'),
                  ),
                ],
                selected: {_selectedScriptType},
                onSelectionChanged: _isCreating
                    ? null
                    : (selected) {
                        setState(() => _selectedScriptType = selected.first);
                      },
              ),
            ),
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canSubmit ? _onCreateWallet : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isCreating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Wallet',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingLogo(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.4, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child);
          },
          onEnd: () {},
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primaryContainer,
            ),
            child: Center(
              child: Text(
                '₿',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
