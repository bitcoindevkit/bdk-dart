import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/blockchain_providers.dart';
import 'package:bdk_demo/providers/network_endpoint_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showNetworkEndpointBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  required WalletNetwork network,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _NetworkEndpointBottomSheet(network: network),
  );
}

class _NetworkEndpointBottomSheet extends ConsumerWidget {
  const _NetworkEndpointBottomSheet({required this.network});

  final WalletNetwork network;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final options = ref.watch(networkEndpointOptionsProvider(network));
    final selected = ref.watch(selectedNetworkEndpointOptionProvider(network));

    if (options.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text('No server options are available for this network.'),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change server',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose an Electrum server for ${network.displayName}.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(170),
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5,
              ),
              child: SingleChildScrollView(
                child: RadioGroup<String>(
                  groupValue: selected?.url ?? options.first.url,
                  onChanged: (url) async {
                    if (url == null) return;
                    await selectNetworkEndpoint(ref, network, url);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    await ref.read(syncActiveWalletTriggerProvider).call();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in options)
                        RadioListTile<String>(
                          value: option.url,
                          title: Text(option.label),
                          subtitle: Text(
                            option.url,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
