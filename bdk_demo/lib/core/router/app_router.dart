import 'package:go_router/go_router.dart';
import 'package:bdk_demo/features/shared/widgets/placeholder_page.dart';
import 'package:bdk_demo/features/wallet_setup/active_wallets_page.dart';
import 'package:bdk_demo/features/wallet_setup/create_wallet_page.dart';
import 'package:bdk_demo/features/wallet_setup/transaction_detail_page.dart';
import 'package:bdk_demo/features/wallet_setup/wallet_choice_page.dart';

abstract final class AppRoutes {
  static const walletChoice = '/';
  static const activeWallets = '/active-wallets';
  static const createWallet = '/create-wallet';
  static const recoverWallet = '/recover-wallet';
  static const home = '/home';
  static const receive = '/receive';
  static const send = '/send';
  static const transactionHistory = '/transactions';
  static const transactionDetail = '/transactions/:txid';
  static const settings = '/settings';
  static const about = '/about';
  static const theme = '/theme';
  static const logs = '/logs';
  static const recoveryData = '/recovery-data';
}

GoRouter createRouter() => GoRouter(
  initialLocation: AppRoutes.walletChoice,
  routes: [
    GoRoute(
      path: AppRoutes.walletChoice,
      name: 'walletChoice',
      builder: (context, state) => const WalletChoicePage(),
    ),
    GoRoute(
      path: AppRoutes.activeWallets,
      name: 'activeWallets',
      builder: (context, state) => const ActiveWalletsPage(),
    ),
    GoRoute(
      path: AppRoutes.createWallet,
      name: 'createWallet',
      builder: (context, state) => const CreateWalletPage(),
    ),
    GoRoute(
      path: AppRoutes.recoverWallet,
      name: 'recoverWallet',
      builder: (context, state) =>
          const PlaceholderPage(title: 'Recover Wallet'),
    ),

    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const PlaceholderPage(title: 'Home'),
    ),
    GoRoute(
      path: AppRoutes.receive,
      name: 'receive',
      builder: (context, state) => const PlaceholderPage(title: 'Receive'),
    ),
    GoRoute(
      path: AppRoutes.send,
      name: 'send',
      builder: (context, state) => const PlaceholderPage(title: 'Send'),
    ),
    GoRoute(
      path: AppRoutes.transactionHistory,
      name: 'transactionHistory',
      builder: (context, state) =>
          const PlaceholderPage(title: 'Transaction History'),
    ),
    GoRoute(
      path: AppRoutes.transactionDetail,
      name: 'transactionDetail',
      builder: (context, state) {
        final txid = state.pathParameters['txid'] ?? '';
        return TransactionDetailPage(txid: txid);
      },
    ),

    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const PlaceholderPage(title: 'Settings'),
    ),
    GoRoute(
      path: AppRoutes.about,
      name: 'about',
      builder: (context, state) => const PlaceholderPage(title: 'About'),
    ),
    GoRoute(
      path: AppRoutes.theme,
      name: 'theme',
      builder: (context, state) => const PlaceholderPage(title: 'Theme'),
    ),
    GoRoute(
      path: AppRoutes.logs,
      name: 'logs',
      builder: (context, state) => const PlaceholderPage(title: 'Logs'),
    ),
    GoRoute(
      path: AppRoutes.recoveryData,
      name: 'recoveryData',
      builder: (context, state) =>
          const PlaceholderPage(title: 'Recovery Data'),
    ),
  ],
);
