import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';
import 'package:bdk_demo/features/transactions/transaction_detail_page.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_transactions_repository.dart';
import '../../helpers/fixtures/transaction_history_items.dart';

Future<void> _pumpDetailPage(
  WidgetTester tester, {
  required TransactionsRepository repository,
  required String txid,
  ProviderContainer? container,
}) async {
  if (container != null) {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: TransactionDetailPage(
            key: const ValueKey('detail-page'),
            txid: txid,
          ),
        ),
      ),
    );
  } else {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(repository),
          activeWalletIdProvider.overrideWithValue('wallet-a'),
        ],
        child: MaterialApp(
          home: TransactionDetailPage(
            key: const ValueKey('detail-page'),
            txid: txid,
          ),
        ),
      ),
    );
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the correct tx info', (tester) async {
    await _pumpDetailPage(
      tester,
      repository: FakeTransactionsRepository(
        transactions: transactionHistoryItems,
      ),
      txid: transactionHistoryItems.first.txid,
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
      transactions: transactionHistoryItems,
    );

    await _pumpDetailPage(
      tester,
      repository: repository,
      txid: transactionHistoryItems.first.txid,
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
      txid: transactionHistoryItems.last.txid,
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

  testWidgets(
    'transaction detail from wallet A is not reused after switching to wallet B',
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

      final txA = TransactionHistoryItem(
        txid: 'tx-123',
        sent: 0,
        received: 10000,
        pending: false,
        blockHeight: 100,
        confirmationTime: DateTime.now(),
      );

      final txB = TransactionHistoryItem(
        txid: 'tx-123',
        sent: 0,
        received: 20000,
        pending: false,
        blockHeight: 101,
        confirmationTime: DateTime.now(),
      );

      final dynamicRepository = FakeTransactionsRepository(
        transactions: const [],
      );

      container = ProviderContainer(
        overrides: [
          transactionsRepositoryProvider.overrideWith((ref) {
            final activeId = ref.watch(activeWalletIdProvider);
            return FakeTransactionsRepository(
              transactions: activeId == 'wallet-a' ? [txA] : [txB],
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      // Set initial wallet record to Wallet A
      container.read(activeWalletRecordProvider.notifier).set(recordA);

      // 1. Pump with wallet A active
      await _pumpDetailPage(
        tester,
        repository: dynamicRepository,
        txid: 'tx-123',
        container: container,
      );

      // Verify wallet A's detail is rendered
      expect(find.text('+10000 sat'), findsNWidgets(2));
      expect(find.text('+20000 sat'), findsNothing);

      // 2. Switch logical active wallet ID to wallet B
      container.read(activeWalletRecordProvider.notifier).set(recordB);
      await tester.pump(); // Start rebuild

      // Verify it doesn't immediately reuse wallet A's detail
      expect(find.text('+10000 sat'), findsNothing);

      await tester.pumpAndSettle();

      // Verify wallet B's detail is rendered now
      expect(find.text('+20000 sat'), findsNWidgets(2));
      expect(find.text('+10000 sat'), findsNothing);
    },
  );
}
