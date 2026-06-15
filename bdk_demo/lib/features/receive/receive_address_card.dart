import 'package:bdk_demo/core/theme/app_theme.dart';
import 'package:bdk_demo/core/utils/clipboard_util.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ReceiveAddressCard extends StatelessWidget {
  const ReceiveAddressCard({
    super.key,
    required this.address,
    required this.index,
  });

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
