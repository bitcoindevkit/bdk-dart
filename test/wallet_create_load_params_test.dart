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

CreateParams _createParams() =>
    CreateParams(lookahead: defaultLookahead, useSpkCache: true);

LoadParams _loadParams() => LoadParams(
  checkNetwork: Network.testnet,
  lookahead: defaultLookahead,
  useSpkCache: false,
);

void main() {
  group('Wallet CreateParams / LoadParams constructors', () {
    test('createWithParams wallet reloads through loadWithParams', () {
      final tempDir = Directory.systemTemp.createTempSync(
        'bdk_dart_create_with_params_',
      );
      addTearDown(() => _deleteDirectoryWithRetry(tempDir));

      final dbPath = '${tempDir.path}/wallet.sqlite';
      final descriptor = buildBip84Descriptor(Network.testnet);
      final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
      Persister? persister;
      Wallet? wallet;
      Address? revealedAddress;
      Persister? reopenedPersister;
      Wallet? reopenedWallet;
      Address? peekedAddress;

      try {
        persister = Persister.newSqlite(path: dbPath);
        wallet = Wallet.createWithParams(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          network: Network.testnet,
          persister: persister,
          params: _createParams(),
        );

        final revealed = wallet.revealNextAddress(
          keychain: KeychainKind.external_,
        );
        revealedAddress = revealed.address;
        expect(revealedAddress.toString(), isNotEmpty);
        expect(wallet.persist(persister: persister), isTrue);

        revealedAddress.dispose();
        revealedAddress = null;
        wallet.dispose();
        wallet = null;
        persister.dispose();
        persister = null;

        reopenedPersister = Persister.newSqlite(path: dbPath);
        reopenedWallet = Wallet.loadWithParams(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          persister: reopenedPersister,
          params: _loadParams(),
        );

        expect(reopenedWallet.network(), equals(Network.testnet));

        final peeked = reopenedWallet.peekAddress(
          keychain: KeychainKind.external_,
          index: 0,
        );
        peekedAddress = peeked.address;
        expect(peekedAddress.toString(), isNotEmpty);
      } finally {
        peekedAddress?.dispose();
        reopenedWallet?.dispose();
        reopenedPersister?.dispose();
        revealedAddress?.dispose();
        wallet?.dispose();
        persister?.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });

    test(
      'createSingleWithParams wallet reloads through loadSingleWithParams',
      () {
        final tempDir = Directory.systemTemp.createTempSync(
          'bdk_dart_create_single_with_params_',
        );
        addTearDown(() => _deleteDirectoryWithRetry(tempDir));

        final dbPath = '${tempDir.path}/wallet.sqlite';
        final descriptor = buildBip86Descriptor(Network.testnet);
        Persister? persister;
        Wallet? wallet;
        Address? revealedAddress;
        Persister? reopenedPersister;
        Wallet? reopenedWallet;
        Address? peekedAddress;

        try {
          persister = Persister.newSqlite(path: dbPath);
          wallet = Wallet.createSingleWithParams(
            descriptor: descriptor,
            network: Network.testnet,
            persister: persister,
            params: _createParams(),
          );

          final revealed = wallet.revealNextAddress(
            keychain: KeychainKind.external_,
          );
          revealedAddress = revealed.address;
          expect(revealedAddress.toString(), isNotEmpty);
          expect(wallet.persist(persister: persister), isTrue);

          revealedAddress.dispose();
          revealedAddress = null;
          wallet.dispose();
          wallet = null;
          persister.dispose();
          persister = null;

          reopenedPersister = Persister.newSqlite(path: dbPath);
          reopenedWallet = Wallet.loadSingleWithParams(
            descriptor: descriptor,
            persister: reopenedPersister,
            params: _loadParams(),
          );

          expect(reopenedWallet.network(), equals(Network.testnet));

          final peeked = reopenedWallet.peekAddress(
            keychain: KeychainKind.external_,
            index: 0,
          );
          peekedAddress = peeked.address;
          expect(peekedAddress.toString(), isNotEmpty);
        } finally {
          peekedAddress?.dispose();
          reopenedWallet?.dispose();
          reopenedPersister?.dispose();
          revealedAddress?.dispose();
          wallet?.dispose();
          persister?.dispose();
          descriptor.dispose();
        }
      },
    );
  });
}
