import 'package:bdk_dart/bdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';

const _testExtendedPrivKey =
    'tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B';

Wallet _createTestWallet() {
  final descriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
    network: Network.testnet,
  );
  final changeDescriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
    network: Network.testnet,
  );
  return Wallet(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    network: Network.testnet,
    persister: Persister.newInMemory(),
    lookahead: 25,
  );
}

void main() {
  group('ActiveWalletNotifier', () {
    test('set() with same wallet twice keeps state and avoids disposal', () {
      var disposeCalls = 0;
      final container = ProviderContainer(
        overrides: [
          walletDisposerProvider.overrideWithValue((wallet) {
            disposeCalls += 1;
            wallet.dispose();
          }),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(activeWalletProvider.notifier);
      final wallet = _createTestWallet();

      notifier.set(wallet);
      notifier.set(wallet);

      expect(disposeCalls, 0);
      expect(identical(container.read(activeWalletProvider), wallet), isTrue);
    });

    test('disposes current wallet when provider is disposed', () {
      var disposeCalls = 0;
      final container = ProviderContainer(
        overrides: [
          walletDisposerProvider.overrideWithValue((wallet) {
            disposeCalls += 1;
            wallet.dispose();
          }),
        ],
      );

      final notifier = container.read(activeWalletProvider.notifier);
      notifier.set(_createTestWallet());

      container.dispose();

      expect(disposeCalls, 1);
    });

    test('clear() disposes wallet and sets state to null', () {
      var disposeCalls = 0;
      final container = ProviderContainer(
        overrides: [
          walletDisposerProvider.overrideWithValue((wallet) {
            disposeCalls += 1;
            wallet.dispose();
          }),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(activeWalletProvider.notifier);
      notifier.set(_createTestWallet());

      notifier.clear();

      expect(disposeCalls, 1);
      expect(container.read(activeWalletProvider), isNull);
    });
  });
}
