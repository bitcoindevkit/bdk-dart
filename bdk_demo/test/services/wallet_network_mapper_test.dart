import 'package:bdk_dart/bdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/wallet_network_mapper.dart';

void main() {
  group('WalletNetworkX.toBdkNetwork', () {
    test('maps signet correctly', () {
      expect(WalletNetwork.signet.toBdkNetwork(), Network.signet);
    });

    test('maps testnet correctly', () {
      expect(WalletNetwork.testnet.toBdkNetwork(), Network.testnet);
    });

    test('maps regtest correctly', () {
      expect(WalletNetwork.regtest.toBdkNetwork(), Network.regtest);
    });
  });
}
