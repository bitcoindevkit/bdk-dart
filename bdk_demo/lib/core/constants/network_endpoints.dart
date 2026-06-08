import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/models/wallet_record.dart';

class NetworkEndpointOption {
  const NetworkEndpointOption({
    required this.id,
    required this.label,
    required this.url,
    required this.clientType,
  });

  final String id;
  final String label;
  final String url;
  final ClientType clientType;

  EndpointConfig get config => EndpointConfig(clientType: clientType, url: url);
}

const signetEndpointOptions = [
  NetworkEndpointOption(
    id: 'mempool-signet',
    label: 'Mempool.space',
    url: 'ssl://mempool.space:60602',
    clientType: ClientType.electrum,
  ),
  NetworkEndpointOption(
    id: 'mutinynet-signet',
    label: 'Mutinynet',
    url: 'ssl://mutinynet.com:60602',
    clientType: ClientType.electrum,
  ),
];

const testnetEndpointOptions = [
  NetworkEndpointOption(
    id: 'blockstream-testnet',
    label: 'Blockstream',
    url: 'ssl://electrum.blockstream.info:60002',
    clientType: ClientType.electrum,
  ),
  NetworkEndpointOption(
    id: 'aranguren-testnet',
    label: 'Aranguren.org',
    url: 'ssl://testnet.aranguren.org:51002',
    clientType: ClientType.electrum,
  ),
  NetworkEndpointOption(
    id: 'qtornado-testnet',
    label: 'Qtornado.com',
    url: 'ssl://testnet.qtornado.com:51002',
    clientType: ClientType.electrum,
  ),
  NetworkEndpointOption(
    id: 'c3soft-testnet',
    label: 'C3-soft',
    url: 'ssl://blackie.c3-soft.com:57006',
    clientType: ClientType.electrum,
  ),
  NetworkEndpointOption(
    id: 'bestsrv-testnet',
    label: 'Bestsrv.de',
    url: 'ssl://v22019051929289916.bestsrv.de:50002',
    clientType: ClientType.electrum,
  ),
];

List<NetworkEndpointOption> endpointOptionsFor(WalletNetwork network) {
  return switch (network) {
    WalletNetwork.signet => signetEndpointOptions,
    WalletNetwork.testnet => testnetEndpointOptions,
    WalletNetwork.regtest => const [],
  };
}

EndpointConfig resolveEndpointConfig(
  WalletNetwork network, {
  String? selectedUrl,
}) {
  final options = endpointOptionsFor(network);
  if (selectedUrl != null) {
    for (final option in options) {
      if (option.url == selectedUrl) return option.config;
    }
  }

  return defaultEndpoints[network] ?? options.first.config;
}

NetworkEndpointOption? selectedEndpointOption(
  WalletNetwork network, {
  String? selectedUrl,
}) {
  if (selectedUrl == null) {
    final options = endpointOptionsFor(network);
    if (options.isEmpty) return null;
    final defaultUrl = defaultEndpoints[network]?.url;
    for (final option in options) {
      if (option.url == defaultUrl) return option;
    }
    return options.first;
  }

  for (final option in endpointOptionsFor(network)) {
    if (option.url == selectedUrl) return option;
  }
  return null;
}
