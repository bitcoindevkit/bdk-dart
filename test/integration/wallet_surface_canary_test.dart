// @Tags(['integration'])

import 'dart:async';
import 'dart:io';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import '../test_constants.dart';
import 'integration_helpers.dart';

Future<void> _deleteDirectoryWithRetry(Directory dir) async {
  for (var attempt = 0; attempt < 10; attempt++) {
    try {
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
      return;
    } on PathAccessException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  if (dir.existsSync()) {
    await dir.delete(recursive: true);
  }
}

String _createTempSqlitePath(String prefix) {
  final tempDir = Directory.systemTemp.createTempSync(prefix);
  addTearDown(() => _deleteDirectoryWithRetry(tempDir));
  return '${tempDir.path}/wallet.sqlite';
}

void _exerciseWalletEventSurface(List<WalletEvent> events) {
  for (final event in events) {
    if (event is ChainTipChangedWalletEvent) {
      event.oldTip.height;
      event.newTip.height;
      event.oldTip.hash.toString();
      event.newTip.hash.toString();
    } else if (event is TxConfirmedWalletEvent) {
      expect(event.tx.computeTxid().toString(), equals(event.txid.toString()));
      event.blockTime.confirmationTime;
      event.oldBlockTime?.confirmationTime;
    } else if (event is TxUnconfirmedWalletEvent) {
      expect(event.tx.computeTxid().toString(), equals(event.txid.toString()));
      event.oldBlockTime?.confirmationTime;
    } else if (event is TxReplacedWalletEvent) {
      expect(event.tx.computeTxid().toString(), equals(event.txid.toString()));
      for (final conflict in event.conflicts) {
        conflict.vin;
        conflict.txid.toString();
      }
    } else if (event is TxDroppedWalletEvent) {
      expect(event.tx.computeTxid().toString(), equals(event.txid.toString()));
    } else {
      fail('Unhandled wallet event variant: ${event.runtimeType}');
    }
  }
}

void _exerciseWalletReadSurface(Wallet wallet) {
  final checkpoint = wallet.latestCheckpoint();
  expect(checkpoint.height, greaterThanOrEqualTo(0));
  checkpoint.hash.toString();

  final balance = wallet.balance();
  expect(balance.total.toSat(), greaterThanOrEqualTo(0));

  final network = wallet.network();
  expect(network, isNotNull);

  final nextExternalIndex = wallet.nextDerivationIndex(
    keychain: KeychainKind.external_,
  );
  expect(nextExternalIndex, greaterThanOrEqualTo(0));

  final peeked = wallet.peekAddress(
    keychain: KeychainKind.external_,
    index: nextExternalIndex,
  );
  expect(peeked.index, equals(nextExternalIndex));
  expect(peeked.address.scriptPubkey().toBytes(), isNotEmpty);

  final nextUnused = wallet.nextUnusedAddress(keychain: KeychainKind.external_);
  expect(nextUnused.address.scriptPubkey().toBytes(), isNotEmpty);

  final unusedAddresses = wallet.listUnusedAddresses(
    keychain: KeychainKind.external_,
  );
  for (final info in unusedAddresses.take(3)) {
    expect(info.address.scriptPubkey().toBytes(), isNotEmpty);
  }

  final outputs = wallet.listOutput();
  final unspent = wallet.listUnspent();
  expect(outputs.length, greaterThanOrEqualTo(unspent.length));

  final txs = wallet.transactions();
  for (final tx in txs.take(30)) {
    final txid = tx.transaction.computeTxid();
    final canonical = wallet.getTx(txid: txid);
    if (canonical != null) {
      expect(canonical.transaction.computeTxid().toString(), txid.toString());
    }

    final details = wallet.txDetails(txid: txid);
    if (details != null) {
      expect(details.txid.toString(), equals(txid.toString()));
      expect(details.tx.computeTxid().toString(), equals(txid.toString()));
    }
  }
}

void main() {
  group('Workflow surface canary', () {
    test(
      'electrum sync path exercises broad wallet surface',
      () {
        final disposers = <Disposer>[];
        final sqlitePath = _createTempSqlitePath(
          'bdk_dart_surface_canary_electrum_',
        );

        try {
          final descriptor = buildBip84Descriptor(Network.testnet);
          addDisposer(disposers, descriptor.dispose);

          final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
          addDisposer(disposers, changeDescriptor.dispose);

          final persister = Persister.newSqlite(path: sqlitePath);
          addDisposer(disposers, persister.dispose);

          final wallet = Wallet(
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            network: Network.testnet,
            persister: persister,
            lookahead: defaultLookahead,
          );
          addDisposer(disposers, wallet.dispose);

          wallet.revealNextAddress(keychain: KeychainKind.external_);
          wallet.persist(persister: persister);
          final checkpointBeforeSync = wallet.latestCheckpoint().height;

          final requestBuilder = wallet.startSyncWithRevealedSpks();
          addDisposer(disposers, requestBuilder.dispose);
          final request = requestBuilder.build();
          addDisposer(disposers, request.dispose);

          final client = buildElectrumClientFromEnv();
          addDisposer(disposers, client.dispose);
          client.ping();

          final update = client.sync_(
            request: request,
            batchSize: 100,
            fetchPrevTxouts: true,
          );
          addDisposer(disposers, update.dispose);

          final events = wallet.applyUpdateEvents(update: update);
          _exerciseWalletEventSurface(events);
          _exerciseWalletReadSurface(wallet);

          wallet.persist(persister: persister);
          final txCountBeforeReload = wallet.transactions().length;

          final reloadedPersister = Persister.newSqlite(path: sqlitePath);
          addDisposer(disposers, reloadedPersister.dispose);
          final reloadedWallet = Wallet.load(
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            persister: reloadedPersister,
            lookahead: defaultLookahead,
          );
          addDisposer(disposers, reloadedWallet.dispose);

          expect(
            reloadedWallet.latestCheckpoint().height,
            greaterThanOrEqualTo(checkpointBeforeSync),
          );
          _exerciseWalletReadSurface(reloadedWallet);
          expect(
            reloadedWallet.transactions().length,
            equals(txCountBeforeReload),
          );
        } finally {
          disposeAll(disposers);
        }
      },
      skip: integrationSkipReason(requiredEnv: [electrumUrlEnv]),
    );

    test(
      'esplora sync path exercises broad wallet surface',
      () {
        final disposers = <Disposer>[];
        final sqlitePath = _createTempSqlitePath(
          'bdk_dart_surface_canary_esplora_',
        );

        try {
          final descriptor = buildBip84Descriptor(Network.testnet);
          addDisposer(disposers, descriptor.dispose);

          final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
          addDisposer(disposers, changeDescriptor.dispose);

          final persister = Persister.newSqlite(path: sqlitePath);
          addDisposer(disposers, persister.dispose);

          final wallet = Wallet(
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            network: Network.testnet,
            persister: persister,
            lookahead: defaultLookahead,
          );
          addDisposer(disposers, wallet.dispose);

          wallet.revealNextAddress(keychain: KeychainKind.external_);
          wallet.persist(persister: persister);
          final checkpointBeforeSync = wallet.latestCheckpoint().height;

          final requestBuilder = wallet.startSyncWithRevealedSpks();
          addDisposer(disposers, requestBuilder.dispose);
          final request = requestBuilder.build();
          addDisposer(disposers, request.dispose);

          final client = buildEsploraClientFromEnv();
          addDisposer(disposers, client.dispose);
          expect(client.getHeight(), greaterThan(0));

          final update = client.sync_(request: request, parallelRequests: 4);
          addDisposer(disposers, update.dispose);

          final events = wallet.applyUpdateEvents(update: update);
          _exerciseWalletEventSurface(events);
          _exerciseWalletReadSurface(wallet);

          wallet.persist(persister: persister);
          final txCountBeforeReload = wallet.transactions().length;

          final reloadedPersister = Persister.newSqlite(path: sqlitePath);
          addDisposer(disposers, reloadedPersister.dispose);
          final reloadedWallet = Wallet.load(
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            persister: reloadedPersister,
            lookahead: defaultLookahead,
          );
          addDisposer(disposers, reloadedWallet.dispose);

          expect(
            reloadedWallet.latestCheckpoint().height,
            greaterThanOrEqualTo(checkpointBeforeSync),
          );
          _exerciseWalletReadSurface(reloadedWallet);
          expect(
            reloadedWallet.transactions().length,
            equals(txCountBeforeReload),
          );
        } finally {
          disposeAll(disposers);
        }
      },
      skip: integrationSkipReason(requiredEnv: [esploraUrlEnv]),
    );
  });
}
