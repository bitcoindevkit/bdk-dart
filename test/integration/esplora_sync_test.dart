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

String _createTempSqlitePath() {
  final tempDir = Directory.systemTemp.createTempSync(
    'bdk_dart_esplora_integration_',
  );
  addTearDown(() => _deleteDirectoryWithRetry(tempDir));
  return '${tempDir.path}/wallet.sqlite';
}

void main() {
  group('Esplora integration', () {
    test(
      'sync, apply update, persist, and reload wallet state',
      () {
        final disposers = <Disposer>[];
        final sqlitePath = _createTempSqlitePath();
        final esploraUrl = envOrThrow(esploraUrlEnv);
        printOnFailure('Esplora URL: $esploraUrl');
        printOnFailure('SQLite path: $sqlitePath');

        try {
          final descriptor = buildBip84Descriptor(Network.testnet);
          addDisposer(disposers, descriptor.dispose);

          final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
          addDisposer(disposers, changeDescriptor.dispose);

          final persister = Persister.newSqlite(sqlitePath);
          addDisposer(disposers, persister.dispose);

          final wallet = Wallet(
            descriptor,
            changeDescriptor,
            Network.testnet,
            persister,
            defaultLookahead,
          );
          addDisposer(disposers, wallet.dispose);

          final revealed = wallet.revealNextAddress(KeychainKind.external_);
          addDisposer(disposers, revealed.address.dispose);

          final persistedAddressReveal = wallet.persist(persister);
          printOnFailure(
            'Persisted after reveal address: $persistedAddressReveal',
          );

          final checkpointBeforeSync = wallet.latestCheckpoint();
          final checkpointBeforeHeight = checkpointBeforeSync.height;
          addDisposer(disposers, checkpointBeforeSync.hash.dispose);
          printOnFailure(
            'Checkpoint before sync height: $checkpointBeforeHeight',
          );

          final requestBuilder = wallet.startSyncWithRevealedSpks();
          addDisposer(disposers, requestBuilder.dispose);

          final request = requestBuilder.build();
          addDisposer(disposers, request.dispose);

          final client = buildEsploraClientFromEnv();
          addDisposer(disposers, client.dispose);

          final chainHeight = client.getHeight();
          printOnFailure('Esplora chain height: $chainHeight');
          expect(chainHeight, greaterThan(0));

          final update = client.sync_(request, 4);
          addDisposer(disposers, update.dispose);

          wallet.applyUpdate(update);
          final persistedAfterSync = wallet.persist(persister);
          printOnFailure('Persisted after sync: $persistedAfterSync');

          final checkpointAfterSync = wallet.latestCheckpoint();
          final checkpointAfterHeight = checkpointAfterSync.height;
          addDisposer(disposers, checkpointAfterSync.hash.dispose);
          printOnFailure(
            'Checkpoint after sync height: $checkpointAfterHeight',
          );

          expect(
            checkpointAfterHeight,
            greaterThanOrEqualTo(checkpointBeforeHeight),
          );
          expect(checkpointAfterHeight, greaterThan(0));

          final persistedExternalIndex = wallet.nextDerivationIndex(
            KeychainKind.external_,
          );
          printOnFailure(
            'Persisted external derivation index: $persistedExternalIndex',
          );

          final reloadedPersister = Persister.newSqlite(sqlitePath);
          addDisposer(disposers, reloadedPersister.dispose);

          final reloadedWallet = Wallet.load(
            descriptor,
            changeDescriptor,
            reloadedPersister,
            defaultLookahead,
          );
          addDisposer(disposers, reloadedWallet.dispose);

          final reloadedExternalIndex = reloadedWallet.nextDerivationIndex(
            KeychainKind.external_,
          );
          expect(reloadedExternalIndex, equals(persistedExternalIndex));

          final reloadedCheckpoint = reloadedWallet.latestCheckpoint();
          final reloadedCheckpointHeight = reloadedCheckpoint.height;
          addDisposer(disposers, reloadedCheckpoint.hash.dispose);
          printOnFailure(
            'Reloaded checkpoint height: $reloadedCheckpointHeight',
          );
          expect(
            reloadedCheckpointHeight,
            greaterThanOrEqualTo(checkpointBeforeHeight),
          );
        } finally {
          disposeAll(disposers);
        }
      },
      skip: integrationSkipReason(requiredEnv: [esploraUrlEnv]),
    );
  });
}
