import 'package:bdk_dart/bdk.dart' hide Key;
import 'package:bdk_demo/features/send/send_page.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/send_providers.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<ProviderContainer> createContainer({
    Map<int, double> feeEstimates = const {1: 2.2, 3: 1.4, 6: 1.0},
    bool seedActiveWallet = true,
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
}
