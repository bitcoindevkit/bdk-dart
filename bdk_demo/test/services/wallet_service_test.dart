import 'dart:io';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

late StorageService storageService;
late WalletService walletService;
Directory? _documentsRoot;

Future<void> _initServices() async {
  _documentsRoot = await Directory.systemTemp.createTemp(
    'wallet_service_test_',
  );
  WalletStoragePaths.setDocumentsRootOverride(_documentsRoot);
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  storageService = StorageService(prefs: prefs);
  walletService = WalletService(storage: storageService, uuid: const Uuid());
}

Future<void> _tearDownServices() async {
  WalletStoragePaths.setDocumentsRootOverride(null);
  final root = _documentsRoot;
  _documentsRoot = null;
  if (root != null && root.existsSync()) {
    await root.delete(recursive: true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletService.createWallet()', () {
    setUp(_initServices);
    tearDown(_tearDownServices);

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

      final sqlitePath = await WalletStoragePaths.sqlitePathForWallet(
        record.id,
      );
      expect(File(sqlitePath).existsSync(), isTrue);

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

      final sqlitePath = await WalletStoragePaths.sqlitePathForWallet(
        record.id,
      );
      expect(File(sqlitePath).existsSync(), isTrue);

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

    test(
      'persistence failure disposes wallet and deletes SQLite folder',
      () async {
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

        final walletsDir = Directory('${_documentsRoot!.path}/wallets');
        if (walletsDir.existsSync()) {
          expect(walletsDir.listSync(), isEmpty);
        }
      },
    );

    test(
      'wallet.persist returning false surfaces failure and cleans SQLite',
      () async {
        SharedPreferences.setMockInitialValues({});
        FlutterSecureStorage.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = StorageService(prefs: prefs);

        final service = WalletService(
          storage: storage,
          uuid: const Uuid(),
          persistRunner: (wallet, persister) async => false,
          walletLoadRunner:
              ({
                required descriptor,
                required changeDescriptor,
                required persister,
                required lookahead,
              }) => throw StateError('Forced verification load failure.'),
        );

        await expectLater(
          () => service.createWallet(
            'Persist False',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
          ),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('SQLite persistence'),
            ),
          ),
        );

        expect(storage.getWalletRecords(), isEmpty);
        final walletsDir = Directory('${_documentsRoot!.path}/wallets');
        if (walletsDir.existsSync()) {
          expect(walletsDir.listSync(), isEmpty);
        }
      },
    );

    test(
      'wallet.persist throwing cleans SQLite and does not save metadata',
      () async {
        SharedPreferences.setMockInitialValues({});
        FlutterSecureStorage.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = StorageService(prefs: prefs);

        final service = WalletService(
          storage: storage,
          uuid: const Uuid(),
          persistRunner: (wallet, persister) async =>
              throw StateError('Persist boom.'),
        );

        await expectLater(
          () => service.createWallet(
            'Persist Throw',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
          ),
          throwsStateError,
        );

        expect(storage.getWalletRecords(), isEmpty);
      },
    );
  });

  group('WalletService.loadWalletFromRecord()', () {
    setUp(_initServices);
    tearDown(_tearDownServices);

    test('success path: loaded wallet can derive address', () async {
      final (record, originalWallet) = await walletService.createWallet(
        'Load Test',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      originalWallet.dispose();

      final sqlitePath = await WalletStoragePaths.sqlitePathForWallet(
        record.id,
      );
      expect(File(sqlitePath).existsSync(), isTrue);

      final loadedWallet = await walletService.loadWalletFromRecord(record);

      final addressInfo = loadedWallet.nextUnusedAddress(
        keychain: KeychainKind.external_,
      );
      expect(addressInfo.address.toString(), isNotEmpty);

      loadedWallet.dispose();
    });

    test('existing SQLite path uses Wallet.load semantics', () async {
      final (record, originalWallet) = await walletService.createWallet(
        'Load Existing Sqlite',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      originalWallet.dispose();

      var loadCalls = 0;
      final service = WalletService(
        storage: storageService,
        uuid: const Uuid(),
        walletLoadRunner:
            ({
              required descriptor,
              required changeDescriptor,
              required persister,
              required lookahead,
            }) {
              loadCalls += 1;
              return Wallet.load(
                descriptor: descriptor,
                changeDescriptor: changeDescriptor,
                persister: persister,
                lookahead: lookahead,
              );
            },
      );

      final loadedWallet = await service.loadWalletFromRecord(record);
      expect(loadCalls, 1);
      loadedWallet.dispose();
    });

    test('legacy migration seeds SQLite when file is missing', () async {
      final (record, originalWallet) = await walletService.createWallet(
        'Legacy Migrate',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      originalWallet.dispose();

      final sqlitePath = await WalletStoragePaths.sqlitePathForWallet(
        record.id,
      );
      await File(sqlitePath).delete();
      expect(File(sqlitePath).existsSync(), isFalse);

      final loadedWallet = await walletService.loadWalletFromRecord(record);
      expect(File(sqlitePath).existsSync(), isTrue);

      final addressInfo = loadedWallet.nextUnusedAddress(
        keychain: KeychainKind.external_,
      );
      expect(addressInfo.address.toString(), isNotEmpty);

      loadedWallet.dispose();
    });

    test(
      'corrupt SQLite is deleted and wallet is reseeded from descriptors',
      () async {
        final (record, originalWallet) = await walletService.createWallet(
          'Corrupt Db',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        originalWallet.dispose();

        final sqlitePath = await WalletStoragePaths.sqlitePathForWallet(
          record.id,
        );
        await File(sqlitePath).writeAsBytes([0, 1, 2, 3]);

        final loadedWallet = await walletService.loadWalletFromRecord(record);
        expect(File(sqlitePath).existsSync(), isTrue);

        final addressInfo = loadedWallet.nextUnusedAddress(
          keychain: KeychainKind.external_,
        );
        expect(addressInfo.address.toString(), isNotEmpty);

        loadedWallet.dispose();
      },
    );

    test(
      'failed reseed preserves existing SQLite data until replacement succeeds',
      () async {
        final (record, originalWallet) = await walletService.createWallet(
          'Preserve Existing Db',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        originalWallet.dispose();

        final sqlitePath = await WalletStoragePaths.sqlitePathForWallet(
          record.id,
        );
        final originalFile = File(sqlitePath);
        expect(originalFile.existsSync(), isTrue);
        final originalBytes = await originalFile.readAsBytes();

        final service = WalletService(
          storage: storageService,
          uuid: const Uuid(),
          walletLoadRunner:
              ({
                required descriptor,
                required changeDescriptor,
                required persister,
                required lookahead,
              }) => throw StateError('Forced load failure for test.'),
          persistRunner: (wallet, persister) async => false,
        );

        await expectLater(
          () => service.loadWalletFromRecord(record),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('SQLite persistence'),
            ),
          ),
        );

        expect(originalFile.existsSync(), isTrue);
        expect(await originalFile.readAsBytes(), originalBytes);
      },
    );

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
    tearDown(_tearDownServices);

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
