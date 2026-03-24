import 'package:uuid/uuid.dart';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

late StorageService storageService;
late WalletService walletService;

Future<void> _initServices() async {
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  storageService = StorageService(prefs: prefs);
  walletService = WalletService(storage: storageService, uuid: const Uuid());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletService.createWallet()', () {
    setUp(_initServices);

    test('success path with P2WPKH returns record and wallet', () async {
      final (record, wallet) = await walletService.createWallet(
        'My Testnet Wallet',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      expect(record.name, 'My Testnet Wallet');
      expect(record.network, WalletNetwork.testnet);
      expect(record.scriptType, ScriptType.p2wpkh);
      expect(record.id, isNotEmpty);
      expect(record.fullScanCompleted, isFalse);

      final secrets = await storageService.getSecrets(record.id);
      expect(secrets, isNotNull);
      expect(secrets!.descriptor, isNotEmpty);
      expect(secrets.changeDescriptor, isNotEmpty);
      expect(secrets.recoveryPhrase, isNotEmpty);

      wallet.dispose();
    });

    test('success path with P2TR returns record and wallet', () async {
      final (record, wallet) = await walletService.createWallet(
        'Taproot Wallet',
        WalletNetwork.testnet,
        ScriptType.p2tr,
      );

      expect(record.name, 'Taproot Wallet');
      expect(record.network, WalletNetwork.testnet);
      expect(record.scriptType, ScriptType.p2tr);
      expect(record.id, isNotEmpty);
      expect(record.fullScanCompleted, isFalse);

      final secrets = await storageService.getSecrets(record.id);
      expect(secrets, isNotNull);

      wallet.dispose();
    });

    test('empty name throws ArgumentError', () async {
      expect(
        () => walletService.createWallet(
          '',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        ),
        throwsArgumentError,
      );

      expect(
        () => walletService.createWallet(
          '   ',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        ),
        throwsArgumentError,
      );

      expect(storageService.getWalletRecords(), isEmpty);
    });

    test('duplicate name (case-insensitive) throws StateError', () async {
      final (_, wallet) = await walletService.createWallet(
        'Duplicate Test',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      wallet.dispose();

      expect(
        () => walletService.createWallet(
          'duplicate test',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        ),
        throwsStateError,
      );

      expect(storageService.getWalletRecords(), hasLength(1));
    });

    test('ScriptType.unknown throws ArgumentError', () async {
      expect(
        () => walletService.createWallet(
          'Unknown Script',
          WalletNetwork.testnet,
          ScriptType.unknown,
        ),
        throwsArgumentError,
      );

      expect(storageService.getWalletRecords(), isEmpty);
    });

    test('persistence failure disposes wallet before rethrow', () async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      var disposeCalls = 0;
      final failingStorage = _FailingStorageService(prefs: prefs);
      final service = WalletService(
        storage: failingStorage,
        uuid: const Uuid(),
        walletDisposer: (wallet) {
          disposeCalls += 1;
          wallet.dispose();
        },
      );

      await expectLater(
        () => service.createWallet(
          'Fail Wallet',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Forced persistence failure'),
          ),
        ),
      );

      expect(disposeCalls, 1);
    });
  });

  group('WalletService.loadWalletFromRecord()', () {
    setUp(_initServices);

    test('success path: loaded wallet can derive address', () async {
      final (record, originalWallet) = await walletService.createWallet(
        'Load Test',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      originalWallet.dispose();

      final loadedWallet = await walletService.loadWalletFromRecord(record);

      final addressInfo = loadedWallet.nextUnusedAddress(
        keychain: KeychainKind.external_,
      );
      expect(addressInfo.address.toString(), isNotEmpty);

      loadedWallet.dispose();
    });

    test('missing secrets throws StateError', () async {
      final orphanRecord = WalletRecord(
        id: 'non-existent-id',
        name: 'Ghost Wallet',
        network: WalletNetwork.testnet,
        scriptType: ScriptType.p2wpkh,
      );

      expect(
        () => walletService.loadWalletFromRecord(orphanRecord),
        throwsStateError,
      );
    });
  });

  group('Descriptor persistence round-trip', () {
    setUp(_initServices);

    test(
      'P2WPKH secrets contain wpkh descriptor with secret key material',
      () async {
        final (record, wallet) = await walletService.createWallet(
          'Round Trip WPKH',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        wallet.dispose();

        final secrets = await storageService.getSecrets(record.id);
        expect(secrets, isNotNull);
        expect(secrets!.descriptor, contains('wpkh('));
        expect(secrets.descriptor, contains('tprv'));
        expect(secrets.changeDescriptor, contains('wpkh('));
        expect(secrets.changeDescriptor, contains('tprv'));
      },
    );

    test(
      'P2TR secrets contain tr descriptor with secret key material',
      () async {
        final (record, wallet) = await walletService.createWallet(
          'Round Trip TR',
          WalletNetwork.testnet,
          ScriptType.p2tr,
        );
        wallet.dispose();

        final secrets = await storageService.getSecrets(record.id);
        expect(secrets, isNotNull);
        expect(secrets!.descriptor, contains('tr('));
        expect(secrets.descriptor, contains('tprv'));
        expect(secrets.changeDescriptor, contains('tr('));
        expect(secrets.changeDescriptor, contains('tprv'));
      },
    );
  });
}

class _FailingStorageService extends StorageService {
  _FailingStorageService({required super.prefs});

  @override
  Future<void> addWalletRecord(
    WalletRecord record,
    WalletSecrets secrets,
  ) async {
    throw StateError('Forced persistence failure for test.');
  }
}

