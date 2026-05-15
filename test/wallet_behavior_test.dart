import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

Wallet _buildTestWallet() {
  final persister = Persister.newInMemory();
  return Wallet(
    descriptor: buildBip84Descriptor(Network.testnet),
    changeDescriptor: buildBip84ChangeDescriptor(Network.testnet),
    network: Network.testnet,
    persister: persister,
    lookahead: defaultLookahead,
  );
}

void main() {
  group('Wallet behaviour', () {
    test('produces addresses valid for expected networks', () {
      final wallet = _buildTestWallet();
      final addressInfo = wallet.revealNextAddress(
        keychain: KeychainKind.external_,
      );

      expect(
        addressInfo.address.isValidForNetwork(network: Network.testnet),
        isTrue,
      );
      expect(
        addressInfo.address.isValidForNetwork(network: Network.testnet4),
        isTrue,
      );
      expect(
        addressInfo.address.isValidForNetwork(network: Network.signet),
        isTrue,
      );
      expect(
        addressInfo.address.isValidForNetwork(network: Network.regtest),
        isFalse,
      );
      expect(
        addressInfo.address.isValidForNetwork(network: Network.bitcoin),
        isFalse,
      );
    });

    test('starts with zero balance before sync', () {
      final wallet = _buildTestWallet();
      expect(wallet.balance().total.toSat(), equals(0));
    });

    test(
      'single-descriptor wallet returns identical external/internal addresses',
      () {
        final persister = Persister.newInMemory();
        final wallet = Wallet.createSingle(
          descriptor: buildBip84Descriptor(Network.testnet),
          network: Network.testnet,
          persister: persister,
          lookahead: defaultLookahead,
        );

        final externalAddress = wallet.peekAddress(
          keychain: KeychainKind.external_,
          index: 0,
        );
        final internalAddress = wallet.peekAddress(
          keychain: KeychainKind.internal,
          index: 0,
        );

        expect(
          externalAddress.address.scriptPubkey().toBytes(),
          orderedEquals(internalAddress.address.scriptPubkey().toBytes()),
        );
      },
    );
  });
}
