import 'package:flutter/material.dart';

import 'package:bdk_demo/core/theme/app_theme.dart';

class WalletStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color? accentColor;
  final bool showSpinner;
  final bool centered;

  const WalletStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.accentColor,
    this.showSpinner = false,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showSpinner
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(message, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!centered) return card;

    return Center(
      child: Padding(padding: const EdgeInsets.all(24), child: card),
    );
  }
}

class WalletDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool monospace;

  const WalletDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(170),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: monospace
              ? AppTheme.monoStyle.copyWith(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                )
              : theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class WalletStatusChip extends StatelessWidget {
  final String status;

  const WalletStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = status == 'pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isPending
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.primaryContainer,
      ),
      child: Text(
        status,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isPending
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
