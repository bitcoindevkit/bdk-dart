import 'dart:io';

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
    'bdk_dart_keychains_lifecycle_',
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

void _expectUsableKeychains(List<WalletKeychain> keychains) {
  expect(keychains, isA<List<WalletKeychain>>());
  expect(keychains.length, greaterThanOrEqualTo(2));

  for (final entry in keychains) {
    expect(
      entry.keychain,
      isIn([KeychainKind.external_, KeychainKind.internal]),
    );
    expect(entry.publicDescriptor, isA<Descriptor>());
    entry.publicDescriptor.descType();
    entry.publicDescriptor.descriptorId();
    entry.publicDescriptor.hasWildcard();
  }
}

void main() {
  group('Wallet keychains lifecycle smoke', () {
    test(
      'keychains() remains callable before and after sqlite persist/reload',
      () {
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

          _expectUsableKeychains(wallet.keychains());

          wallet.persist(persister: persister);

          wallet = _reloadWallet(
            wallet,
            descriptor,
            changeDescriptor,
            persister,
          );

          _expectUsableKeychains(wallet.keychains());
        } finally {
          if (walletInitialized) {
            wallet.dispose();
          }
          persister.dispose();
          descriptor.dispose();
          changeDescriptor.dispose();
        }
      },
    );
  });
}
