import 'package:bdk_demo/features/receive/receive_page.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/address_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _testAddress = 'tb1qfm5n6w9u7r8ct3q3c2eqcdshw8f8hy5sjzlx6t';

const _testRecord = WalletRecord(
  id: 'wallet-1',
  name: 'Receive Wallet',
  network: WalletNetwork.testnet,
  scriptType: ScriptType.p2wpkh,
);

class _FakeReceiveAddressNotifier extends CurrentReceiveAddressNotifier {
  _FakeReceiveAddressNotifier(this.initialState);

  final ReceiveAddressState initialState;
  var generationCalls = 0;

  @override
  ReceiveAddressState build() => initialState;

  @override
  Future<void> generateForActiveWallet() async {
    generationCalls += 1;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpReceivePage(
    WidgetTester tester, {
    required _FakeReceiveAddressNotifier notifier,
    WalletRecord? activeWallet,
  }) async {
    final container = ProviderContainer(
      overrides: [currentReceiveAddressProvider.overrideWith(() => notifier)],
    );
    addTearDown(container.dispose);

    if (activeWallet != null) {
      container.read(activeWalletRecordProvider.notifier).set(activeWallet);
    }

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ReceivePage()),
      ),
    );
    await tester.pump();
    return container;
  }

  testWidgets('shows generate action for an active wallet', (tester) async {
    final notifier = _FakeReceiveAddressNotifier(ReceiveAddressState.empty);
    await pumpReceivePage(
      tester,
      notifier: notifier,
      activeWallet: _testRecord,
    );

    expect(find.text('Generate address'), findsOneWidget);

    await tester.tap(find.text('Generate address'));
    await tester.pump();

    expect(notifier.generationCalls, 1);
  });

  testWidgets('shows QR, address, index, and new-address action', (
    tester,
  ) async {
    final notifier = _FakeReceiveAddressNotifier(
      const ReceiveAddressState(
        walletId: 'wallet-1',
        address: _testAddress,
        index: 7,
      ),
    );
    await pumpReceivePage(
      tester,
      notifier: notifier,
      activeWallet: _testRecord,
    );

    expect(find.byKey(const Key('receive-address-qr')), findsOneWidget);
    expect(find.text(_testAddress), findsOneWidget);
    expect(find.text('External index 7'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();

    expect(find.text('Generate new address'), findsOneWidget);
  });

  testWidgets('shows loading and disables generation', (tester) async {
    final notifier = _FakeReceiveAddressNotifier(
      const ReceiveAddressState(walletId: 'wallet-1', isGenerating: true),
    );
    await pumpReceivePage(
      tester,
      notifier: notifier,
      activeWallet: _testRecord,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('shows provider error and retry action', (tester) async {
    final notifier = _FakeReceiveAddressNotifier(
      const ReceiveAddressState(
        walletId: 'wallet-1',
        errorMessage: 'StateError: generation failed',
      ),
    );
    await pumpReceivePage(
      tester,
      notifier: notifier,
      activeWallet: _testRecord,
    );

    expect(find.textContaining('generation failed'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('copies the address and confirms the action', (tester) async {
    final clipboardCalls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') clipboardCalls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    final notifier = _FakeReceiveAddressNotifier(
      const ReceiveAddressState(
        walletId: 'wallet-1',
        address: _testAddress,
        index: 0,
      ),
    );
    await pumpReceivePage(
      tester,
      notifier: notifier,
      activeWallet: _testRecord,
    );

    await tester.tap(find.text('Copy address'));
    await tester.pump();

    expect(clipboardCalls, hasLength(1));
    expect(clipboardCalls.single.arguments, {'text': _testAddress});
    expect(find.text('Address copied'), findsOneWidget);
  });

  testWidgets('shows safe state without an active wallet', (tester) async {
    final notifier = _FakeReceiveAddressNotifier(ReceiveAddressState.empty);
    await pumpReceivePage(tester, notifier: notifier);

    expect(find.text('No active wallet'), findsOneWidget);
    expect(find.text('Generate address'), findsNothing);
  });
}
