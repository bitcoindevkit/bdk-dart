import 'dart:io';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

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
  group('Wallet creation SQLite lifecycle', () {
    test(
      'persists external and internal derivation state across SQLite reopen',
      () {
        final tempDir = Directory.systemTemp.createTempSync(
          'bdk_dart_wallet_creation_',
        );
        addTearDown(() => _deleteDirectoryWithRetry(tempDir));

        final dbPath = '${tempDir.path}/wallet.sqlite';
        final descriptor = buildBip84Descriptor(Network.testnet);
        final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
        Persister? persister;
        Wallet? wallet;
        Address? externalAddress;
        Address? internalAddress;
        Script? externalScript;
        Script? internalScript;
        Persister? reopenedPersister;
        Wallet? reopenedWallet;
        Address? reopenedExternalAddress;
        Address? reopenedInternalAddress;
        Script? reopenedExternalScript;
        Script? reopenedInternalScript;

        try {
          expect(File(dbPath).existsSync(), isFalse);

          persister = Persister.newSqlite(path: dbPath);
          wallet = Wallet(
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            network: Network.testnet,
            persister: persister,
            lookahead: defaultLookahead,
          );

          final extAddressInfo = wallet.revealNextAddress(
            keychain: KeychainKind.external_,
          );
          externalAddress = extAddressInfo.address;

          final intAddressInfo = wallet.revealNextAddress(
            keychain: KeychainKind.internal,
          );
          internalAddress = intAddressInfo.address;

          expect(extAddressInfo.index, equals(0));
          expect(intAddressInfo.index, equals(0));
          expect(wallet.persist(persister: persister), isTrue);

          externalScript = externalAddress.scriptPubkey();
          final extBytes = externalScript.toBytes();

          internalScript = internalAddress.scriptPubkey();
          final intBytes = internalScript.toBytes();

          // Dispose temporary address and script objects
          externalScript.dispose();
          externalScript = null;
          externalAddress.dispose();
          externalAddress = null;

          internalScript.dispose();
          internalScript = null;
          internalAddress.dispose();
          internalAddress = null;

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

          final balance = reopenedWallet.balance();
          final balanceSat = balance.total.toSat();
          balance.immature.dispose();
          balance.trustedPending.dispose();
          balance.untrustedPending.dispose();
          balance.confirmed.dispose();
          balance.trustedSpendable.dispose();
          balance.total.dispose();

          expect(balanceSat, equals(0));
          expect(
            reopenedWallet.nextDerivationIndex(
              keychain: KeychainKind.external_,
            ),
            equals(1),
          );
          expect(
            reopenedWallet.nextDerivationIndex(keychain: KeychainKind.internal),
            equals(1),
          );

          final reopenedExtAddressInfo = reopenedWallet.peekAddress(
            keychain: KeychainKind.external_,
            index: 0,
          );
          reopenedExternalAddress = reopenedExtAddressInfo.address;

          final reopenedIntAddressInfo = reopenedWallet.peekAddress(
            keychain: KeychainKind.internal,
            index: 0,
          );
          reopenedInternalAddress = reopenedIntAddressInfo.address;

          reopenedExternalScript = reopenedExternalAddress.scriptPubkey();
          final reopenedExtBytes = reopenedExternalScript.toBytes();

          reopenedInternalScript = reopenedInternalAddress.scriptPubkey();
          final reopenedIntBytes = reopenedInternalScript.toBytes();

          expect(reopenedExtBytes, orderedEquals(extBytes));
          expect(reopenedIntBytes, orderedEquals(intBytes));
        } finally {
          reopenedInternalScript?.dispose();
          reopenedExternalScript?.dispose();
          reopenedInternalAddress?.dispose();
          reopenedExternalAddress?.dispose();
          reopenedWallet?.dispose();
          reopenedPersister?.dispose();
          internalScript?.dispose();
          externalScript?.dispose();
          internalAddress?.dispose();
          externalAddress?.dispose();
          wallet?.dispose();
          persister?.dispose();
          descriptor.dispose();
          changeDescriptor.dispose();
        }
      },
    );

    test('does not restore derivation changes made after the last persist', () {
      final tempDir = Directory.systemTemp.createTempSync(
        'bdk_dart_wallet_creation_test2_',
      );
      addTearDown(() => _deleteDirectoryWithRetry(tempDir));

      final dbPath = '${tempDir.path}/wallet.sqlite';
      final descriptor = buildBip84Descriptor(Network.testnet);
      final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
      Persister? persister;
      Wallet? wallet;
      Address? externalAddress0;
      Address? externalAddress1;
      Persister? reopenedPersister;
      Wallet? reopenedWallet;

      try {
        persister = Persister.newSqlite(path: dbPath);
        wallet = Wallet(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: persister,
          lookahead: defaultLookahead,
        );

        final extAddressInfo0 = wallet.revealNextAddress(
          keychain: KeychainKind.external_,
        );
        externalAddress0 = extAddressInfo0.address;
        expect(extAddressInfo0.index, equals(0));

        expect(wallet.persist(persister: persister), isTrue);

        final extAddressInfo1 = wallet.revealNextAddress(
          keychain: KeychainKind.external_,
        );
        externalAddress1 = extAddressInfo1.address;
        expect(extAddressInfo1.index, equals(1));

        // Dispose original wallet and persister before reopening
        externalAddress0.dispose();
        externalAddress0 = null;
        externalAddress1.dispose();
        externalAddress1 = null;

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
        externalAddress1?.dispose();
        externalAddress0?.dispose();
        wallet?.dispose();
        persister?.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });
  });
}
