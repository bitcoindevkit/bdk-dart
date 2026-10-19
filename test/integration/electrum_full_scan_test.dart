@Tags(['integration', 'regtest'])
import 'dart:async';
import 'dart:io';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import '../test_constants.dart';
import 'integration_helpers.dart';
import 'regtest_funding_helper.dart';

Future<void> _deleteDirectoryWithRetry(Directory dir) async {
  for (var attempt = 0; attempt < 10; attempt++) {
    try {
      if (dir.existsSync()) await dir.delete(recursive: true);
      return;
    } on PathAccessException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  if (dir.existsSync()) await dir.delete(recursive: true);
}

String _createTempSqlitePath() {
  final tempDir = Directory.systemTemp.createTempSync(
    'bdk_dart_electrum_fullscan_',
  );
  addTearDown(() => _deleteDirectoryWithRetry(tempDir));
  return '${tempDir.path}/wallet.sqlite';
}

void main() {
  group('Electrum fullScan integration', () {
    test(
      'fund wallet and fullScan successfully',
      () async {
        final disposers = <Disposer>[];
        final sqlitePath = _createTempSqlitePath();

        try {
          final descriptor = buildBip84Descriptor(Network.regtest);
          addDisposer(disposers, descriptor.dispose);

          final changeDescriptor = buildBip84ChangeDescriptor(Network.regtest);
          addDisposer(disposers, changeDescriptor.dispose);

          final persister = Persister.newSqlite(path: sqlitePath);
          addDisposer(disposers, persister.dispose);

          final wallet = Wallet(
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            network: Network.regtest,
            persister: persister,
            lookahead: defaultLookahead,
          );
          addDisposer(disposers, wallet.dispose);

          final revealed = wallet.revealNextAddress(
            keychain: KeychainKind.external_,
          );
          addDisposer(disposers, revealed.address.dispose);
          wallet.persist(persister: persister);

          final client = buildElectrumClientFromEnv();
          addDisposer(disposers, client.dispose);

          final addressString = revealed.address.toString();
          printOnFailure('Funding Regtest address: $addressString');

          final txid = await broadcastRegtestAddress(
            addressString,
            amount: 1.0,
          );
          printOnFailure('Funding transaction ID: $txid');

          // Phase 1: Scan while the funding transaction is still unconfirmed.
          TxUnconfirmedWalletEvent? unconfirmedEvent;
          var unconfirmedPositionSeen = false;
          Object? lastUnconfirmedError;

          for (var attempt = 0; attempt < 15; attempt++) {
            try {
              final requestBuilder = wallet.startFullScan();
              addDisposer(disposers, requestBuilder.dispose);

              final request = requestBuilder.build();
              addDisposer(disposers, request.dispose);

              final update = client.fullScan(
                request: request,
                stopGap: 20,
                batchSize: 100,
                fetchPrevTxouts: true,
              );
              addDisposer(disposers, update.dispose);

              final events = wallet.applyUpdateEvents(update: update);

              for (final event
                  in events.whereType<TxUnconfirmedWalletEvent>()) {
                if (event.txid.toString() == txid) {
                  unconfirmedEvent = event;
                }
              }

              final details = wallet.txDetails(
                txid: Txid.fromString(hex: txid),
              );

              if (details != null &&
                  details.chainPosition is UnconfirmedChainPosition) {
                unconfirmedPositionSeen = true;
              }

              if (unconfirmedEvent != null && unconfirmedPositionSeen) {
                break;
              }
            } catch (error) {
              lastUnconfirmedError = error;
              printOnFailure(
                'Electrum unconfirmed scan attempt ${attempt + 1} failed: $error',
              );
            }

            if (attempt < 14) {
              await Future<void>.delayed(const Duration(seconds: 1));
            }
          }

          // Assert that the Dart API exposed the unconfirmed transaction state.
          expect(
            unconfirmedEvent,
            isNotNull,
            reason:
                'The funded transaction should produce a TxUnconfirmedWalletEvent. '
                'Last error: $lastUnconfirmedError',
          );

          final pendingEvent = unconfirmedEvent!;

          expect(pendingEvent.tx.computeTxid().toString(), equals(txid));
          expect(
            pendingEvent.oldBlockTime,
            isNull,
            reason: 'The transaction is first observed in the mempool.',
          );

          expect(
            unconfirmedPositionSeen,
            isTrue,
            reason:
                'The wallet should expose UnconfirmedChainPosition before mining.',
          );

          final pendingDetails = wallet.txDetails(
            txid: Txid.fromString(hex: txid),
          );

          expect(pendingDetails, isNotNull);
          expect(
            pendingDetails!.chainPosition,
            isA<UnconfirmedChainPosition>(),
          );

          // Phase 2: Confirm the transaction, then run the existing confirmed scan loop.
          await mineRegtestBlocks();

          var balance = wallet.balance().total;
          Object? lastError;
          TxConfirmedWalletEvent? confirmedEvent;

          for (var attempt = 0; attempt < 15; attempt++) {
            try {
              final requestBuilder = wallet.startFullScan();
              addDisposer(disposers, requestBuilder.dispose);

              final request = requestBuilder.build();
              addDisposer(disposers, request.dispose);

              final update = client.fullScan(
                request: request,
                stopGap: 20,
                batchSize: 100,
                fetchPrevTxouts: true,
              );
              addDisposer(disposers, update.dispose);

              final events = wallet.applyUpdateEvents(update: update);

              for (final event in events.whereType<TxConfirmedWalletEvent>()) {
                if (event.txid.toString() == txid) {
                  confirmedEvent = event;
                }
              }

              balance = wallet.balance().total;

              if (confirmedEvent != null && balance.toSat() > 0) {
                break;
              }
            } catch (error) {
              lastError = error;
              printOnFailure(
                'Electrum fullScan attempt ${attempt + 1} failed: $error',
              );
            }

            if (confirmedEvent == null && attempt < 14) {
              await Future<void>.delayed(const Duration(seconds: 1));
            }
          }

          wallet.persist(persister: persister);

          printOnFailure('Final Wallet Balance: ${balance.toSat()} sats');

          expect(
            balance.toSat(),
            greaterThan(0),
            reason:
                'Wallet should have a positive balance after funding. '
                'Last error: $lastError',
          );

          expect(
            confirmedEvent,
            isNotNull,
            reason:
                'The funded transaction should produce a confirmed wallet event.',
          );

          final event = confirmedEvent!;

          expect(event.tx.computeTxid().toString(), equals(txid));
          expect(event.blockTime.blockId.height, greaterThan(0));
          expect(event.blockTime.blockId.hash.toString(), isNotEmpty);
          expect(event.blockTime.confirmationTime, greaterThan(0));

          final details = wallet.txDetails(txid: Txid.fromString(hex: txid));

          expect(details, isNotNull);
          expect(details!.txid.toString(), equals(txid));
          expect(details.tx.computeTxid().toString(), equals(txid));
          expect(details.chainPosition, isA<ConfirmedChainPosition>());

          final position = details.chainPosition as ConfirmedChainPosition;

          expect(
            position.confirmationBlockTime.blockId.height,
            equals(event.blockTime.blockId.height),
          );
          expect(
            position.confirmationBlockTime.blockId.hash.toString(),
            equals(event.blockTime.blockId.hash.toString()),
          );
          expect(
            position.confirmationBlockTime.confirmationTime,
            equals(event.blockTime.confirmationTime),
          );
        } finally {
          disposeAll(disposers);
        }
      },
      skip: integrationSkipReason(requiredEnv: [electrumUrlEnv]),
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
