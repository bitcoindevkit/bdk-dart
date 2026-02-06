// @Tags(['integration'])

import 'package:test/test.dart';

import 'integration_helpers.dart';

void main() {
  group('Integration harness', () {
    test('returns skip reason when integration flag is disabled', () {
      final reason = integrationSkipReason(
        env: const {},
        requiredEnv: [electrumUrlEnv],
      );

      expect(reason, isNotNull);
      expect(reason, contains(integrationEnabledEnv));
    });

    test('returns missing env vars when integration is enabled', () {
      final reason = integrationSkipReason(
        env: const {integrationEnabledEnv: '1'},
        requiredEnv: [electrumUrlEnv, esploraUrlEnv],
      );

      expect(reason, isNotNull);
      expect(reason, contains(electrumUrlEnv));
      expect(reason, contains(esploraUrlEnv));
    });

    test(
      'builds and disposes clients from env configuration',
      () {
        final disposers = <Disposer>[];

        final electrum = buildElectrumClientFromEnv();
        addDisposer(disposers, electrum.dispose);

        final esplora = buildEsploraClientFromEnv();
        addDisposer(disposers, esplora.dispose);

        expect(electrum, isNotNull);
        expect(esplora, isNotNull);

        disposeAll(disposers);
      },
      skip: integrationSkipReason(requiredEnv: [electrumUrlEnv, esploraUrlEnv]),
    );
  });
}
