import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/blockchain_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlockchainService.createClient', () {
    test('signet routes through the Electrum factory', () {
      final client = BlockchainService.createClient(
        WalletNetwork.signet,
        electrumFactory: (url) => _FakeBlockchainClient(
          backend: BlockchainBackend.electrum,
          url: url,
        ),
        esploraFactory: (url) => throw StateError('Unexpected Esplora factory'),
      );

      expect(client.backend, BlockchainBackend.electrum);
      expect((client as _FakeBlockchainClient).url, contains('60602'));
    });

    test('testnet routes through the Electrum factory', () {
      final client = BlockchainService.createClient(
        WalletNetwork.testnet,
        electrumFactory: (url) => _FakeBlockchainClient(
          backend: BlockchainBackend.electrum,
          url: url,
        ),
        esploraFactory: (url) => throw StateError('Unexpected Esplora factory'),
      );

      expect(client.backend, BlockchainBackend.electrum);
      expect((client as _FakeBlockchainClient).url, contains('60002'));
    });

    test('regtest routes through the Esplora factory', () {
      final client = BlockchainService.createClient(
        WalletNetwork.regtest,
        electrumFactory: (url) =>
            throw StateError('Unexpected Electrum factory'),
        esploraFactory: (url) =>
            _FakeBlockchainClient(backend: BlockchainBackend.esplora, url: url),
      );

      expect(client.backend, BlockchainBackend.esplora);
      expect((client as _FakeBlockchainClient).url, contains('localhost:3002'));
    });
  });

  group('BlockchainService.backendForNetwork', () {
    test('signet maps to Electrum', () {
      expect(
        BlockchainService.backendForNetwork(WalletNetwork.signet),
        BlockchainBackend.electrum,
      );
    });

    test('testnet maps to Electrum', () {
      expect(
        BlockchainService.backendForNetwork(WalletNetwork.testnet),
        BlockchainBackend.electrum,
      );
    });

    test('regtest maps to Esplora', () {
      expect(
        BlockchainService.backendForNetwork(WalletNetwork.regtest),
        BlockchainBackend.esplora,
      );
    });
  });

  group('BlockchainFeeNormalizer', () {
    test('electrum conversion scales BTC/kvB to sat/vB', () {
      expect(
        BlockchainFeeNormalizer.electrumToSatPerVb(1e-5),
        closeTo(1.0, 1e-9),
      );
      expect(
        BlockchainFeeNormalizer.electrumToSatPerVb(0.00002),
        closeTo(2.0, 1e-9),
      );
    });

    test('stableFeesFromElectrumEstimates uses fixed targets', () {
      final map = BlockchainFeeNormalizer.stableFeesFromElectrumEstimates(
        (n) => n * 1e-7,
      );
      expect(map.keys, orderedEquals([1, 3, 6, 12, 24]));
      expect(map[1]!, greaterThan(0));
    });

    test('stableFeesFromEsploraRaw interpolates missing targets', () {
      final raw = {2: 10.0, 25: 20.0};
      final stable = BlockchainFeeNormalizer.stableFeesFromEsploraRaw(raw);
      expect(stable.keys, orderedEquals([1, 3, 6, 12, 24]));
      expect(stable[1]!, closeTo(10.0, 0.001));
    });

    test('electrum subscribe helper exposes notification height', () {
      final header = Header(
        version: 1,
        prevBlockhash: BlockHash.fromString(
          hex:
              '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f',
        ),
        merkleRoot: TxMerkleNode.fromString(
          hex:
              '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b',
        ),
        time: 1231006505,
        bits: 0x1d00ffff,
        nonce: 2083236893,
      );
      final notification = HeaderNotification(height: 800000, header: header);
      expect(
        BlockchainFeeNormalizer.tipHeightFromElectrumSubscribe(notification),
        800000,
      );
    });

    test('empty Esplora map throws StateError', () {
      expect(
        () => BlockchainFeeNormalizer.stableFeesFromEsploraRaw({}),
        throwsStateError,
      );
    });
  });
}

final class _FakeBlockchainClient implements BlockchainClient {
  _FakeBlockchainClient({required this.backend, required this.url});

  @override
  final BlockchainBackend backend;
  final String url;

  @override
  void dispose() {}

  @override
  Map<int, double> getFeeEstimates() => const {1: 1.0};

  @override
  int getTipHeight() => 0;
}
