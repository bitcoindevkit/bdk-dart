import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';
import 'package:bdk_demo/features/transactions/transaction_detail_page.dart';
import 'package:bdk_demo/features/transactions/transactions_list_page.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/fakes/fake_transactions_repository.dart';
import '../../helpers/fixtures/transaction_history_items.dart';

Future<void> _pumpTransactionsFlow(
  WidgetTester tester, {
  required TransactionsRepository repository,
  bool hasActiveWallet = true,
  ProviderContainer? container,
}) async {
  final router = GoRouter(
    initialLocation: '/transactions',
    routes: [
      GoRoute(
        path: '/transactions',
        name: 'transactionHistory',
        builder: (context, state) => const TransactionsListPage(),
      ),
      GoRoute(
        path: '/transactions/:txid',
        name: 'transactionDetail',
        builder: (context, state) =>
            TransactionDetailPage(txid: state.pathParameters['txid'] ?? ''),
      ),
    ],
  );

  if (container != null) {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  } else {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(repository),
          activeWalletIdProvider.overrideWithValue(
            hasActiveWallet ? 'wallet-a' : null,
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows intro before loading transaction history', (tester) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(
        transactions: transactionHistoryItems,
      ),
    );

    expect(find.text('Transaction History'), findsNWidgets(2));
    expect(find.text('Load Transaction History'), findsOneWidget);
    expect(find.text('Transaction history not loaded yet'), findsOneWidget);
  });

  testWidgets('loads and renders wallet transactions', (tester) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(
        transactions: transactionHistoryItems,
      ),
    );

    await tester.tap(find.text('Load Transaction History'));
    await tester.pumpAndSettle();

    expect(find.text('+42000 sat'), findsOneWidget);
    expect(find.text('-1600 sat'), findsOneWidget);
    expect(find.text('123456...abcd'), findsOneWidget);
    expect(find.text('abcdef...7890'), findsOneWidget);
    expect(find.text('confirmed'), findsOneWidget);
    expect(find.text('pending'), findsOneWidget);
  });

  testWidgets('shows empty state when no transactions are returned', (
    tester,
  ) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(transactions: const []),
    );

    await tester.tap(find.text('Load Transaction History'));
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(
      find.text(
        'The active wallet has no transactions yet. Sync the wallet or receive funds to populate history.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping a transaction opens the detail page', (tester) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(
        transactions: transactionHistoryItems,
      ),
    );

    await tester.tap(find.text('Load Transaction History'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('123456...abcd'));
    await tester.pumpAndSettle();

    expect(find.text('Transaction Detail'), findsOneWidget);
    expect(
      find.text(
        '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'no active wallet shows the no-wallet state and disables load button',
    (tester) async {
      await _pumpTransactionsFlow(
        tester,
        repository: FakeTransactionsRepository(transactions: const []),
        hasActiveWallet: false,
      );

      expect(find.text('No active wallet'), findsOneWidget);
      expect(
        find.text(
          'Create or load a wallet before viewing transaction history.',
        ),
        findsOneWidget,
      );

      // Verify button is disabled
      final buttonFinder = find.widgetWithText(
        FilledButton,
        'Load Transaction History',
      );
      expect(tester.widget<FilledButton>(buttonFinder).onPressed, isNull);
    },
  );

  testWidgets(
    'active wallet with no transactions still shows the normal empty-history state after loading',
    (tester) async {
      await _pumpTransactionsFlow(
        tester,
        repository: FakeTransactionsRepository(transactions: const []),
        hasActiveWallet: true,
      );

      expect(find.text('Transaction history not loaded yet'), findsOneWidget);

      await tester.tap(find.text('Load Transaction History'));
      await tester.pumpAndSettle();

      expect(find.text('No transactions yet'), findsOneWidget);
      expect(
        find.text(
          'The active wallet has no transactions yet. Sync the wallet or receive funds to populate history.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'switching logical active wallet ID from A to B clears A\'s transaction list and does not render A\'s transaction rows before loading B',
    (tester) async {
      late final ProviderContainer container;

      final recordA = WalletRecord(
        id: 'wallet-a',
        name: 'Wallet A',
        network: WalletNetwork.testnet,
        scriptType: ScriptType.p2wpkh,
      );

      final recordB = WalletRecord(
        id: 'wallet-b',
        name: 'Wallet B',
        network: WalletNetwork.testnet,
        scriptType: ScriptType.p2wpkh,
      );

      final txsA = [
        TransactionHistoryItem(
          txid: 'tx-a',
          sent: 0,
          received: 10000,
          pending: false,
          blockHeight: 100,
          confirmationTime: DateTime.now(),
        ),
      ];

      final txsB = [
        TransactionHistoryItem(
          txid: 'tx-b',
          sent: 0,
          received: 20000,
          pending: false,
          blockHeight: 101,
          confirmationTime: DateTime.now(),
        ),
      ];

      final dynamicRepository = FakeTransactionsRepository(
        transactions: const [],
      );

      container = ProviderContainer(
        overrides: [
          transactionsRepositoryProvider.overrideWith((ref) {
            final activeId = ref.watch(activeWalletIdProvider);
            return FakeTransactionsRepository(
              transactions: activeId == 'wallet-a' ? txsA : txsB,
            );
          }),
        ],
      );

      // Set initial wallet record to Wallet A
      container.read(activeWalletRecordProvider.notifier).set(recordA);

      // 1. Initial pump with wallet A active
      await _pumpTransactionsFlow(
        tester,
        repository: dynamicRepository,
        container: container,
      );

      expect(find.text('Transaction history not loaded yet'), findsOneWidget);

      // 2. Load wallet A transactions
      await tester.tap(find.text('Load Transaction History'));
      await tester.pumpAndSettle();

      // Verify A's transactions are rendered
      expect(find.text('+10000 sat'), findsOneWidget);
      expect(
        find.text('tx-a...short'),
        findsNothing,
      ); // Wait, shortTxid for 'tx-a' is 'tx-a' or whatever Formatters.abbreviateTxid returns.
      // Let's check how shortTxid abbreviates 'tx-a'. It probably returns 'tx-a' if it is short. Let's just find.textContaining('tx-a').
      expect(find.textContaining('tx-a'), findsOneWidget);

      // 3. Switch logical active wallet ID from A to B
      container.read(activeWalletRecordProvider.notifier).set(recordB);
      await tester.pumpAndSettle();

      // 4. Verify wallet A's transaction rows are cleared immediately and not rendered
      expect(find.text('+10000 sat'), findsNothing);
      expect(find.textContaining('tx-a'), findsNothing);
      expect(find.text('Transaction history not loaded yet'), findsOneWidget);

      // 5. Load wallet B transactions
      await tester.tap(find.text('Load Transaction History'));
      await tester.pumpAndSettle();

      // Verify B's transactions are rendered
      expect(find.text('+20000 sat'), findsOneWidget);
      expect(find.textContaining('tx-b'), findsOneWidget);
      expect(find.text('+10000 sat'), findsNothing);
    },
  );
}
