import 'package:bdk_dart/bdk.dart' hide Key;
import 'package:bdk_demo/core/router/app_router.dart';
import 'package:bdk_demo/features/send/send_page.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/send_providers.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/blockchain_service.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
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

  Future<ProviderContainer> createContainer({
    Map<int, double> feeEstimates = const {1: 2.2, 3: 1.4, 6: 1.0},
    bool seedActiveWallet = true,
    SendTransactionDraftBuilder? draftBuilder,
    BlockchainClientFactory? blockchainClientFactory,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs: prefs);
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        connectivityProvider.overrideWith(
          (ref) => Stream.value(const [ConnectivityResult.wifi]),
        ),
        feeEstimatesJobRunnerProvider.overrideWithValue(
          (_) async => feeEstimates,
        ),
        if (draftBuilder != null)
          sendTransactionDraftBuilderProvider.overrideWithValue(draftBuilder),
        if (blockchainClientFactory != null)
          blockchainClientFactoryProvider.overrideWithValue(
            blockchainClientFactory,
          ),
      ],
    );
    addTearDown(container.dispose);

    if (seedActiveWallet) {
      container
          .read(activeWalletRecordProvider.notifier)
          .set(
            const WalletRecord(
              id: 'send-wallet',
              name: 'Send Wallet',
              network: WalletNetwork.testnet,
              scriptType: ScriptType.p2wpkh,
            ),
          );
      container.read(activeWalletProvider.notifier).set(_createTestWallet());
    }

    return container;
  }

  Future<void> pumpSendPage(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SendPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpSendPageWithRouter(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoutes.send,
      routes: [
        GoRoute(
          path: AppRoutes.send,
          builder: (context, state) => const SendPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Text('Home route'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fillSendForm(
    WidgetTester tester, {
    String address = 'tb1qexampleaddress',
    String amount = '1000',
    String feeRate = '2',
  }) async {
    await tester.enterText(
      find.byKey(const Key('send-recipient-field')),
      address,
    );
    await tester.enterText(find.byKey(const Key('send-amount-field')), amount);
    await tester.enterText(
      find.byKey(const Key('send-fee-rate-field')),
      feeRate,
    );
    await tester.pump();
  }

  Future<void> tapReview(WidgetTester tester) async {
    final reviewButton = find.widgetWithText(
      FilledButton,
      'Review transaction',
    );
    await tester.drag(find.byType(ListView), const Offset(0, -250));
    await tester.pump();
    await tester.tap(reviewButton);
  }

  testWidgets('renders address, amount, fee rate, and review button', (
    tester,
  ) async {
    final container = await createContainer();

    await pumpSendPage(tester, container);

    expect(find.text('Recipient address'), findsOneWidget);
    expect(find.text('Amount (sats)'), findsOneWidget);
    expect(find.text('Fee rate (sat/vB)'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Review transaction'),
      findsOneWidget,
    );
  });

  testWidgets('empty form hides validation messages and disables review', (
    tester,
  ) async {
    final container = await createContainer();

    await pumpSendPage(tester, container);

    expect(find.text('Recipient address is required.'), findsNothing);
    expect(find.text('Amount is required.'), findsNothing);
    expect(find.text('Fee rate is required.'), findsNothing);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Review transaction'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('fee suggestion fills the fee-rate field', (tester) async {
    final container = await createContainer(feeEstimates: const {3: 2.2});

    await pumpSendPage(tester, container);

    await tester.tap(find.text('3 blocks · 3 sat/vB'));
    await tester.pump();

    expect(
      tester.widget<TextFormField>(
        find.byKey(const Key('send-fee-rate-field')),
      ),
      isA<TextFormField>().having(
        (field) => field.controller?.text,
        'fee rate',
        '3',
      ),
    );
  });

  testWidgets('invalid numeric input keeps review disabled', (tester) async {
    final container = await createContainer();

    await pumpSendPage(tester, container);

    await tester.enterText(
      find.byKey(const Key('send-recipient-field')),
      'tb1qexampleaddress',
    );
    await tester.enterText(find.byKey(const Key('send-amount-field')), '0');
    await tester.enterText(find.byKey(const Key('send-fee-rate-field')), '0');
    await tester.pump();

    expect(find.text('Amount must be greater than zero.'), findsOneWidget);
    expect(find.text('Fee rate must be greater than zero.'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Review transaction'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('valid form enables review without broadcasting', (tester) async {
    final container = await createContainer();

    await pumpSendPage(tester, container);

    await tester.enterText(
      find.byKey(const Key('send-recipient-field')),
      'tb1qexampleaddress',
    );
    await tester.enterText(find.byKey(const Key('send-amount-field')), '1000');
    await tester.enterText(find.byKey(const Key('send-fee-rate-field')), '2');
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Review transaction'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('amount unit switcher converts between sats and BTC', (
    tester,
  ) async {
    final container = await createContainer();

    await pumpSendPage(tester, container);
    await tester.enterText(
      find.byKey(const Key('send-amount-field')),
      '100000000',
    );
    await tester.tap(find.text('BTC'));
    await tester.pump();

    expect(
      tester.widget<TextFormField>(find.byKey(const Key('send-amount-field'))),
      isA<TextFormField>().having(
        (field) => field.controller?.text,
        'amount',
        '1',
      ),
    );

    await tester.tap(find.text('sats'));
    await tester.pump();

    expect(
      tester.widget<TextFormField>(find.byKey(const Key('send-amount-field'))),
      isA<TextFormField>().having(
        (field) => field.controller?.text,
        'amount',
        '100000000',
      ),
    );
  });

  testWidgets('BTC amount input converts to exact sats for build', (
    tester,
  ) async {
    final fake = _SendFlowFake();
    final container = await createContainer(draftBuilder: fake.build);

    await pumpSendPage(tester, container);
    await tester.tap(find.text('BTC'));
    await tester.pump();
    await fillSendForm(tester, amount: '0.00001000');

    await tapReview(tester);
    await tester.pumpAndSettle();

    expect(fake.builtAmountSat, 1000);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Review transaction'),
      ),
      findsOneWidget,
    );
    expect(find.text('0.00001 BTC (1000 sats)'), findsOneWidget);
  });

  testWidgets('BTC input with more than 8 decimals keeps review disabled', (
    tester,
  ) async {
    final container = await createContainer();

    await pumpSendPage(tester, container);
    await tester.tap(find.text('BTC'));
    await tester.pump();
    await fillSendForm(tester, amount: '0.000000001');

    expect(
      find.text('BTC amount cannot exceed 8 decimal places.'),
      findsOneWidget,
    );
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Review transaction'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('valid submit opens confirmation dialog', (tester) async {
    final fake = _SendFlowFake();
    final container = await createContainer(draftBuilder: fake.build);

    await pumpSendPage(tester, container);
    await fillSendForm(tester);
    await tapReview(tester);
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Review transaction'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('tb1qexampleaddress'),
      ),
      findsOneWidget,
    );
    expect(find.text('1000 sats'), findsOneWidget);
    expect(find.text('2 sat/vB'), findsOneWidget);
    expect(find.text('321 sats'), findsOneWidget);
    expect(fake.buildCount, 1);
  });

  testWidgets('cancel dismisses dialog and does not broadcast', (tester) async {
    final fake = _SendFlowFake();
    final container = await createContainer(draftBuilder: fake.build);

    await pumpSendPage(tester, container);
    await fillSendForm(tester);
    await tapReview(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(fake.broadcastCount, 0);
  });

  testWidgets('confirm broadcasts and navigates home', (tester) async {
    final fake = _SendFlowFake();
    final container = await createContainer(
      draftBuilder: fake.build,
      blockchainClientFactory: (_) => _FakeBlockchainClient(),
    );

    await pumpSendPageWithRouter(tester, container);
    await fillSendForm(tester);
    await tapReview(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(fake.buildCount, 1);
    expect(fake.broadcastCount, 1);
    expect(find.text('Home route'), findsOneWidget);
  });

  testWidgets('build failure shows friendly snackbar and stays on SendPage', (
    tester,
  ) async {
    final fake = _SendFlowFake(failBuild: true);
    final container = await createContainer(draftBuilder: fake.build);

    await pumpSendPage(tester, container);
    await fillSendForm(tester);
    await tapReview(tester);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Could not build transaction. Check the address, amount, and fee rate.',
      ),
      findsOneWidget,
    );
    expect(find.byType(SendPage), findsOneWidget);
  });

  testWidgets('broadcast failure shows friendly snackbar and stays on SendPage', (
    tester,
  ) async {
    final fake = _SendFlowFake(failBroadcast: true);
    final container = await createContainer(
      draftBuilder: fake.build,
      blockchainClientFactory: (_) => _FakeBlockchainClient(),
    );

    await pumpSendPage(tester, container);
    await fillSendForm(tester);
    await tapReview(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(fake.broadcastCount, 1);
    expect(
      find.text(
        'Could not broadcast transaction. Check your connection and try again.',
      ),
      findsOneWidget,
    );
    expect(find.byType(SendPage), findsOneWidget);
  });
}

final class _SendFlowFake {
  _SendFlowFake({this.failBuild = false, this.failBroadcast = false});

  final bool failBuild;
  final bool failBroadcast;
  int buildCount = 0;
  int broadcastCount = 0;
  int? builtAmountSat;

  Future<SendTransactionDraft> build({
    required WalletRecord record,
    required Wallet wallet,
    required String recipientAddress,
    required int amountSat,
    required int feeRateSatPerVb,
  }) async {
    buildCount++;
    builtAmountSat = amountSat;
    if (failBuild) {
      throw StateError('build failed');
    }
    return SendTransactionDraft(
      feeSat: 321,
      broadcast: (_) async {
        broadcastCount++;
        if (failBroadcast) {
          throw StateError('broadcast failed');
        }
        return 'fake-txid';
      },
    );
  }
}

final class _FakeBlockchainClient implements BlockchainClient {
  @override
  BlockchainBackend get backend => BlockchainBackend.electrum;

  @override
  void broadcast(Transaction transaction) {}

  @override
  void dispose() {}

  @override
  Map<int, double> getFeeEstimates() => const {};

  @override
  int getTipHeight() => 0;
}
