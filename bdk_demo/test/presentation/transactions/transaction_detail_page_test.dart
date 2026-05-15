import 'package:bdk_demo/features/transactions/transaction_detail_page.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_transactions_repository.dart';
import '../../helpers/fixtures/placeholder_transactions.dart';

Future<void> _pumpDetailPage(
  WidgetTester tester, {
  required TransactionsRepository repository,
  required String txid,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        home: TransactionDetailPage(
          key: const ValueKey('detail-page'),
          txid: txid,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the correct tx info', (tester) async {
    await _pumpDetailPage(
      tester,
      repository: FakeTransactionsRepository(
        transactions: placeholderTransactions,
      ),
      txid: placeholderTransactions.first.txid,
    );

    expect(find.text('Transaction Detail'), findsOneWidget);
    expect(
      find.text(
        '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      ),
      findsOneWidget,
    );
    expect(find.text('+42000 sat'), findsNWidgets(2));
    expect(find.text('confirmed'), findsNWidgets(2));
    expect(find.text('120'), findsOneWidget);
    expect(find.text('January 2 2024 03:04'), findsOneWidget);
  });

  testWidgets('updates when the txid changes', (tester) async {
    final repository = FakeTransactionsRepository(
      transactions: placeholderTransactions,
    );

    await _pumpDetailPage(
      tester,
      repository: repository,
      txid: placeholderTransactions.first.txid,
    );

    expect(
      find.text(
        '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      ),
      findsOneWidget,
    );
    expect(find.text('January 2 2024 03:04'), findsOneWidget);

    await _pumpDetailPage(
      tester,
      repository: repository,
      txid: placeholderTransactions.last.txid,
    );

    expect(
      find.text(
        'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
      ),
      findsOneWidget,
    );
    expect(find.text('-1600 sat'), findsNWidgets(2));
    expect(find.text('pending'), findsNWidgets(2));
    expect(
      find.text(
        '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      ),
      findsNothing,
    );
    expect(find.text('January 2 2024 03:04'), findsNothing);
  });

  testWidgets('handles a missing tx gracefully', (tester) async {
    await _pumpDetailPage(
      tester,
      repository: FakeTransactionsRepository(transactions: const []),
      txid: 'missing-txid',
    );

    expect(find.text('Transaction not found'), findsOneWidget);
    expect(find.textContaining('missing-txid'), findsOneWidget);
  });
}
