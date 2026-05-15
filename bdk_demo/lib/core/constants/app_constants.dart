import 'package:bdk_demo/models/wallet_record.dart';

abstract final class AppConstants {
  static const appVersion = '0.1.0';

  static const walletLookahead = 25;

  static const fullScanStopGap = 25;

  static const syncParallelRequests = 4;

  static const maxRecipients = 4;

  static const maxLogEntries = 5000;
}

enum ClientType { esplora, electrum }

class EndpointConfig {
  final ClientType clientType;
  final String url;

  const EndpointConfig({required this.clientType, required this.url});
}

const Map<WalletNetwork, EndpointConfig> defaultEndpoints = {
  WalletNetwork.signet: EndpointConfig(
    clientType: ClientType.electrum,
    url: 'ssl://mempool.space:60602',
  ),
  WalletNetwork.testnet: EndpointConfig(
    clientType: ClientType.electrum,
    url: 'ssl://electrum.blockstream.info:60002',
  ),
  WalletNetwork.regtest: EndpointConfig(
    clientType: ClientType.esplora,
    url: 'http://localhost:3002',
  ),
};
