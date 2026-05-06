import 'dart:async';

import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/wallet_setup/recover_wallet_page.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _valid12WordPhrase =
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon about';

const _invalidChecksumPhrase =
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon ability';

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

  Future<StorageService> initStorage() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs: prefs);
  }

  GoRouter testRouter() {
    return GoRouter(
      initialLocation: AppRoutes.recoverWallet,
      routes: [
        GoRoute(
          path: AppRoutes.recoverWallet,
          builder: (context, state) => const RecoverWalletPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
      ],
    );
  }

  Future<void> pumpRecoverWalletPage(
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

  Future<void> tapSubmitButton(WidgetTester tester, String label) async {
    final button = find.widgetWithText(FilledButton, label);
    await tester.ensureVisible(button);
    await tester.pump();
    await tester.tap(button);
  }

  group('RecoverWalletPage', () {
    testWidgets('page renders both tabs without layout exceptions', (
      tester,
    ) async {
      final storage = await initStorage();
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);

      await pumpRecoverWalletPage(tester, container);

      expect(find.text('Phrase'), findsOneWidget);
      expect(find.text('Descriptor'), findsOneWidget);
      expect(find.text('Recovery Phrase'), findsOneWidget);

      await tester.tap(find.text('Descriptor'));
      await tester.pumpAndSettle();

      expect(find.text('External Descriptor'), findsOneWidget);
      expect(find.text('Change Descriptor'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('phrase recover button disabled when required input is blank', (
      tester,
    ) async {
      final storage = await initStorage();
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);

      await pumpRecoverWalletPage(tester, container);

      var button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Recover From Phrase'),
      );
      expect(button.onPressed, isNull);

      await tester.enterText(
        find.widgetWithText(TextField, 'Wallet Name'),
        'Phrase Wallet',
      );
      await tester.pump();

      button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Recover From Phrase'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('phrase duplicate name shows snackbar without service call', (
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

      final duplicateGuardService = _DuplicateGuardRecoveryService(
        storage: storage,
      );
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          walletServiceProvider.overrideWithValue(duplicateGuardService),
        ],
      );
      addTearDown(container.dispose);

      await pumpRecoverWalletPage(tester, container);

      await tester.enterText(
        find.widgetWithText(TextField, 'Wallet Name'),
        'existing wallet',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Recovery Phrase'),
        _valid12WordPhrase,
      );
      await tester.pump();

      await tapSubmitButton(tester, 'Recover From Phrase');
      await tester.pump();

      expect(
        find.text('A wallet with that name already exists'),
        findsOneWidget,
      );
      expect(duplicateGuardService.phraseCalls, 0);
    });

    testWidgets('phrase validation failure shows snackbar without updates', (
      tester,
    ) async {
      final storage = await initStorage();
      final activeWallet = _createTestWallet();
      const activeRecord = WalletRecord(
        id: 'already-active-id',
        name: 'Already Active',
        network: WalletNetwork.signet,
        scriptType: ScriptType.p2tr,
      );
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);
      container.read(activeWalletProvider.notifier).set(activeWallet);
      container.read(activeWalletRecordProvider.notifier).set(activeRecord);

      await pumpRecoverWalletPage(tester, container);

      await tester.enterText(
        find.widgetWithText(TextField, 'Wallet Name'),
        'Invalid Phrase Wallet',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Recovery Phrase'),
        _invalidChecksumPhrase,
      );
      await tester.pump();

      await tapSubmitButton(tester, 'Recover From Phrase');
      await tester.pump();

      expect(
        find.text(
          'Recovery phrase checksum is invalid. Please double-check the phrase.',
        ),
        findsOneWidget,
      );
      expect(container.read(activeWalletRecordProvider), same(activeRecord));
      expect(container.read(activeWalletProvider), same(activeWallet));
    });

    testWidgets('phrase success sets active providers and navigates home', (
      tester,
    ) async {
      final storage = await initStorage();
      final service = _SuccessfulPhraseRecoveryService(
        storage: storage,
        storageRef: storage,
      );
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          walletServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await pumpRecoverWalletPage(tester, container);

      await tester.enterText(
        find.widgetWithText(TextField, 'Wallet Name'),
        'Recovered Phrase Wallet',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Recovery Phrase'),
        _valid12WordPhrase,
      );
      await tester.pump();

      await tapSubmitButton(tester, 'Recover From Phrase');
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);

      final activeRecord = container.read(activeWalletRecordProvider);
      expect(activeRecord, isNotNull);
      expect(activeRecord!.name, 'Recovered Phrase Wallet');
      expect(container.read(activeWalletProvider), isNotNull);
      expect(container.read(walletRecordsProvider).length, 1);
    });

    testWidgets(
      'descriptor recover button disabled when required input is blank',
      (tester) async {
        final storage = await initStorage();
        final container = ProviderContainer(
          overrides: [storageServiceProvider.overrideWithValue(storage)],
        );
        addTearDown(container.dispose);

        await pumpRecoverWalletPage(tester, container);
        await tester.tap(find.text('Descriptor'));
        await tester.pumpAndSettle();

        var button = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Recover From Descriptors'),
        );
        expect(button.onPressed, isNull);

        await tester.enterText(
          find.widgetWithText(TextField, 'Wallet Name'),
          'Descriptor Wallet',
        );
        await tester.enterText(
          find.widgetWithText(TextField, 'External Descriptor'),
          'external',
        );
        await tester.pump();

        button = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Recover From Descriptors'),
        );
        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'descriptor duplicate name shows snackbar without service call',
      (tester) async {
        final storage = await initStorage();
        await storage.addWalletRecord(
          const WalletRecord(
            id: 'existing-id',
            name: 'Existing Descriptor',
            network: WalletNetwork.signet,
            scriptType: ScriptType.unknown,
          ),
          const WalletSecrets(
            descriptor: 'dummy',
            changeDescriptor: 'dummy-change',
          ),
        );

        final duplicateGuardService = _DuplicateGuardRecoveryService(
          storage: storage,
        );
        final container = ProviderContainer(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
            walletServiceProvider.overrideWithValue(duplicateGuardService),
          ],
        );
        addTearDown(container.dispose);

        await pumpRecoverWalletPage(tester, container);
        await tester.tap(find.text('Descriptor'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextField, 'Wallet Name'),
          'existing descriptor',
        );
        await tester.enterText(
          find.widgetWithText(TextField, 'External Descriptor'),
          'external',
        );
        await tester.enterText(
          find.widgetWithText(TextField, 'Change Descriptor'),
          'change',
        );
        await tester.pump();

        await tapSubmitButton(tester, 'Recover From Descriptors');
        await tester.pump();

        expect(
          find.text('A wallet with that name already exists'),
          findsOneWidget,
        );
        expect(duplicateGuardService.descriptorCalls, 0);
      },
    );

    testWidgets('descriptor validation failure shows snackbar', (tester) async {
      final storage = await initStorage();
      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);

      await pumpRecoverWalletPage(tester, container);
      await tester.tap(find.text('Descriptor'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Wallet Name'),
        'Invalid Descriptor Wallet',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'External Descriptor'),
        'not-a-real-descriptor',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Change Descriptor'),
        'not-a-real-descriptor',
      );
      await tester.pump();

      await tapSubmitButton(tester, 'Recover From Descriptors');
      await tester.pump();

      expect(
        find.text('Invalid descriptor. Please check both descriptors.'),
        findsOneWidget,
      );
    });

    testWidgets('descriptor success sets active providers and navigates home', (
      tester,
    ) async {
      final storage = await initStorage();
      final service = _SuccessfulDescriptorRecoveryService(
        storage: storage,
        storageRef: storage,
      );
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          walletServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await pumpRecoverWalletPage(tester, container);
      await tester.tap(find.text('Descriptor'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Wallet Name'),
        'Recovered Descriptor Wallet',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'External Descriptor'),
        'descriptor-external',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Change Descriptor'),
        'descriptor-change',
      );
      await tester.pump();

      await tapSubmitButton(tester, 'Recover From Descriptors');
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);

      final activeRecord = container.read(activeWalletRecordProvider);
      expect(activeRecord, isNotNull);
      expect(activeRecord!.name, 'Recovered Descriptor Wallet');
      expect(activeRecord.scriptType, ScriptType.unknown);
      expect(container.read(activeWalletProvider), isNotNull);
      expect(
        container
            .read(walletRecordsProvider)
            .any((record) => record.name == 'Recovered Descriptor Wallet'),
        isTrue,
      );
    });

    testWidgets(
      'disposes recovered wallet if page unmounts before await returns',
      (tester) async {
        final storage = await initStorage();
        final wallet = _createTestWallet();
        const record = WalletRecord(
          id: 'pending-recovered-id',
          name: 'Pending Recovered Wallet',
          network: WalletNetwork.signet,
          scriptType: ScriptType.p2tr,
        );

        final completer = Completer<(WalletRecord, Wallet)>();
        final delayedService = _DelayedPhraseRecoveryService(
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

        await pumpRecoverWalletPage(tester, container);

        await tester.enterText(
          find.widgetWithText(TextField, 'Wallet Name'),
          'Will Unmount',
        );
        await tester.enterText(
          find.widgetWithText(TextField, 'Recovery Phrase'),
          _valid12WordPhrase,
        );
        await tester.pump();
        await tapSubmitButton(tester, 'Recover From Phrase');
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

class _DuplicateGuardRecoveryService extends WalletService {
  _DuplicateGuardRecoveryService({required super.storage})
    : super(uuid: const Uuid());

  int phraseCalls = 0;
  int descriptorCalls = 0;

  @override
  Future<(WalletRecord, Wallet)> recoverFromPhrase(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
    String phrase,
  ) async {
    phraseCalls += 1;
    throw StateError('recoverFromPhrase should not be called');
  }

  @override
  Future<(WalletRecord, Wallet)> recoverFromDescriptors(
    String name,
    WalletNetwork walletNetwork,
    String descriptorStr,
    String changeDescriptorStr,
  ) async {
    descriptorCalls += 1;
    throw StateError('recoverFromDescriptors should not be called');
  }
}

class _DelayedPhraseRecoveryService extends WalletService {
  _DelayedPhraseRecoveryService({
    required super.storage,
    required this.completer,
  }) : super(uuid: const Uuid());

  final Completer<(WalletRecord, Wallet)> completer;

  @override
  Future<(WalletRecord, Wallet)> recoverFromPhrase(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
    String phrase,
  ) {
    return completer.future;
  }
}

class _SuccessfulPhraseRecoveryService extends WalletService {
  _SuccessfulPhraseRecoveryService({
    required this.storageRef,
    required super.storage,
  }) : super(uuid: const Uuid());

  final StorageService storageRef;

  @override
  Future<(WalletRecord, Wallet)> recoverFromPhrase(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
    String phrase,
  ) async {
    final record = WalletRecord(
      id: 'recovered-phrase-id',
      name: name,
      network: walletNetwork,
      scriptType: scriptType,
    );
    await storageRef.addWalletRecord(
      record,
      const WalletSecrets(
        descriptor: 'dummy-desc',
        changeDescriptor: 'dummy-change',
      ),
    );
    return (
      record,
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

class _SuccessfulDescriptorRecoveryService extends WalletService {
  _SuccessfulDescriptorRecoveryService({
    required this.storageRef,
    required super.storage,
  }) : super(uuid: const Uuid());

  final StorageService storageRef;

  @override
  Future<(WalletRecord, Wallet)> recoverFromDescriptors(
    String name,
    WalletNetwork walletNetwork,
    String descriptorStr,
    String changeDescriptorStr,
  ) async {
    final record = WalletRecord(
      id: 'recovered-descriptor-id',
      name: name,
      network: walletNetwork,
      scriptType: ScriptType.unknown,
    );
    await storageRef.addWalletRecord(
      record,
      const WalletSecrets(
        descriptor: 'dummy-desc',
        changeDescriptor: 'dummy-change',
      ),
    );
    return (
      record,
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
