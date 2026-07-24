import 'dart:async';
import 'package:bdk_dart/bdk.dart' as bdk;
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

class FakeWallet extends Fake implements bdk.Wallet {
  @override
  void dispose() {}
}

class DelayedTransactionsRepository implements TransactionsRepository {
  final Future<List<TransactionHistoryItem>> delayedResult;

  DelayedTransactionsRepository(this.delayedResult);

  @override
  Future<List<TransactionHistoryItem>> loadTransactions() async {
    return delayedResult;
  }

  @override
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid) async {
    final list = await delayedResult;
    for (final tx in list) {
      if (tx.txid == txid) return tx;
    }
    return null;
  }
}

class MutableTransactionsRepository implements TransactionsRepository {
  List<TransactionHistoryItem> transactions;

  MutableTransactionsRepository(this.transactions);

  @override
  Future<List<TransactionHistoryItem>> loadTransactions() async {
    return transactions;
  }

  @override
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid) async {
    for (final tx in transactions) {
      if (tx.txid == txid) return tx;
    }
    return null;
  }
}

Future<void> _pumpTransactionsFlow(
  WidgetTester tester, {
  required TransactionsRepository repository,
  bool hasActiveWallet = true,
  ProviderContainer? container,
  bool settle = true,
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
      GoRoute(
        path: '/other',
        name: 'other',
        builder: (context, state) => const Scaffold(body: Text('Other Page')),
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
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

void main() {
  testWidgets('automatically loads and renders wallet transactions', (
    tester,
  ) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(
        transactions: transactionHistoryItems,
      ),
    );

    expect(find.text('+42000 sat'), findsOneWidget);
    expect(find.text('-1600 sat'), findsOneWidget);
    expect(find.text('123456...abcd'), findsOneWidget);
    expect(find.text('abcdef...7890'), findsOneWidget);
    expect(find.text('confirmed'), findsOneWidget);
    expect(find.text('pending'), findsOneWidget);
  });

  testWidgets(
    'seamlessly preserves/refreshes state on navigation away and back',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/transactions',
        routes: [
          GoRoute(
            path: '/transactions',
            name: 'transactionHistory',
            builder: (context, state) => const TransactionsListPage(),
          ),
          GoRoute(
            path: '/other',
            name: 'other',
            builder: (context, state) =>
                const Scaffold(body: Text('Other Page')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionsRepositoryProvider.overrideWithValue(
              FakeTransactionsRepository(transactions: transactionHistoryItems),
            ),
            activeWalletIdProvider.overrideWithValue('wallet-a'),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify initially loaded
      expect(find.text('+42000 sat'), findsOneWidget);

      // 2. Navigate away
      router.go('/other');
      await tester.pumpAndSettle();
      expect(find.text('+42000 sat'), findsNothing);
      expect(find.text('Other Page'), findsOneWidget);

      // 3. Navigate back
      router.go('/transactions');
      await tester.pumpAndSettle();

      // 4. Verify automatically loaded again (no reload tap required)
      expect(find.text('+42000 sat'), findsOneWidget);
    },
  );

  testWidgets('shows empty state when no transactions are returned', (
    tester,
  ) async {
    await _pumpTransactionsFlow(
      tester,
      repository: FakeTransactionsRepository(transactions: const []),
    );

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

      final buttonFinder = find.widgetWithText(
        FilledButton,
        'Load Transaction History',
      );
      expect(tester.widget<FilledButton>(buttonFinder).onPressed, isNull);
    },
  );

  testWidgets(
    'switching logical active wallet ID from A to B clears A\'s transaction list and loads B\'s automatically',
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
      addTearDown(container.dispose);

      container.read(activeWalletRecordProvider.notifier).set(recordA);

      await _pumpTransactionsFlow(
        tester,
        repository: FakeTransactionsRepository(transactions: const []),
        container: container,
      );

      // Verify A's transactions are rendered
      expect(find.text('+10000 sat'), findsOneWidget);
      expect(find.textContaining('tx-a'), findsOneWidget);

      // Switch logical active wallet ID from A to B
      container.read(activeWalletRecordProvider.notifier).set(recordB);
      await tester.pumpAndSettle();

      // Verify A's rows are gone, and B's rows loaded automatically without build-time exceptions
      expect(find.text('+10000 sat'), findsNothing);
      expect(find.textContaining('tx-a'), findsNothing);
      expect(find.text('+20000 sat'), findsOneWidget);
      expect(find.textContaining('tx-b'), findsOneWidget);
    },
  );

  testWidgets(
    'pending transaction updates to confirmed automatically after wallet sync without manual reload',
    (tester) async {
      late final ProviderContainer container;

      final record = WalletRecord(
        id: 'wallet-a',
        name: 'Wallet A',
        network: WalletNetwork.testnet,
        scriptType: ScriptType.p2wpkh,
      );

      final txPending = TransactionHistoryItem(
        txid: 'tx-1',
        sent: 0,
        received: 10000,
        pending: true,
        blockHeight: null,
        confirmationTime: null,
      );

      final txConfirmed = TransactionHistoryItem(
        txid: 'tx-1',
        sent: 0,
        received: 10000,
        pending: false,
        blockHeight: 200,
        confirmationTime: DateTime.now(),
      );

      final repo = MutableTransactionsRepository([txPending]);

      container = ProviderContainer(
        overrides: [transactionsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      container.read(activeWalletRecordProvider.notifier).set(record);
      final walletA = FakeWallet();
      container.read(activeWalletProvider.notifier).set(walletA);

      await _pumpTransactionsFlow(
        tester,
        repository: FakeTransactionsRepository(transactions: const []),
        container: container,
      );

      // Confirm UI displays: Awaiting confirmation
      expect(find.text('Awaiting confirmation'), findsOneWidget);
      expect(find.text('Block 200'), findsNothing);

      // Simulate a successful wallet sync (replace wallet instance and update mock data)
      repo.transactions = [txConfirmed];
      final walletB = FakeWallet();
      container.read(activeWalletProvider.notifier).set(walletB);

      await tester.pumpAndSettle();

      // Confirm Awaiting confirmation is gone, and confirmed state shows block height
      expect(find.text('Awaiting confirmation'), findsNothing);
      expect(find.text('Block 200'), findsOneWidget);
    },
  );

  testWidgets(
    'stale async results from previous wallet A do not overwrite wallet B state',
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

      final completerA = Completer<List<TransactionHistoryItem>>();
      final completerB = Completer<List<TransactionHistoryItem>>();

      container = ProviderContainer(
        overrides: [
          transactionsRepositoryProvider.overrideWith((ref) {
            final activeId = ref.watch(activeWalletIdProvider);
            if (activeId == 'wallet-a') {
              return DelayedTransactionsRepository(completerA.future);
            } else {
              return DelayedTransactionsRepository(completerB.future);
            }
          }),
        ],
      );
      addTearDown(container.dispose);

      container.read(activeWalletRecordProvider.notifier).set(recordA);

      await _pumpTransactionsFlow(
        tester,
        repository: FakeTransactionsRepository(transactions: const []),
        container: container,
        settle: false,
      );

      // Verify wallet A is loading
      expect(find.text('Loading transaction history...'), findsOneWidget);

      // Switch active wallet to B
      container.read(activeWalletRecordProvider.notifier).set(recordB);
      await tester.pump();

      // Complete A's future
      completerA.complete([
        TransactionHistoryItem(
          txid: 'tx-a',
          sent: 0,
          received: 10000,
          pending: false,
        ),
      ]);
      await tester.pump();

      // Wallet B's state shouldn't render A's transaction
      expect(find.text('+10000 sat'), findsNothing);
    },
  );
}
