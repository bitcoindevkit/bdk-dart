import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bdk_demo/core/router/app_router.dart';

class WalletChoicePage extends StatelessWidget {
  const WalletChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Text(
                      '₿',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                _ChoiceCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Use an Active Wallet',
                  subtitle: 'Load a previously created wallet',
                  onTap: () => context.push(AppRoutes.activeWallets),
                ),
                const SizedBox(height: 16),
                _ChoiceCard(
                  icon: Icons.add_circle_outline,
                  title: 'Create a New Wallet',
                  subtitle: 'Generate a new wallet with a fresh mnemonic',
                  onTap: () => context.push(AppRoutes.createWallet),
                ),
                const SizedBox(height: 16),
                _ChoiceCard(
                  icon: Icons.restore,
                  title: 'Recover an Existing Wallet',
                  subtitle: 'Restore from recovery phrase or descriptor',
                  onTap: () => context.push(AppRoutes.recoverWallet),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 36, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withAlpha(102),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
