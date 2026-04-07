import 'dart:async';
import 'package:bdk_demo/features/wallet_setup/active_wallets_page.dart';
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:bdk_dart/bdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storageService;

  Future<StorageService> initStorage() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs: prefs);
  }

  GoRouter testRouter() {
    return GoRouter(
      initialLocation: AppRoutes.activeWallets,
      routes: [
        GoRoute(
          path: AppRoutes.activeWallets,
          builder: (context, state) => const ActiveWalletsPage(),
        ),
        GoRoute(
          path: AppRoutes.createWallet,
          builder: (context, state) =>
              const Scaffold(body: Text('Create Wallet Page')),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
      ],
    );
  }

  Future<void> pumpActiveWalletsPage(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: testRouter()),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ActiveWalletsPage empty state', () {
    testWidgets('shows empty state and navigates to create wallet', (
      tester,
    ) async {
      storageService = await initStorage();
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );
      addTearDown(container.dispose);

      await pumpActiveWalletsPage(tester, container);

      expect(find.text('No wallets yet'), findsOneWidget);
      expect(find.text('Create a Wallet'), findsOneWidget);

      await tester.tap(find.text('Create a Wallet'));
      await tester.pumpAndSettle();

      expect(find.text('Create Wallet Page'), findsOneWidget);
    });
  });

  group('ActiveWalletsPage with wallets', () {
    testWidgets('renders wallet cards with name and chips', (tester) async {
      storageService = await initStorage();

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );
      addTearDown(container.dispose);

      await storageService.addWalletRecord(
        WalletRecord(
          id: 'w1',
          name: 'Testnet Wallet',
          network: WalletNetwork.testnet,
          scriptType: ScriptType.p2wpkh,
        ),
        WalletSecrets(
          descriptor: 'dummy-desc',
          changeDescriptor: 'dummy-change',
        ),
      );
      await storageService.addWalletRecord(
        WalletRecord(
          id: 'w2',
          name: 'Signet Taproot',
          network: WalletNetwork.signet,
          scriptType: ScriptType.p2tr,
        ),
        WalletSecrets(
          descriptor: 'dummy-desc-2',
          changeDescriptor: 'dummy-change-2',
        ),
      );

      await pumpActiveWalletsPage(tester, container);

      expect(find.text('Testnet Wallet'), findsOneWidget);
      expect(find.text('Testnet 3'), findsOneWidget);
      expect(find.text('P2WPKH'), findsOneWidget);

      expect(find.text('Signet Taproot'), findsOneWidget);
      expect(find.text('Signet'), findsOneWidget);
      expect(find.text('P2TR'), findsOneWidget);
    });

    testWidgets('successful load sets active providers and navigates home', (
      tester,
    ) async {
      storageService = await initStorage();
      final walletService = WalletService(
        storage: storageService,
        uuid: const Uuid(),
      );

      final (record, createdWallet) = await walletService.createWallet(
        'Load Me',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      createdWallet.dispose();

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );
      addTearDown(container.dispose);

      await pumpActiveWalletsPage(tester, container);

      await tester.tap(find.text('Load Me'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(container.read(activeWalletRecordProvider)?.id, record.id);

      final activeWallet = container.read(activeWalletProvider);
      expect(activeWallet, isNotNull);
    });

    testWidgets('missing secrets shows error and does not navigate', (
      tester,
    ) async {
      storageService = await initStorage();

      const record = WalletRecord(
        id: 'missing-secrets-id',
        name: 'Missing Secrets Wallet',
        network: WalletNetwork.testnet,
        scriptType: ScriptType.p2wpkh,
      );

      await storageService.addWalletRecord(
        record,
        const WalletSecrets(
          descriptor: 'dummy-desc',
          changeDescriptor: 'dummy-change',
        ),
      );

      await const FlutterSecureStorage().delete(
        key: 'wallet_secrets_${record.id}',
      );
      expect(await storageService.getSecrets(record.id), isNull);

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
      );
      addTearDown(container.dispose);

      await pumpActiveWalletsPage(tester, container);

      await tester.tap(find.text('Missing Secrets Wallet'));
      await tester.pumpAndSettle();

      expect(find.text('Secrets not found for this wallet'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
      expect(find.byType(ActiveWalletsPage), findsOneWidget);
    });

    testWidgets(
      'disposes loaded wallet if page unmounts before await returns',
      (tester) async {
        storageService = await initStorage();

        const record = WalletRecord(
          id: 'pending-load-id',
          name: 'Pending Load Wallet',
          network: WalletNetwork.signet,
          scriptType: ScriptType.p2tr,
        );

        await storageService.addWalletRecord(
          record,
          const WalletSecrets(
            descriptor: 'dummy-desc',
            changeDescriptor: 'dummy-change',
          ),
        );

        final realWalletService = WalletService(
          storage: storageService,
          uuid: const Uuid(),
        );
        final (_, wallet) = await realWalletService.createWallet(
          'Load Candidate',
          WalletNetwork.signet,
          ScriptType.p2tr,
        );

        final completer = Completer<Wallet>();
        final delayedService = _DelayedLoadWalletService(
          storage: storageService,
          completer: completer,
        );

        var disposeCalls = 0;
        final container = ProviderContainer(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            walletServiceProvider.overrideWithValue(delayedService),
            walletDisposerProvider.overrideWithValue((wallet) {
              disposeCalls += 1;
              wallet.dispose();
            }),
          ],
        );
        addTearDown(container.dispose);

        await pumpActiveWalletsPage(tester, container);

        await tester.tap(find.text('Pending Load Wallet'));
        await tester.pump();

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        completer.complete(wallet);
        await tester.pumpAndSettle();

        expect(disposeCalls, 1);
        expect(container.read(activeWalletProvider), isNull);
        expect(container.read(activeWalletRecordProvider), isNull);
      },
    );
  });
}

class _DelayedLoadWalletService extends WalletService {
  _DelayedLoadWalletService({required super.storage, required this.completer})
    : super(uuid: const Uuid());

  final Completer<Wallet> completer;

  @override
  Future<Wallet> loadWalletFromRecord(WalletRecord record) {
    return completer.future;
  }
}
