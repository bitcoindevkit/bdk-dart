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

      // Initially idle
      expect(
        container.read(transactionsControllerProvider('wallet-a')).status,
        TransactionsLoadState.idle,
      );

      // Load transactions
      await container
          .read(transactionsControllerProvider('wallet-a').notifier)
          .loadTransactions();

      final state = container.read(transactionsControllerProvider('wallet-a'));
      expect(state.status, TransactionsLoadState.success);
      expect(state.transactions, hasLength(1));
      expect(state.transactions.first.txid, 'tx-1');
    });

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

        // Set initial wallet record to Wallet A
        container.read(activeWalletRecordProvider.notifier).set(recordA);
        final walletAId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletAId);

        // Load Wallet A transactions
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

        // Switch active wallet to Wallet B
        container.read(activeWalletRecordProvider.notifier).set(recordB);
        final walletBId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletBId);

        // Verify that Wallet A's transaction state is cleared and we are back to idle
        final stateAfterSwitch = container.read(
          transactionsControllerProvider(walletBId),
        );
        expect(stateAfterSwitch.status, TransactionsLoadState.idle);
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

        // Set initial wallet record to Wallet A
        container.read(activeWalletRecordProvider.notifier).set(recordA);
        final walletAId = container.read(activeWalletIdProvider);
        final walletASubscription = container.listen(
          transactionsControllerProvider(walletAId),
          (_, __) {},
        );

        // Start loading
        final future = container
            .read(transactionsControllerProvider(walletAId).notifier)
            .loadTransactions();

        // State is loading
        expect(
          container.read(transactionsControllerProvider(walletAId)).status,
          TransactionsLoadState.loading,
        );

        // Switch active wallet to Wallet B and begin observing B's isolated state.
        container.read(activeWalletRecordProvider.notifier).set(recordB);
        final walletBId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletBId);
        walletASubscription.close();
        await container.pump();

        expect(
          container.read(transactionsControllerProvider(walletBId)).status,
          TransactionsLoadState.idle,
        );

        // Complete async request for Wallet A
        completer.complete([createTx('tx-a', 10000)]);

        await future;

        // State must remain idle for Wallet B
        final finalState = container.read(
          transactionsControllerProvider(walletBId),
        );
        expect(finalState.status, TransactionsLoadState.idle);
        expect(finalState.transactions, isEmpty);
      },
    );

    test(
      'replacing the FFI Wallet object while retaining the same wallet record ID does not reset state',
      () async {
        final recordA = createRecord('wallet-a', 'Wallet A');

        final wallet1 = FakeWallet();
        final wallet2 = FakeWallet();

        final container = createContainer([
          transactionsRepositoryProvider.overrideWith((ref) {
            ref.watch(activeWalletProvider);
            return FakeTransactionsRepository(
              transactions: [createTx('tx-a', 10000)],
            );
          }),
        ]);

        // Set initial wallet record and FFI Wallet instance
        container.read(activeWalletRecordProvider.notifier).set(recordA);
        container.read(activeWalletProvider.notifier).set(wallet1);
        final walletAId = container.read(activeWalletIdProvider);
        keepControllerAlive(container, walletAId);

        // Load transactions
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
              .transactions,
          isNotEmpty,
        );

        // Replace the wallet object instance (same logical ID)
        container.read(activeWalletProvider.notifier).set(wallet2);

        // State must not reset
        expect(
          container.read(transactionsControllerProvider(walletAId)).status,
          TransactionsLoadState.success,
        );
        expect(
          container
              .read(transactionsControllerProvider(walletAId))
              .transactions,
          isNotEmpty,
        );
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

        // Set initial wallet record to Wallet A
        container.read(activeWalletRecordProvider.notifier).set(recordA);

        // 1. Read detail for key (walletId: 'wallet-a', txid: 'tx-123')
        final detailA = await container.read(
          transactionDetailsProvider((
            walletId: 'wallet-a',
            txid: 'tx-123',
          )).future,
        );
        expect(detailA?.netAmount, 10000);

        // 2. Switch wallet to B
        container.read(activeWalletRecordProvider.notifier).set(recordB);

        // 3. Read the same txid through wallet B's isolated cache key.
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
