import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

void main() {
  group('Offline wallet', () {
    test('revealNextAddress yields expected address on multiple networks', () {
      final descriptor = buildDescriptor(
        offlineDescriptorString,
        Network.signet,
      );
      final changeDescriptor = buildDescriptor(
        offlineChangeDescriptorString,
        Network.signet,
      );
      final persister = Persister.newInMemory();
      final wallet = Wallet(
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        network: Network.signet,
        persister: persister,
        lookahead: defaultLookahead,
      );

      final addressInfo = wallet.revealNextAddress(
        keychain: KeychainKind.external_,
      );
      final expectedAddress = Address(
        address: expectedOfflineAddress,
        network: Network.signet,
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
      expect(
        addressInfo.address.scriptPubkey().toBytes(),
        orderedEquals(expectedAddress.scriptPubkey().toBytes()),
      );
    });

    test('new wallet starts with zero balance', () {
      final descriptor = buildDescriptor(
        offlineDescriptorString,
        Network.signet,
      );
      final changeDescriptor = buildDescriptor(
        offlineChangeDescriptorString,
        Network.signet,
      );
      final persister = Persister.newInMemory();
      final wallet = Wallet(
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        network: Network.signet,
        persister: persister,
        lookahead: defaultLookahead,
      );

      expect(wallet.balance().total.toSat(), equals(0));
    });
  });
}
