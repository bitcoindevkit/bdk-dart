import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:bdk_demo/features/home/home_page.dart';
import 'package:bdk_demo/features/receive/receive_page.dart';
import 'package:bdk_demo/features/send/send_page.dart';
import 'package:bdk_demo/features/transactions/transaction_detail_page.dart';
import 'package:bdk_demo/features/transactions/transactions_list_page.dart';
import 'package:bdk_demo/features/shared/widgets/placeholder_page.dart';
import 'package:bdk_demo/features/wallet_setup/active_wallets_page.dart';
import 'package:bdk_demo/features/wallet_setup/create_wallet_page.dart';
import 'package:bdk_demo/features/wallet_setup/recover_wallet_page.dart';
import 'package:bdk_demo/features/wallet_setup/wallet_choice_page.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';

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

typedef RouterRead = T Function<T>(ProviderListenable<T> provider);

String? _sendRouteRedirect(RouterRead read) {
  final hasActiveWallet =
      read(activeWalletRecordProvider) != null &&
      read(activeWalletProvider) != null;
  if (!hasActiveWallet) return AppRoutes.home;
  if (!read(isOnlineProvider)) return AppRoutes.home;
  return null;
}

GoRouter createRouter(RouterRead read) => GoRouter(
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
      builder: (context, state) => const RecoverWalletPage(),
    ),

    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.receive,
      name: 'receive',
      builder: (context, state) => const ReceivePage(),
    ),
    GoRoute(
      path: AppRoutes.send,
      name: 'send',
      redirect: (context, state) => _sendRouteRedirect(read),
      builder: (context, state) => const SendPage(),
    ),
    GoRoute(
      path: AppRoutes.transactionHistory,
      name: 'transactionHistory',
      builder: (context, state) => const TransactionsListPage(),
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
