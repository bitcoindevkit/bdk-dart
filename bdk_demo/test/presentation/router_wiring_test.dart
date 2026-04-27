import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/shared/widgets/placeholder_page.dart';
import 'package:bdk_demo/features/wallet_setup/active_wallets_page.dart';
import 'package:bdk_demo/features/wallet_setup/create_wallet_page.dart';
import 'package:bdk_demo/features/wallet_setup/recover_wallet_page.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpRouterAt(WidgetTester tester, String route) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs: prefs);
    final router = createRouter();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    router.go(route);
    await tester.pumpAndSettle();
  }

  testWidgets('/create-wallet resolves to CreateWalletPage', (tester) async {
    await pumpRouterAt(tester, AppRoutes.createWallet);

    expect(find.byType(CreateWalletPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
  });

  testWidgets('/active-wallets resolves to ActiveWalletsPage', (tester) async {
    await pumpRouterAt(tester, AppRoutes.activeWallets);

    expect(find.byType(ActiveWalletsPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
  });

  testWidgets('/recover-wallet resolves to RecoverWalletPage', (tester) async {
    await pumpRouterAt(tester, AppRoutes.recoverWallet);

    expect(find.byType(RecoverWalletPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
    expect(find.text('Recover Wallet'), findsOneWidget);
  });
}
