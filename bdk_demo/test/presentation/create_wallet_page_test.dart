import 'dart:async';
import 'dart:io';
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/features/wallet_setup/create_wallet_page.dart';
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

const _testExtendedPrivKey =
    'tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B';

Wallet _createTestWallet({Network network = Network.signet}) {
  final descriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
    network: network,
  );
  final changeDescriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
    network: network,
  );
  return Wallet(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    network: network,
    persister: Persister.newInMemory(),
    lookahead: 25,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Directory? walletDocsRoot;

  setUp(() async {
    walletDocsRoot = await Directory.systemTemp.createTemp(
      'create_wallet_page_wallet_',
    );
    WalletStoragePaths.setDocumentsRootOverride(walletDocsRoot);
  });

  tearDown(() async {
    WalletStoragePaths.setDocumentsRootOverride(null);
    final root = walletDocsRoot;
    walletDocsRoot = null;
    if (root != null && root.existsSync()) {
      await root.delete(recursive: true);
    }
  });

  Future<StorageService> initStorage() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs: prefs);
  }

  GoRouter testRouter() {
    return GoRouter(
      initialLocation: AppRoutes.createWallet,
      routes: [
        GoRoute(
          path: AppRoutes.createWallet,
          builder: (context, state) => const CreateWalletPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
      ],
    );
  }

  Future<void> pumpCreateWalletPage(
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

  group('CreateWalletPage', () {
    testWidgets('create button disabled when name is blank', (tester) async {
      final storage = await initStorage();
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);

      await pumpCreateWalletPage(tester, container);

      final createButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Create Wallet'),
      );
      expect(createButton.onPressed, isNull);
    });

    testWidgets('successful create sets active providers and navigates home', (
      tester,
    ) async {
      final storage = await initStorage();
      final successfulService = _SuccessfulCreateWalletService(
        storage: storage,
      );
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          walletServiceProvider.overrideWithValue(successfulService),
        ],
      );
      addTearDown(container.dispose);

      await pumpCreateWalletPage(tester, container);

      await tester.enterText(find.byType(TextField), 'My Commit3 Wallet');
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Create Wallet'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);

      final activeRecord = container.read(activeWalletRecordProvider);
      expect(activeRecord, isNotNull);
      expect(activeRecord!.name, 'My Commit3 Wallet');

      final activeWallet = container.read(activeWalletProvider);
      expect(activeWallet, isNotNull);
    });

    testWidgets('duplicate name shows snackbar and does not call service', (
      tester,
    ) async {
      final storage = await initStorage();

      await storage.addWalletRecord(
        const WalletRecord(
          id: 'existing-id',
          name: 'Existing Wallet',
          network: WalletNetwork.signet,
          scriptType: ScriptType.p2tr,
        ),
        const WalletSecrets(
          descriptor: 'dummy',
          changeDescriptor: 'dummy-change',
        ),
      );

      final duplicateGuardService = _DuplicateGuardWalletService(
        storage: storage,
      );
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          walletServiceProvider.overrideWithValue(duplicateGuardService),
        ],
      );
      addTearDown(container.dispose);

      await pumpCreateWalletPage(tester, container);

      await tester.enterText(find.byType(TextField), 'existing wallet');
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Create Wallet'));
      await tester.pump();

      expect(
        find.text('A wallet with that name already exists'),
        findsOneWidget,
      );
      expect(duplicateGuardService.createCalls, 0);
    });

    testWidgets('service failure shows generic error snackbar', (tester) async {
      final storage = await initStorage();
      final failingService = _FailingWalletService(storage: storage);
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          walletServiceProvider.overrideWithValue(failingService),
        ],
      );
      addTearDown(container.dispose);

      await pumpCreateWalletPage(tester, container);

      await tester.enterText(find.byType(TextField), 'Will Fail');
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Create Wallet'));
      await tester.pump();

      expect(
        find.text('Failed to create wallet. Please try again.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'disposes created wallet if page unmounts before await returns',
      (tester) async {
        final storage = await initStorage();
        final wallet = _createTestWallet();
        const record = WalletRecord(
          id: 'pending-wallet-id',
          name: 'Pending Wallet',
          network: WalletNetwork.signet,
          scriptType: ScriptType.p2tr,
        );

        final completer = Completer<(WalletRecord, Wallet)>();
        final delayedService = _DelayedCreateWalletService(
          storage: storage,
          completer: completer,
        );

        var disposeCalls = 0;
        final container = ProviderContainer(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
            walletServiceProvider.overrideWithValue(delayedService),
            walletDisposerProvider.overrideWithValue((wallet) {
              disposeCalls += 1;
              wallet.dispose();
            }),
          ],
        );
        addTearDown(container.dispose);

        await pumpCreateWalletPage(tester, container);

        await tester.enterText(find.byType(TextField), 'Will Unmount');
        await tester.pump();
        await tester.tap(find.widgetWithText(FilledButton, 'Create Wallet'));
        await tester.pump();

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        completer.complete((record, wallet));
        await tester.pumpAndSettle();

        expect(disposeCalls, 1);
        expect(container.read(activeWalletProvider), isNull);
        expect(container.read(activeWalletRecordProvider), isNull);
      },
    );
  });
}

class _DuplicateGuardWalletService extends WalletService {
  _DuplicateGuardWalletService({required super.storage})
    : super(uuid: const Uuid());

  int createCalls = 0;

  @override
  Future<(WalletRecord, Wallet)> createWallet(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
  ) async {
    createCalls += 1;
    throw StateError('createWallet should not be called in duplicate test');
  }
}

class _FailingWalletService extends WalletService {
  _FailingWalletService({required super.storage}) : super(uuid: const Uuid());

  @override
  Future<(WalletRecord, Wallet)> createWallet(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
  ) async {
    throw Exception('forced failure');
  }
}

class _SuccessfulCreateWalletService extends WalletService {
  _SuccessfulCreateWalletService({required super.storage})
    : super(uuid: const Uuid());

  @override
  Future<(WalletRecord, Wallet)> createWallet(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
  ) async {
    return (
      WalletRecord(
        id: 'created-wallet-id',
        name: name,
        network: walletNetwork,
        scriptType: scriptType,
      ),
      _createTestWallet(
        network: switch (walletNetwork) {
          WalletNetwork.signet => Network.signet,
          WalletNetwork.testnet => Network.testnet,
          WalletNetwork.regtest => Network.regtest,
        },
      ),
    );
  }
}

class _DelayedCreateWalletService extends WalletService {
  _DelayedCreateWalletService({required super.storage, required this.completer})
    : super(uuid: const Uuid());

  final Completer<(WalletRecord, Wallet)> completer;

  @override
  Future<(WalletRecord, Wallet)> createWallet(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
  ) {
    return completer.future;
  }
}
