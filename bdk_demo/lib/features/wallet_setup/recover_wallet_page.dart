import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/shared/widgets/secondary_app_bar.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecoverWalletPage extends ConsumerStatefulWidget {
  const RecoverWalletPage({super.key});

  @override
  ConsumerState<RecoverWalletPage> createState() => _RecoverWalletPageState();
}

class _RecoverWalletPageState extends ConsumerState<RecoverWalletPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _phraseNameController = TextEditingController();
  final _phraseController = TextEditingController();
  final _descriptorNameController = TextEditingController();
  final _externalDescriptorController = TextEditingController();
  final _changeDescriptorController = TextEditingController();

  var _selectedPhraseNetwork = WalletNetwork.signet;
  var _selectedPhraseScriptType = ScriptType.p2tr;
  var _selectedDescriptorNetwork = WalletNetwork.signet;
  var _isRecovering = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phraseNameController.dispose();
    _phraseController.dispose();
    _descriptorNameController.dispose();
    _externalDescriptorController.dispose();
    _changeDescriptorController.dispose();
    super.dispose();
  }

  bool get _canRecoverFromPhrase =>
      !_isRecovering &&
      _phraseNameController.text.trim().isNotEmpty &&
      _phraseController.text.trim().isNotEmpty;

  bool get _canRecoverFromDescriptors =>
      !_isRecovering &&
      _descriptorNameController.text.trim().isNotEmpty &&
      _externalDescriptorController.text.trim().isNotEmpty &&
      _changeDescriptorController.text.trim().isNotEmpty;

  Future<void> _onRecoverFromPhrase() async {
    final trimmedName = _phraseNameController.text.trim();
    final trimmedPhrase = _phraseController.text.trim();

    if (trimmedName.isEmpty) {
      _showSnackBar('Wallet name cannot be empty');
      return;
    }
    if (trimmedPhrase.isEmpty) {
      _showSnackBar('Recovery phrase cannot be empty');
      return;
    }
    if (_isDuplicateWalletName(trimmedName)) {
      _showSnackBar('A wallet with that name already exists');
      return;
    }

    setState(() => _isRecovering = true);
    final walletDisposer = ref.read(walletDisposerProvider);

    try {
      final (record, wallet) = await ref
          .read(walletServiceProvider)
          .recoverFromPhrase(
            trimmedName,
            _selectedPhraseNetwork,
            _selectedPhraseScriptType,
            trimmedPhrase,
          );

      if (!mounted) {
        walletDisposer(wallet);
        return;
      }

      _activateRecoveredWallet(record, wallet);
      _showSnackBar('Wallet recovered');
      context.go(AppRoutes.home);
    } on ArgumentError catch (error) {
      if (!mounted) return;
      _showSnackBar(_argumentErrorMessage(error, 'Invalid recovery input'));
    } on StateError {
      if (!mounted) return;
      _showSnackBar('Could not recover wallet. Please try again.');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to recover wallet. Please try again.');
    } finally {
      if (mounted) setState(() => _isRecovering = false);
    }
  }

  Future<void> _onRecoverFromDescriptors() async {
    final trimmedName = _descriptorNameController.text.trim();
    final externalDescriptor = _externalDescriptorController.text.trim();
    final changeDescriptor = _changeDescriptorController.text.trim();

    if (trimmedName.isEmpty) {
      _showSnackBar('Wallet name cannot be empty');
      return;
    }
    if (externalDescriptor.isEmpty || changeDescriptor.isEmpty) {
      _showSnackBar('Descriptors cannot be empty');
      return;
    }
    if (_isDuplicateWalletName(trimmedName)) {
      _showSnackBar('A wallet with that name already exists');
      return;
    }

    setState(() => _isRecovering = true);
    final walletDisposer = ref.read(walletDisposerProvider);

    try {
      final (record, wallet) = await ref
          .read(walletServiceProvider)
          .recoverFromDescriptors(
            trimmedName,
            _selectedDescriptorNetwork,
            externalDescriptor,
            changeDescriptor,
          );

      if (!mounted) {
        walletDisposer(wallet);
        return;
      }

      _activateRecoveredWallet(record, wallet);
      _showSnackBar('Wallet recovered');
      context.go(AppRoutes.home);
    } on DescriptorException {
      if (!mounted) return;
      _showSnackBar('Invalid descriptor. Please check both descriptors.');
    } on ArgumentError {
      if (!mounted) return;
      _showSnackBar('Invalid descriptor recovery input');
    } on StateError {
      if (!mounted) return;
      _showSnackBar('Could not recover wallet. Please try again.');
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Failed to recover wallet. Please try again.');
    } finally {
      if (mounted) setState(() => _isRecovering = false);
    }
  }

  bool _isDuplicateWalletName(String name) {
    final existingRecords = ref.read(walletRecordsProvider);
    return existingRecords.any(
      (record) => record.name.toLowerCase() == name.toLowerCase(),
    );
  }

  void _activateRecoveredWallet(WalletRecord record, Wallet wallet) {
    ref.read(activeWalletProvider.notifier).set(wallet);
    ref.read(activeWalletRecordProvider.notifier).set(record);
    ref.read(walletRecordsProvider.notifier).refresh();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _argumentErrorMessage(ArgumentError error, String fallback) {
    final message = error.message?.toString();
    if (message == null || message.isEmpty) return fallback;
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Recover Wallet'),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Phrase'),
              Tab(text: 'Descriptor'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPhraseTab(context),
                _buildDescriptorTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhraseTab(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isRecovering) _buildLoadingLogo(theme),
          TextField(
            controller: _phraseNameController,
            enabled: !_isRecovering,
            decoration: const InputDecoration(
              labelText: 'Wallet Name',
              hintText: 'e.g. Recovered Testnet Wallet',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _phraseController,
            enabled: !_isRecovering,
            decoration: const InputDecoration(
              labelText: 'Recovery Phrase',
              hintText: 'Enter 12 or 24 English BIP-39 words',
              border: OutlineInputBorder(),
            ),
            minLines: 3,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 32),
          _buildNetworkSelector(
            theme: theme,
            selected: _selectedPhraseNetwork,
            onChanged: (selected) {
              setState(() => _selectedPhraseNetwork = selected);
            },
          ),
          const SizedBox(height: 32),
          _buildScriptTypeSelector(theme),
          const SizedBox(height: 48),
          _buildSubmitButton(
            label: 'Recover From Phrase',
            canSubmit: _canRecoverFromPhrase,
            onPressed: _onRecoverFromPhrase,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptorTab(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isRecovering) _buildLoadingLogo(theme),
          TextField(
            controller: _descriptorNameController,
            enabled: !_isRecovering,
            decoration: const InputDecoration(
              labelText: 'Wallet Name',
              hintText: 'e.g. Watch-only Wallet',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _externalDescriptorController,
            enabled: !_isRecovering,
            decoration: const InputDecoration(
              labelText: 'External Descriptor',
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _changeDescriptorController,
            enabled: !_isRecovering,
            decoration: const InputDecoration(
              labelText: 'Change Descriptor',
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 32),
          _buildNetworkSelector(
            theme: theme,
            selected: _selectedDescriptorNetwork,
            onChanged: (selected) {
              setState(() => _selectedDescriptorNetwork = selected);
            },
          ),
          const SizedBox(height: 48),
          _buildSubmitButton(
            label: 'Recover From Descriptors',
            canSubmit: _canRecoverFromDescriptors,
            onPressed: _onRecoverFromDescriptors,
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkSelector({
    required ThemeData theme,
    required WalletNetwork selected,
    required ValueChanged<WalletNetwork> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            selected: {selected},
            onSelectionChanged: _isRecovering
                ? null
                : (selection) {
                    onChanged(selection.first);
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildScriptTypeSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            selected: {_selectedPhraseScriptType},
            onSelectionChanged: _isRecovering
                ? null
                : (selected) {
                    setState(() => _selectedPhraseScriptType = selected.first);
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton({
    required String label,
    required bool canSubmit,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: canSubmit ? onPressed : null,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isRecovering
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontSize: 16)),
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
