import 'package:bdk_demo/features/transactions/transaction_detail_page.dart';
import 'package:bdk_demo/features/transactions/transactions_list_page.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
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

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transactionsRepositoryProvider.overrideWithValue(repository),
        hasActiveWalletProvider.overrideWithValue(hasActiveWallet),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
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
}
