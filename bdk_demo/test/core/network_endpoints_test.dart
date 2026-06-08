import 'package:bdk_demo/core/constants/network_endpoints.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signet and testnet expose multiple endpoint options', () {
    expect(endpointOptionsFor(WalletNetwork.signet), hasLength(2));
    expect(endpointOptionsFor(WalletNetwork.testnet), hasLength(5));
    expect(endpointOptionsFor(WalletNetwork.regtest), isEmpty);
  });

  test('signet options exclude cert-incompatible endpoints', () {
    final urls = endpointOptionsFor(WalletNetwork.signet).map((e) => e.url);

    expect(urls, isNot(contains('ssl://electrum.emzy.de:53002')));
    expect(urls, isNot(contains('ssl://signet-electrumx.wakiyamap.dev:50002')));
  });

  test('resolveEndpointConfig uses selected url when known', () {
    final selected = testnetEndpointOptions.last;
    final config = resolveEndpointConfig(
      WalletNetwork.testnet,
      selectedUrl: selected.url,
    );

    expect(config.url, selected.url);
  });
}
