import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/models/wallet_record.dart';

extension WalletNetworkX on WalletNetwork {
  Network toBdkNetwork() => switch (this) {
    WalletNetwork.signet => Network.signet,
    WalletNetwork.testnet => Network.testnet,
    WalletNetwork.regtest => Network.regtest,
  };
}
