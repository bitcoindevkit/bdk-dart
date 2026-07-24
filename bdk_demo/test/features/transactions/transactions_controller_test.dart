import 'dart:async';
import 'package:bdk_dart/bdk.dart' as bdk;
import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';
import 'package:bdk_demo/features/transactions/transactions_controller.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_transactions_repository.dart';

class FakeWallet extends Fake implements bdk.Wallet {
  @override
  void dispose() {}
}

class CountingTransactionsRepository implements TransactionsRepository {
  int loadCount = 0;
  List<TransactionHistoryItem> transactions;
  Object? error;

  CountingTransactionsRepository({required this.transactions, this.error});

  @override
  Future<List<TransactionHistoryItem>> loadTransactions() async {
    loadCount++;
    final currentError = error;
    if (currentError != null) throw currentError;
    return transactions;
  }

  @override
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid) async {
    if (error != null) throw error!;
    for (final tx in transactions) {
      if (tx.txid == txid) return tx;
    }
    return null;
  }
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

void main() {
  WalletRecord createRecord(String id, String name) {
    return WalletRecord(
      id: id,
      name: name,
      network: WalletNetwork.testnet,
      scriptType: ScriptType.p2wpkh,
    );
  }

  TransactionHistoryItem createTx(String txid, int received) {
    return TransactionHistoryItem(
      txid: txid,
      sent: 0,
      received: received,
      pending: false,
    );
  }

  ProviderContainer createContainer(List<Override> overrides) {
    final container = ProviderContainer(overrides: overrides);
    addTearDown(container.dispose);
    return container;
  }

  void keepControllerAlive(ProviderContainer container, String? walletId) {
    final subscription = container.listen(
      transactionsControllerProvider(walletId),
      (_, __) {},
    );
    addTearDown(subscription.close);
  }

  group('TransactionsController & transactionDetailsProvider', () {
    test('no active wallet returns the no-wallet state', () {
      final container = createContainer([]);
      keepControllerAlive(container, null);

      final state = container.read(transactionsControllerProvider(null));
      expect(state.status, TransactionsLoadState.noWallet);
      expect(state.transactions, isEmpty);
    });

    test('an active wallet can load its transaction history', () async {
      final txs = [createTx('tx-1', 5000)];
      final container = createContainer([
        transactionsRepositoryProvider.overrideWithValue(
          FakeTransactionsRepository(transactions: txs),
        ),
      ]);
      keepControllerAlive(container, 'wallet-a');

      await container
          .read(transactionsControllerProvider('wallet-a').notifier)
          .loadTransactions();

      final state = container.read(transactionsControllerProvider('wallet-a'));
      expect(state.status, TransactionsLoadState.success);
      expect(state.transactions, hasLength(1));
      expect(state.transactions.first.txid, 'tx-1');
    });

    test('successful loading clears an old error', () async {
      final repo = CountingTransactionsRepository(
        transactions: [createTx('tx-1', 5000)],
        error: Exception('Initial error'),
      );
      final container = createContainer([
        transactionsRepositoryProvider.overrideWithValue(repo),
      ]);
      keepControllerAlive(container, 'wallet-a');

      final notifier = container.read(
        transactionsControllerProvider('wallet-a').notifier,
      );

      await notifier.loadTransactions();
      var state = container.read(transactionsControllerProvider('wallet-a'));
      expect(state.status, TransactionsLoadState.error);
      expect(state.errorMessage, 'Initial error');

      repo.error = null;
      await notifier.loadTransactions();
      state = container.read(transactionsControllerProvider('wallet-a'));
      expect(state.status, TransactionsLoadState.success);
      expect(state.errorMessage, isNull);
    });

    test('foreground failure produces the error state', () async {
      final repo = CountingTransactionsRepository(
        transactions: [],
        error: Exception('Network failure'),
      );
      final container = createContainer([
        transactionsRepositoryProvider.overrideWithValue(repo),
      ]);
      keepControllerAlive(container, 'wallet-a');

      await container
          .read(transactionsControllerProvider('wallet-a').notifier)
          .loadTransactions();

      final state = container.read(transactionsControllerProvider('wallet-a'));
      expect(state.status, TransactionsLoadState.error);
      expect(state.transactions, isEmpty);
      expect(state.errorMessage, 'Network failure');
    });

    test('background-refresh failure preserves existing rows', () async {
      final repo = CountingTransactionsRepository(
        transactions: [createTx('tx-1', 5000)],
      );
      final container = createContainer([
        transactionsRepositoryProvider.overrideWithValue(repo),
      ]);
      keepControllerAlive(container, 'wallet-a');

      final notifier = container.read(
        transactionsControllerProvider('wallet-a').notifier,
      );
      await notifier.loadTransactions();

      var state = container.read(transactionsControllerProvider('wallet-a'));
      expect(state.status, TransactionsLoadState.success);
      expect(state.transactions, hasLength(1));

      repo.error = Exception('Refresh failed');
      await notifier.loadTransactions(isBackgroundRefresh: true);

      state = container.read(transactionsControllerProvider('wallet-a'));
      expect(state.status, TransactionsLoadState.success);
      expect(state.transactions, hasLength(1));
      expect(state.transactions.first.txid, 'tx-1');
      expect(state.errorMessage, 'Refresh failed');
    });

    test(
      'duplicate concurrent load calls do not execute duplicate repository requests',
      () async {
        final repo = CountingTransactionsRepository(transactions: []);

        final container = createContainer([
          transactionsRepositoryProvider.overrideWith((ref) => repo),
        ]);
        keepControllerAlive(container, 'wallet-a');

        final notifier = container.read(
          transactionsControllerProvider('wallet-a').notifier,
        );

        final load1 = notifier.loadTransactions();
        final load2 = notifier.loadTransactions();

        await Future.wait([load1, load2]);
        expect(repo.loadCount, 1);
      },
    );

    test(
      'switching the logical active wallet ID from A to B clears A\'s transaction list',
      () async {
        final recordA = createRecord('wallet-a', 'Wallet A');
        final recordB = createRecord('wallet-b', 'Wallet B');

        final txsA = [createTx('tx-a', 10000)];
        final txsB = [createTx('tx-b', 20000)];

        final container = createContainer([
          transactionsRepositoryProvider.overrideWith((ref) {
            final activeId = ref.watch(activeWalletIdProvider);
            return FakeTransactionsRepository(
              transactions: activeId == 'wallet-a' ? txsA : txsB,
            );
          }),
        ]);

        container.read(activeWalletRecordProvider.notifier).set(recordA);
        final walletAId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletAId);

        await container
            .read(transactionsControllerProvider(walletAId).notifier)
            .loadTransactions();
        expect(
          container.read(transactionsControllerProvider(walletAId)).status,
          TransactionsLoadState.success,
        );
        expect(
          container
              .read(transactionsControllerProvider(walletAId))
              .transactions
              .first
              .txid,
          'tx-a',
        );

        container.read(activeWalletRecordProvider.notifier).set(recordB);
        final walletBId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletBId);

        final stateAfterSwitch = container.read(
          transactionsControllerProvider(walletBId),
        );
        expect(stateAfterSwitch.transactions, isEmpty);
      },
    );

    test(
      'an asynchronous result started for wallet A is ignored if the active wallet changes to B before it completes',
      () async {
        final recordA = createRecord('wallet-a', 'Wallet A');
        final recordB = createRecord('wallet-b', 'Wallet B');

        final completer = Completer<List<TransactionHistoryItem>>();
        final delayedRepo = DelayedTransactionsRepository(completer.future);

        final container = createContainer([
          transactionsRepositoryProvider.overrideWithValue(delayedRepo),
        ]);

        container.read(activeWalletRecordProvider.notifier).set(recordA);
        final walletAId = container.read(activeWalletIdProvider);
        final walletASubscription = container.listen(
          transactionsControllerProvider(walletAId),
          (_, __) {},
        );

        final future = container
            .read(transactionsControllerProvider(walletAId).notifier)
            .loadTransactions();

        container.read(activeWalletRecordProvider.notifier).set(recordB);
        final walletBId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletBId);
        walletASubscription.close();
        await container.pump();

        completer.complete([createTx('tx-a', 10000)]);
        await future;

        final finalState = container.read(
          transactionsControllerProvider(walletBId),
        );
        expect(finalState.transactions, isEmpty);
      },
    );

    test(
      'replacing the FFI Wallet object while retaining the same wallet record ID refreshes data',
      () async {
        final recordA = createRecord('wallet-a', 'Wallet A');

        final wallet1 = FakeWallet();
        final wallet2 = FakeWallet();

        final repo = CountingTransactionsRepository(
          transactions: [createTx('tx-a', 10000)],
        );

        final container = createContainer([
          transactionsRepositoryProvider.overrideWithValue(repo),
        ]);

        container.read(activeWalletRecordProvider.notifier).set(recordA);
        final walletAId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletAId);

        await container
            .read(transactionsControllerProvider(walletAId).notifier)
            .loadTransactions();
        final initialLoadCount = repo.loadCount;

        container.read(activeWalletProvider.notifier).set(wallet1);
        await container
            .read(transactionsControllerProvider(walletAId).notifier)
            .loadTransactions(isBackgroundRefresh: true);

        expect(repo.loadCount, greaterThan(initialLoadCount));
      },
    );

    test(
      'a transaction detail from wallet A is not reused after switching to wallet B',
      () async {
        final recordA = createRecord('wallet-a', 'Wallet A');
        final recordB = createRecord('wallet-b', 'Wallet B');

        final txA = createTx('tx-123', 10000);
        final txB = createTx('tx-123', 20000);

        final container = createContainer([
          transactionsRepositoryProvider.overrideWith((ref) {
            final activeId = ref.watch(activeWalletIdProvider);
            return FakeTransactionsRepository(
              transactions: activeId == 'wallet-a' ? [txA] : [txB],
            );
          }),
        ]);

        container.read(activeWalletRecordProvider.notifier).set(recordA);

        final detailA = await container.read(
          transactionDetailsProvider((
            walletId: 'wallet-a',
            txid: 'tx-123',
          )).future,
        );
        expect(detailA?.netAmount, 10000);

        container.read(activeWalletRecordProvider.notifier).set(recordB);

        final detailB = await container.read(
          transactionDetailsProvider((
            walletId: 'wallet-b',
            txid: 'tx-123',
          )).future,
        );
        expect(detailB?.netAmount, 20000);
      },
    );
  });
}
