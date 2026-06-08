import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/core/constants/network_endpoints.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedEndpointUrlProvider = Provider.family<String?, WalletNetwork>((
  ref,
  network,
) {
  return ref.watch(storageServiceProvider).getSelectedEndpointUrl(network);
});

final endpointConfigProvider = Provider.family<EndpointConfig, WalletNetwork>((
  ref,
  network,
) {
  final selectedUrl = ref.watch(selectedEndpointUrlProvider(network));
  return resolveEndpointConfig(network, selectedUrl: selectedUrl);
});

final networkEndpointOptionsProvider =
    Provider.family<List<NetworkEndpointOption>, WalletNetwork>((ref, network) {
      return endpointOptionsFor(network);
    });

final selectedNetworkEndpointOptionProvider =
    Provider.family<NetworkEndpointOption?, WalletNetwork>((ref, network) {
      final selectedUrl = ref.watch(selectedEndpointUrlProvider(network));
      return selectedEndpointOption(network, selectedUrl: selectedUrl);
    });

Future<void> selectNetworkEndpoint(
  WidgetRef ref,
  WalletNetwork network,
  String url,
) async {
  await ref.read(storageServiceProvider).setSelectedEndpointUrl(network, url);
  ref.invalidate(selectedEndpointUrlProvider(network));
  ref.invalidate(endpointConfigProvider(network));
  ref.invalidate(selectedNetworkEndpointOptionProvider(network));
}
