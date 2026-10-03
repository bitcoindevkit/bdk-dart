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
    'bdk_dart_esplora_fullscan_',
  );
  addTearDown(() => _deleteDirectoryWithRetry(tempDir));
  return '${tempDir.path}/wallet.sqlite';
}

void main() {
  group('Esplora fullScan integration', () {
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

          final client = buildEsploraClientFromEnv();
          // note: esplora client doesn't need explicit dispose

          final addressString = revealed.address.toString();
          printOnFailure('Funding Regtest address: $addressString');

          final txid = await fundRegtestAddress(addressString, amount: 1.0);
          printOnFailure('Funding transaction ID: $txid');

          // Deterministic wait: Poll Esplora for the transaction
          Object? lastError;
          var txFound = false;

          for (var attempt = 0; attempt < 15; attempt++) {
            try {
              final tx = client.getTx(txid: Txid.fromString(hex: txid));
              if (tx != null) {
                txFound = true;
                break;
              }
            } catch (error) {
              lastError = error;
              printOnFailure(
                'Esplora getTx attempt ${attempt + 1} failed: $error',
              );
            }

            if (!txFound && attempt < 14) {
              await Future<void>.delayed(const Duration(seconds: 1));
            }
          }

          expect(
            txFound,
            isTrue,
            reason:
                'Esplora should index the funding transaction within the timeout. '
                'Last error: $lastError',
          );

          // Now perform the single fullScan since we know it's indexed
          final requestBuilder = wallet.startFullScan();
          addDisposer(disposers, requestBuilder.dispose);

          final request = requestBuilder.build();
          addDisposer(disposers, request.dispose);

          final update = client.fullScan(
            request: request,
            stopGap: 20,
            parallelRequests: 1,
          );
          addDisposer(disposers, update.dispose);

          wallet.applyUpdate(update: update);
          final balance = wallet.balance().total;

          wallet.persist(persister: persister);

          printOnFailure('Final Wallet Balance: ${balance.toSat()} sats');

          expect(
            balance.toSat(),
            greaterThan(0),
            reason: 'Wallet should have a positive balance after funding',
          );
        } finally {
          disposeAll(disposers);
        }
      },
      skip: integrationSkipReason(requiredEnv: [esploraUrlEnv]),
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
