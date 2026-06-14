import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/home/home_page.dart';
import 'package:bdk_demo/features/receive/receive_page.dart';
import 'package:bdk_demo/features/send/send_page.dart';
import 'package:bdk_demo/features/transactions/transactions_list_page.dart';
import 'package:bdk_demo/features/shared/widgets/placeholder_page.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/features/wallet_setup/active_wallets_page.dart';
import 'package:bdk_demo/features/wallet_setup/create_wallet_page.dart';
import 'package:bdk_demo/features/wallet_setup/recover_wallet_page.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/send_providers.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _testExtendedPrivKey =
    'tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B';

Wallet _createTestWallet() {
  final descriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
    networkKind: NetworkKind.test,
  );
  final changeDescriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
    networkKind: NetworkKind.test,
  );
  return Wallet(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    network: Network.testnet,
    persister: Persister.newInMemory(),
    lookahead: 25,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpRouterAt(
    WidgetTester tester,
    String route, {
    List<ConnectivityResult> connectivityResults = const [
      ConnectivityResult.wifi,
    ],
    bool seedActiveWallet = false,
    bool? isOnline,
  }) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs: prefs);
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        feeEstimatesJobRunnerProvider.overrideWithValue(
          (_) async => const {1: 1.0},
        ),
        connectivityProvider.overrideWith(
          (ref) => Stream.value(connectivityResults),
        ),
        if (isOnline != null) isOnlineProvider.overrideWith((ref) => isOnline),
      ],
    );
    addTearDown(container.dispose);

    if (seedActiveWallet) {
      container
          .read(activeWalletRecordProvider.notifier)
          .set(
            const WalletRecord(
              id: 'router-wallet',
              name: 'Router Wallet',
              network: WalletNetwork.testnet,
              scriptType: ScriptType.p2wpkh,
            ),
          );
      container.read(activeWalletProvider.notifier).set(_createTestWallet());
    }

    final router = createRouter(container.read);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
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

  testWidgets('/transactions resolves to TransactionsListPage', (tester) async {
    await pumpRouterAt(tester, AppRoutes.transactionHistory);

    expect(find.byType(TransactionsListPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
  });

  testWidgets('/home resolves to HomePage', (tester) async {
    await pumpRouterAt(tester, AppRoutes.home);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
  });

  testWidgets('/receive resolves to ReceivePage while offline', (tester) async {
    await pumpRouterAt(
      tester,
      AppRoutes.receive,
      connectivityResults: const [ConnectivityResult.none],
    );

    expect(find.byType(ReceivePage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
    expect(find.text('No active wallet'), findsOneWidget);
  });

  testWidgets('/send redirects to HomePage when offline', (tester) async {
    await pumpRouterAt(
      tester,
      AppRoutes.send,
      connectivityResults: const [ConnectivityResult.none],
      seedActiveWallet: true,
    );

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Coming soon'), findsNothing);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('/send resolves to SendPage when online with active wallet', (
    tester,
  ) async {
    await pumpRouterAt(
      tester,
      AppRoutes.send,
      seedActiveWallet: true,
      isOnline: true,
    );

    expect(find.byType(SendPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
  });

  testWidgets('/recover-wallet resolves to RecoverWalletPage', (tester) async {
    await pumpRouterAt(tester, AppRoutes.recoverWallet);

    expect(find.byType(RecoverWalletPage), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsNothing);
    expect(find.text('Recover Wallet'), findsOneWidget);
  });
}
