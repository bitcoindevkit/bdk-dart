import 'dart:io';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

const _fixtureName = 'pre_existing_wallet_persistence_test.sqlite';

String _copyFixtureToTempDir() {
  final source = File('test/data/$_fixtureName');
  final tempDir = Directory.systemTemp.createTempSync('bdk_dart_persistence_');
  addTearDown(() async {
    // Windows can keep sqlite file handles open briefly after dispose.
    for (var attempt = 0; attempt < 10; attempt++) {
      try {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
        return;
      } on PathAccessException {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });
  final destination = File('${tempDir.path}/$_fixtureName');
  destination.writeAsBytesSync(source.readAsBytesSync(), flush: true);
  return destination.path;
}

void main() {
  group('Offline persistence', () {
    test('loads sqlite wallet with private descriptors', () {
      final dbPath = _copyFixtureToTempDir();
      final descriptor = buildDescriptor(
        persistenceDescriptorString,
        Network.signet,
      );
      final changeDescriptor = buildDescriptor(
        persistenceChangeDescriptorString,
        Network.signet,
      );
      final persister = Persister.newSqlite(dbPath);
      Wallet? wallet;

      try {
        wallet = Wallet.load(
          descriptor,
          changeDescriptor,
          persister,
          defaultLookahead,
        );

        final addressInfo = wallet.revealNextAddress(KeychainKind.external_);
        final expectedAddress = Address(
          expectedPersistedAddress,
          Network.signet,
        );

        expect(addressInfo.index, equals(7));
        expect(
          addressInfo.address.scriptPubkey().toBytes(),
          orderedEquals(expectedAddress.scriptPubkey().toBytes()),
        );
      } finally {
        wallet?.dispose();
        persister.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });

    test('loads sqlite wallet with public descriptors', () {
      final dbPath = _copyFixtureToTempDir();
      final descriptor = buildDescriptor(
        persistencePublicDescriptorString,
        Network.signet,
      );
      final changeDescriptor = buildDescriptor(
        persistencePublicChangeDescriptorString,
        Network.signet,
      );
      final persister = Persister.newSqlite(dbPath);
      Wallet? wallet;

      try {
        wallet = Wallet.load(
          descriptor,
          changeDescriptor,
          persister,
          defaultLookahead,
        );

        final addressInfo = wallet.revealNextAddress(KeychainKind.external_);

        expect(addressInfo.index, equals(7));
        final expectedAddress = Address(
          expectedPersistedAddress,
          Network.signet,
        );
        expect(
          addressInfo.address.scriptPubkey().toBytes(),
          orderedEquals(expectedAddress.scriptPubkey().toBytes()),
        );
      } finally {
        wallet?.dispose();
        persister.dispose();
        descriptor.dispose();
        changeDescriptor.dispose();
      }
    });
  });
}
