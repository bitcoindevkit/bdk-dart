import 'package:bdk_demo/features/transactions/transaction_detail_page.dart';
import 'package:bdk_demo/features/transactions/transactions_list_page.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/fakes/fake_transactions_repository.dart';
import '../../helpers/fixtures/placeholder_transactions.dart';

Future<void> _pumpTransactionsFlow(
  WidgetTester tester, {
  required TransactionsRepository repository,
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
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows intro before loading transactions', (tester) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(
        transactions: placeholderTransactions,
      ),
    );

    expect(find.text('Transactions Demo'), findsNWidgets(2));
    expect(find.text('Load Transactions Demo'), findsOneWidget);
    expect(find.text('Transactions not loaded yet'), findsOneWidget);
  });

  testWidgets('loads and renders placeholder transactions', (tester) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(
        transactions: placeholderTransactions,
      ),
    );

    await tester.tap(find.text('Load Transactions Demo'));
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

    await tester.tap(find.text('Load Transactions Demo'));
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(
      find.text(
        'The transaction demo loaded successfully, but no placeholder transactions are configured yet.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping a transaction opens the detail page', (tester) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(
        transactions: placeholderTransactions,
      ),
    );

    await tester.tap(find.text('Load Transactions Demo'));
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
}
