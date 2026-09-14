import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/network_endpoint_providers.dart';
import 'package:bdk_demo/providers/send_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('blockchain client factory resolves the endpoint for the network', () {
    var endpointResolved = false;
    final endpointError = StateError('endpoint resolved');
    final container = ProviderContainer(
      overrides: [
        endpointConfigProvider(WalletNetwork.regtest).overrideWith((ref) {
          endpointResolved = true;
          throw endpointError;
        }),
      ],
    );
    addTearDown(container.dispose);

    expect(
      () => container.read(blockchainClientFactoryProvider)(
        WalletNetwork.regtest,
      ),
      throwsA(anything),
    );
    expect(endpointResolved, isTrue);
  });
}
