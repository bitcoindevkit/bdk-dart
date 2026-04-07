import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/shared/widgets/placeholder_page.dart';
import 'package:bdk_demo/features/wallet_setup/active_wallets_page.dart';
import 'package:bdk_demo/features/wallet_setup/create_wallet_page.dart';
import 'package:bdk_demo/features/wallet_setup/wallet_choice_page.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderScope> buildRouterApp(String initialRoute) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs: prefs);

    final router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: AppRoutes.walletChoice,
          builder: (context, state) => const WalletChoicePage(),
        ),
        GoRoute(
          path: AppRoutes.createWallet,
          builder: (context, state) => const CreateWalletPage(),
        ),
        GoRoute(
          path: AppRoutes.activeWallets,
          builder: (context, state) => const ActiveWalletsPage(),
        ),
      ],
    );

    return ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storage)],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('/create-wallet resolves to CreateWalletPage', (tester) async {
    final app = await buildRouterApp(AppRoutes.createWallet);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(CreateWalletPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
  });

  testWidgets('/active-wallets resolves to ActiveWalletsPage', (tester) async {
    final app = await buildRouterApp(AppRoutes.activeWallets);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(ActiveWalletsPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
  });
}
