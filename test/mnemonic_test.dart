import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

void main() {
  group('Mnemonic', () {
    test('produces expected BIP86 descriptor', () {
      final mnemonic = Mnemonic.fromString(
        mnemonic:
            "space echo position wrist orient erupt relief museum myself grain wisdom tumble",
      );
      final descriptorSecretKey = DescriptorSecretKey(
        network: Network.testnet,
        mnemonic: mnemonic,
        password: null,
      );
      final descriptor = Descriptor.newBip86(
        secretKey: descriptorSecretKey,
        keychainKind: KeychainKind.external_,
        network: Network.testnet,
      );

      expect(
        descriptor.toString(),
        equals(
          "tr([be1eec8f/86'/1'/0']tpubDCTtszwSxPx3tATqDrsSyqScPNnUChwQAVAkanuDUCJQESGBbkt68nXXKRDifYSDbeMa2Xg2euKbXaU3YphvGWftDE7ozRKPriT6vAo3xsc/0/*)#m7puekcx",
        ),
      );
    });
  });
}
