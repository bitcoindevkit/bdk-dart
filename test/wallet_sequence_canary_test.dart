import 'dart:io';
import 'dart:math';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

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
    'bdk_dart_sequence_canary_',
  );
  addTearDown(() => _deleteDirectoryWithRetry(tempDir));
  return '${tempDir.path}/wallet.sqlite';
}

Wallet _reloadWallet(
  Wallet current,
  Descriptor descriptor,
  Descriptor changeDescriptor,
  Persister persister,
) {
  current.dispose();
  return Wallet.load(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    persister: persister,
    lookahead: defaultLookahead,
  );
}

void _exerciseWalletOperation(Wallet wallet, Random random) {
  switch (random.nextInt(13)) {
    case 0:
      wallet.revealNextAddress(keychain: KeychainKind.external_);
      break;
    case 1:
      wallet.revealNextAddress(keychain: KeychainKind.internal);
      break;
    case 2:
      wallet.peekAddress(
        keychain: KeychainKind.external_,
        index: random.nextInt(30),
      );
      break;
    case 3:
      wallet.nextUnusedAddress(keychain: KeychainKind.external_);
      break;
    case 4:
      wallet.listUnusedAddresses(keychain: KeychainKind.external_);
      break;
    case 5:
      wallet.listOutput();
      break;
    case 6:
      wallet.listUnspent();
      break;
    case 7:
      wallet.balance();
      break;
    case 8:
      wallet.latestCheckpoint();
      break;
    case 9:
      final txs = wallet.transactions();
      for (final tx in txs.take(5)) {
        final txid = tx.transaction.computeTxid();
        wallet.txDetails(txid: txid);
        wallet.getTx(txid: txid);
      }
      break;
    case 10:
      wallet.nextDerivationIndex(keychain: KeychainKind.external_);
      wallet.nextDerivationIndex(keychain: KeychainKind.internal);
      break;
    case 11:
      final index = wallet.nextDerivationIndex(
        keychain: KeychainKind.external_,
      );
      wallet.markUsed(keychain: KeychainKind.external_, index: index);
      wallet.unmarkUsed(keychain: KeychainKind.external_, index: index);
      break;
    case 12:
      wallet.network();
      wallet.publicDescriptor(keychain: KeychainKind.external_);
      break;
  }
}

void main() {
  group('Wallet sequence canary', () {
    test('deterministic offline operation sequences remain stable', () {
      final descriptor = buildBip84Descriptor(Network.testnet);
      final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
      final sqlitePath = _createTempSqlitePath();
      final persister = Persister.newSqlite(path: sqlitePath);
      late Wallet wallet;
      var walletInitialized = false;

      try {
        wallet = Wallet(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: persister,
          lookahead: defaultLookahead,
        );
        walletInitialized = true;

        for (final seed in [7, 42, 1337]) {
          final random = Random(seed);
          for (var step = 0; step < 80; step++) {
            _exerciseWalletOperation(wallet, random);
            if (step % 16 == 0) {
              wallet.persist(persister: persister);
            }
            if (step % 25 == 0) {
              wallet = _reloadWallet(
                wallet,
                descriptor,
                changeDescriptor,
                persister,
              );
            }
          }
        }

        final persisted = wallet.persist(persister: persister);
        expect(persisted, isA<bool>());

        final checkpointBeforeReload = wallet.latestCheckpoint();
        final checkpointBeforeReloadHeight = checkpointBeforeReload.height;
        wallet = _reloadWallet(wallet, descriptor, changeDescriptor, persister);
        final checkpointAfterReload = wallet.latestCheckpoint();

        expect(
          checkpointAfterReload.height,
          equals(checkpointBeforeReloadHeight),
        );
        expect(
          wallet.nextDerivationIndex(keychain: KeychainKind.external_),
          greaterThanOrEqualTo(0),
        );
        expect(
          wallet.nextDerivationIndex(keychain: KeychainKind.internal),
          greaterThanOrEqualTo(0),
        );
      } finally {
        if (walletInitialized) {
          wallet.dispose();
        }
        persister.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });
  });
}
