// @Tags(['integration'])

import 'dart:io';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import '../test_constants.dart';

Future<void> _deleteDirectoryWithRetry(Directory directory) async {
  for (var attempt = 0; attempt < 10; attempt++) {
    try {
      if (directory.existsSync()) {
        await directory.delete(recursive: true);
      }
      return;
    } on PathAccessException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  if (directory.existsSync()) {
    await directory.delete(recursive: true);
  }
}

void main() {
  group('Wallet creation integration', () {
    test('persists derivation state across a SQLite reopen', () {
      final tempDir = Directory.systemTemp.createTempSync(
        'bdk_dart_wallet_creation_',
      );
      addTearDown(() => _deleteDirectoryWithRetry(tempDir));

      final dbPath = '${tempDir.path}/wallet.sqlite';
      final descriptor = buildBip84Descriptor(Network.testnet);
      final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
      Persister? persister;
      Wallet? wallet;
      Persister? reopenedPersister;
      Wallet? reopenedWallet;

      try {
        expect(File(dbPath).existsSync(), isFalse);

        final initialPersister = Persister.newSqlite(path: dbPath);
        persister = initialPersister;

        wallet = Wallet(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: initialPersister,
          lookahead: defaultLookahead,
        );

        final externalAddress = wallet.revealNextAddress(
          keychain: KeychainKind.external_,
        );
        final internalAddress = wallet.revealNextAddress(
          keychain: KeychainKind.internal,
        );

        expect(externalAddress.index, equals(0));
        expect(internalAddress.index, equals(0));
        expect(wallet.persist(persister: initialPersister), isTrue);

        wallet.dispose();
        wallet = null;
        persister.dispose();
        persister = null;

        expect(File(dbPath).existsSync(), isTrue);

        reopenedPersister = Persister.newSqlite(path: dbPath);
        reopenedWallet = Wallet.load(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          persister: reopenedPersister,
          lookahead: defaultLookahead,
        );

        expect(reopenedWallet.network(), equals(Network.testnet));
        expect(reopenedWallet.balance().total.toSat(), equals(0));
        expect(
          reopenedWallet.nextDerivationIndex(keychain: KeychainKind.external_),
          equals(1),
        );
        expect(
          reopenedWallet.nextDerivationIndex(keychain: KeychainKind.internal),
          equals(1),
        );

        final reopenedExternalAddress = reopenedWallet.peekAddress(
          keychain: KeychainKind.external_,
          index: externalAddress.index,
        );
        final reopenedInternalAddress = reopenedWallet.peekAddress(
          keychain: KeychainKind.internal,
          index: internalAddress.index,
        );

        expect(
          reopenedExternalAddress.address.scriptPubkey().toBytes(),
          orderedEquals(externalAddress.address.scriptPubkey().toBytes()),
        );
        expect(
          reopenedInternalAddress.address.scriptPubkey().toBytes(),
          orderedEquals(internalAddress.address.scriptPubkey().toBytes()),
        );
      } finally {
        reopenedWallet?.dispose();
        reopenedPersister?.dispose();
        wallet?.dispose();
        persister?.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });

    test('cover multiple SQLite wallet address reveals', () {
      final tempDir = Directory.systemTemp.createTempSync(
        'bdk_dart_wallet_creation_test1_',
      );
      addTearDown(() => _deleteDirectoryWithRetry(tempDir));

      final dbPath = '${tempDir.path}/wallet.sqlite';
      final descriptor = buildBip84Descriptor(Network.testnet);
      final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
      Persister? persister;
      Wallet? wallet;
      Persister? reopenedPersister;
      Wallet? reopenedWallet;

      try {
        final initialPersister = Persister.newSqlite(path: dbPath);
        persister = initialPersister;

        wallet = Wallet(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: initialPersister,
          lookahead: defaultLookahead,
        );

        final ext0 = wallet.revealNextAddress(keychain: KeychainKind.external_);
        final ext1 = wallet.revealNextAddress(keychain: KeychainKind.external_);
        final ext2 = wallet.revealNextAddress(keychain: KeychainKind.external_);
        final int0 = wallet.revealNextAddress(keychain: KeychainKind.internal);

        expect(ext0.index, equals(0));
        expect(ext1.index, equals(1));
        expect(ext2.index, equals(2));
        expect(int0.index, equals(0));

        expect(wallet.persist(persister: initialPersister), isTrue);

        wallet.dispose();
        wallet = null;
        persister.dispose();
        persister = null;

        reopenedPersister = Persister.newSqlite(path: dbPath);
        reopenedWallet = Wallet.load(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          persister: reopenedPersister,
          lookahead: defaultLookahead,
        );

        expect(
          reopenedWallet.nextDerivationIndex(keychain: KeychainKind.external_),
          equals(3),
        );
        expect(
          reopenedWallet.nextDerivationIndex(keychain: KeychainKind.internal),
          equals(1),
        );

        final reopenedExt0 = reopenedWallet.peekAddress(
          keychain: KeychainKind.external_,
          index: 0,
        );
        final reopenedExt1 = reopenedWallet.peekAddress(
          keychain: KeychainKind.external_,
          index: 1,
        );
        final reopenedExt2 = reopenedWallet.peekAddress(
          keychain: KeychainKind.external_,
          index: 2,
        );
        final reopenedInt0 = reopenedWallet.peekAddress(
          keychain: KeychainKind.internal,
          index: 0,
        );

        expect(
          reopenedExt0.address.scriptPubkey().toBytes(),
          orderedEquals(ext0.address.scriptPubkey().toBytes()),
        );
        expect(
          reopenedExt1.address.scriptPubkey().toBytes(),
          orderedEquals(ext1.address.scriptPubkey().toBytes()),
        );
        expect(
          reopenedExt2.address.scriptPubkey().toBytes(),
          orderedEquals(ext2.address.scriptPubkey().toBytes()),
        );
        expect(
          reopenedInt0.address.scriptPubkey().toBytes(),
          orderedEquals(int0.address.scriptPubkey().toBytes()),
        );
      } finally {
        reopenedWallet?.dispose();
        reopenedPersister?.dispose();
        wallet?.dispose();
        persister?.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });

    test('cover explicit SQLite wallet persist contract', () {
      final tempDir = Directory.systemTemp.createTempSync(
        'bdk_dart_wallet_creation_test2_',
      );
      addTearDown(() => _deleteDirectoryWithRetry(tempDir));

      final dbPath = '${tempDir.path}/wallet.sqlite';
      final descriptor = buildBip84Descriptor(Network.testnet);
      final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
      Persister? persister;
      Wallet? wallet;
      Persister? reopenedPersister;
      Wallet? reopenedWallet;

      try {
        final initialPersister = Persister.newSqlite(path: dbPath);
        persister = initialPersister;

        wallet = Wallet(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: initialPersister,
          lookahead: defaultLookahead,
        );

        final ext0 = wallet.revealNextAddress(keychain: KeychainKind.external_);
        expect(ext0.index, equals(0));

        expect(wallet.persist(persister: initialPersister), isTrue);

        final ext1 = wallet.revealNextAddress(keychain: KeychainKind.external_);
        expect(ext1.index, equals(1));

        wallet.dispose();
        wallet = null;
        persister.dispose();
        persister = null;

        reopenedPersister = Persister.newSqlite(path: dbPath);
        reopenedWallet = Wallet.load(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          persister: reopenedPersister,
          lookahead: defaultLookahead,
        );

        expect(
          reopenedWallet.nextDerivationIndex(keychain: KeychainKind.external_),
          equals(1),
        );
      } finally {
        reopenedWallet?.dispose();
        reopenedPersister?.dispose();
        wallet?.dispose();
        persister?.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });

    test('cover independent SQLite keychain indexes', () {
      final tempDir = Directory.systemTemp.createTempSync(
        'bdk_dart_wallet_creation_test3_',
      );
      addTearDown(() => _deleteDirectoryWithRetry(tempDir));

      final dbPath = '${tempDir.path}/wallet.sqlite';
      final descriptor = buildBip84Descriptor(Network.testnet);
      final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
      Persister? persister;
      Wallet? wallet;
      Persister? reopenedPersister;
      Wallet? reopenedWallet;

      try {
        final initialPersister = Persister.newSqlite(path: dbPath);
        persister = initialPersister;

        wallet = Wallet(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: initialPersister,
          lookahead: defaultLookahead,
        );

        final ext0 = wallet.revealNextAddress(keychain: KeychainKind.external_);
        final ext1 = wallet.revealNextAddress(keychain: KeychainKind.external_);
        final ext2 = wallet.revealNextAddress(keychain: KeychainKind.external_);

        final int0 = wallet.revealNextAddress(keychain: KeychainKind.internal);
        final int1 = wallet.revealNextAddress(keychain: KeychainKind.internal);

        expect(ext0.index, equals(0));
        expect(ext1.index, equals(1));
        expect(ext2.index, equals(2));

        expect(int0.index, equals(0));
        expect(int1.index, equals(1));

        expect(wallet.persist(persister: initialPersister), isTrue);

        wallet.dispose();
        wallet = null;
        persister.dispose();
        persister = null;

        reopenedPersister = Persister.newSqlite(path: dbPath);
        reopenedWallet = Wallet.load(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          persister: reopenedPersister,
          lookahead: defaultLookahead,
        );

        expect(
          reopenedWallet.nextDerivationIndex(keychain: KeychainKind.external_),
          equals(3),
        );
        expect(
          reopenedWallet.nextDerivationIndex(keychain: KeychainKind.internal),
          equals(2),
        );

        final reopenedExt1 = reopenedWallet.peekAddress(
          keychain: KeychainKind.external_,
          index: 1,
        );
        final reopenedInt0 = reopenedWallet.peekAddress(
          keychain: KeychainKind.internal,
          index: 0,
        );

        expect(
          reopenedExt1.address.scriptPubkey().toBytes(),
          orderedEquals(ext1.address.scriptPubkey().toBytes()),
        );
        expect(
          reopenedInt0.address.scriptPubkey().toBytes(),
          orderedEquals(int0.address.scriptPubkey().toBytes()),
        );
      } finally {
        reopenedWallet?.dispose();
        reopenedPersister?.dispose();
        wallet?.dispose();
        persister?.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });
  });
}
