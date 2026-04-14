import 'package:bdk_demo/features/wallet_setup/active_wallets_page.dart';
import 'package:bdk_demo/models/tx_details.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _testWalletInfo = DemoWalletInfo(
  title: 'Reference Wallet Scaffold',
  network: WalletNetwork.testnet,
  descriptor: 'wpkh([demo/84h/1h/0h]tpubReferenceScaffold/0/*)#demo1234',
  descriptorLabel: 'Placeholder descriptor',
);

final _placeholderTransactions = <TxDetails>[
  TxDetails(
    txid: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
    sent: 0,
    received: 42000,
    balanceDelta: 42000,
    pending: false,
    blockHeight: 120,
    confirmationTime: DateTime(2024, 1, 2, 3, 4),
  ),
  TxDetails(
    txid: 'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
    sent: 1600,
    received: 0,
    balanceDelta: -1600,
    pending: true,
  ),
];

class _FakeWalletService extends WalletService {
  final DemoWalletInfo walletInfo;
  final List<TxDetails> transactions;

  _FakeWalletService({required this.walletInfo, required this.transactions});

  @override
  Future<DemoWalletInfo> loadReferenceWallet() async => walletInfo;

  @override
  Future<List<TxDetails>> loadTransactions() async => transactions;
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required WalletService walletService,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [walletServiceProvider.overrideWithValue(walletService)],
      child: const MaterialApp(home: ActiveWalletsPage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows scaffold intro before loading', (tester) async {
    await _pumpPage(
      tester,
      walletService: _FakeWalletService(
        walletInfo: _testWalletInfo,
        transactions: _placeholderTransactions,
      ),
    );

    expect(find.text('Reference Wallet Scaffold'), findsNWidgets(2));
    expect(find.text('Load Reference Scaffold'), findsOneWidget);
    expect(find.text('Wallet not loaded yet'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Transactions will appear here'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Transactions will appear here'), findsOneWidget);
  });

  testWidgets('loads and renders placeholder transactions', (tester) async {
    await _pumpPage(
      tester,
      walletService: _FakeWalletService(
        walletInfo: _testWalletInfo,
        transactions: _placeholderTransactions,
      ),
    );

    await tester.tap(find.text('Load Reference Scaffold'));
    await tester.pumpAndSettle();

    expect(find.text('Wallet Snapshot'), findsOneWidget);
    expect(find.text('Testnet 3'), findsOneWidget);
    expect(find.text('Placeholder descriptor'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('confirmed'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('+42000 sat'), findsOneWidget);
    expect(find.text('-1600 sat'), findsOneWidget);
    expect(find.text('123456...abcd'), findsOneWidget);
    expect(find.text('abcdef...7890'), findsOneWidget);
    expect(find.text('confirmed'), findsOneWidget);
    expect(find.text('pending'), findsOneWidget);
  });

  testWidgets('shows empty transaction state when no rows are returned', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      walletService: _FakeWalletService(
        walletInfo: _testWalletInfo,
        transactions: const [],
      ),
    );

    await tester.tap(find.text('Load Reference Scaffold'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('No transactions yet'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(
      find.text(
        'The scaffold loaded successfully, but no placeholder transactions are configured yet.',
      ),
      findsOneWidget,
    );
  });
}
