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

const _valid12WordPhrase =
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon about';

const _invalidChecksumPhrase =
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon ability';

Future<void> _initServices() async {
  _documentsRoot = await Directory.systemTemp.createTemp(
    'recovery_service_test_',
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

(String, String) _publicBip84Descriptors(
  WalletNetwork walletNetwork,
  String phrase,
) {
  final bdkNetwork = switch (walletNetwork) {
    WalletNetwork.signet => Network.signet,
    WalletNetwork.testnet => Network.testnet,
    WalletNetwork.regtest => Network.regtest,
  };
  final mnemonic = Mnemonic.fromString(mnemonic: phrase);
  final secretKey = DescriptorSecretKey(
    network: bdkNetwork,
    mnemonic: mnemonic,
    password: null,
  );
  final publicKey = secretKey.asPublic();
  final fingerprint = publicKey.masterFingerprint();

  final descriptor = Descriptor.newBip84Public(
    publicKey: publicKey,
    fingerprint: fingerprint,
    keychainKind: KeychainKind.external_,
    network: bdkNetwork,
  );
  final changeDescriptor = Descriptor.newBip84Public(
    publicKey: publicKey,
    fingerprint: fingerprint,
    keychainKind: KeychainKind.internal,
    network: bdkNetwork,
  );

  return (descriptor.toString(), changeDescriptor.toString());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletService recovery', () {
    setUp(_initServices);
    tearDown(_tearDownServices);

    group('recoverFromPhrase', () {
      test('success path persists normalized phrase and metadata', () async {
        final (record, wallet) = await walletService.recoverFromPhrase(
          'Recovered Phrase Wallet',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
          '  ${_valid12WordPhrase.toUpperCase().replaceAll(' ', '  ')}  ',
        );

        expect(record.name, 'Recovered Phrase Wallet');
        expect(record.network, WalletNetwork.testnet);
        expect(record.scriptType, ScriptType.p2wpkh);
        expect(record.fullScanCompleted, isFalse);

        final secrets = await storageService.getSecrets(record.id);
        expect(secrets, isNotNull);
        expect(secrets!.recoveryPhrase, _valid12WordPhrase);
        expect(secrets.descriptor, isNotEmpty);
        expect(secrets.changeDescriptor, isNotEmpty);

        wallet.dispose();
      });

      test('invalid checksum phrase throws ArgumentError', () async {
        expect(
          () => walletService.recoverFromPhrase(
            'Bad Phrase Wallet',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
            _invalidChecksumPhrase,
          ),
          throwsArgumentError,
        );
        expect(storageService.getWalletRecords(), isEmpty);
      });

      test('empty name throws ArgumentError', () async {
        expect(
          () => walletService.recoverFromPhrase(
            '   ',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
            _valid12WordPhrase,
          ),
          throwsArgumentError,
        );
      });

      test('duplicate name throws StateError', () async {
        final (_, wallet) = await walletService.recoverFromPhrase(
          'Dup',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
          _valid12WordPhrase,
        );
        wallet.dispose();

        expect(
          () => walletService.recoverFromPhrase(
            'dup',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
            _valid12WordPhrase,
          ),
          throwsStateError,
        );
      });

      test('ScriptType.unknown throws ArgumentError', () async {
        expect(
          () => walletService.recoverFromPhrase(
            'X',
            WalletNetwork.testnet,
            ScriptType.unknown,
            _valid12WordPhrase,
          ),
          throwsArgumentError,
        );
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
          () => service.recoverFromPhrase(
            'Fail Recover',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
            _valid12WordPhrase,
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

      test('round-trip reload derives address', () async {
        final (record, wallet) = await walletService.recoverFromPhrase(
          'Round Trip Recover',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
          _valid12WordPhrase,
        );
        wallet.dispose();

        final loaded = await walletService.loadWalletFromRecord(record);
        final addressInfo = loaded.nextUnusedAddress(
          keychain: KeychainKind.external_,
        );
        expect(addressInfo.address.toString(), isNotEmpty);
        loaded.dispose();
      });

      test(
        'missing SQLite is reseeded on reload after phrase recovery',
        () async {
          final (record, wallet) = await walletService.recoverFromPhrase(
            'Reseed Recover',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
            _valid12WordPhrase,
          );
          wallet.dispose();

          final sqlitePath = await WalletStoragePaths.sqlitePathForWallet(
            record.id,
          );
          await File(sqlitePath).delete();
          expect(File(sqlitePath).existsSync(), isFalse);

          final loaded = await walletService.loadWalletFromRecord(record);
          expect(File(sqlitePath).existsSync(), isTrue);
          loaded.dispose();
        },
      );
    });

    group('recoverFromDescriptors', () {
      test(
        'success path persists trimmed descriptors and unknown script type',
        () async {
          final (genRecord, genWallet) = await walletService.createWallet(
            'Generator',
            WalletNetwork.testnet,
            ScriptType.p2wpkh,
          );
          genWallet.dispose();

          final generated = await storageService.getSecrets(genRecord.id);
          expect(generated, isNotNull);

          final external = '  ${generated!.descriptor}  ';
          final change = '  ${generated.changeDescriptor}  ';

          final (record, wallet) = await walletService.recoverFromDescriptors(
            'Descriptor Recover',
            WalletNetwork.testnet,
            external,
            change,
          );

          expect(record.name, 'Descriptor Recover');
          expect(record.scriptType, ScriptType.unknown);
          expect(record.fullScanCompleted, isFalse);

          final secrets = await storageService.getSecrets(record.id);
          expect(secrets, isNotNull);
          expect(secrets!.recoveryPhrase, isEmpty);
          expect(secrets.descriptor, generated.descriptor);
          expect(secrets.changeDescriptor, generated.changeDescriptor);

          wallet.dispose();
        },
      );

      test(
        'watch-only descriptors round-trip through recovery and reload',
        () async {
          final (external, change) = _publicBip84Descriptors(
            WalletNetwork.testnet,
            _valid12WordPhrase,
          );

          expect(external, isNot(contains('tprv')));
          expect(change, isNot(contains('tprv')));

          final (record, wallet) = await walletService.recoverFromDescriptors(
            'Watch Only Descriptor Recover',
            WalletNetwork.testnet,
            '  $external  ',
            '  $change  ',
          );
          wallet.dispose();

          expect(record.scriptType, ScriptType.unknown);
          expect(record.fullScanCompleted, isFalse);

          final secrets = await storageService.getSecrets(record.id);
          expect(secrets, isNotNull);
          expect(secrets!.recoveryPhrase, isEmpty);
          expect(secrets.descriptor, external);
          expect(secrets.changeDescriptor, change);

          final loaded = await walletService.loadWalletFromRecord(record);
          final addressInfo = loaded.nextUnusedAddress(
            keychain: KeychainKind.external_,
          );
          expect(addressInfo.address.toString(), isNotEmpty);
          loaded.dispose();
        },
      );

      test('malformed descriptor throws DescriptorException', () async {
        expect(
          () => walletService.recoverFromDescriptors(
            'Bad Desc',
            WalletNetwork.testnet,
            'not-a-real-descriptor',
            'not-a-real-descriptor',
          ),
          throwsA(isA<DescriptorException>()),
        );
      });

      test('blank descriptor strings throw ArgumentError', () async {
        expect(
          () => walletService.recoverFromDescriptors(
            'Blank',
            WalletNetwork.testnet,
            '',
            'something',
          ),
          throwsArgumentError,
        );
        expect(
          () => walletService.recoverFromDescriptors(
            'Blank2',
            WalletNetwork.testnet,
            'something',
            '   ',
          ),
          throwsArgumentError,
        );
      });

      test('empty name throws ArgumentError', () async {
        final (genRecord, genWallet) = await walletService.createWallet(
          'G2',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        genWallet.dispose();
        final secrets = await storageService.getSecrets(genRecord.id);
        expect(secrets, isNotNull);

        expect(
          () => walletService.recoverFromDescriptors(
            '  ',
            WalletNetwork.testnet,
            secrets!.descriptor,
            secrets.changeDescriptor,
          ),
          throwsArgumentError,
        );
      });

      test('duplicate name throws StateError', () async {
        final (genRecord, genWallet) = await walletService.createWallet(
          'G3',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        genWallet.dispose();
        final secrets = await storageService.getSecrets(genRecord.id);
        expect(secrets, isNotNull);

        final (_, wallet) = await walletService.recoverFromDescriptors(
          'DupDesc',
          WalletNetwork.testnet,
          secrets!.descriptor,
          secrets.changeDescriptor,
        );
        wallet.dispose();

        expect(
          () => walletService.recoverFromDescriptors(
            'dupdesc',
            WalletNetwork.testnet,
            secrets.descriptor,
            secrets.changeDescriptor,
          ),
          throwsStateError,
        );
      });

      test('persistence failure disposes wallet before rethrow', () async {
        final (genRecord, genWallet) = await walletService.createWallet(
          'G4',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        genWallet.dispose();
        final secrets = await storageService.getSecrets(genRecord.id);
        expect(secrets, isNotNull);

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
          () => service.recoverFromDescriptors(
            'Fail Desc Recover',
            WalletNetwork.testnet,
            secrets!.descriptor,
            secrets.changeDescriptor,
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

      test('round-trip reload derives address', () async {
        final (genRecord, genWallet) = await walletService.createWallet(
          'G5',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        genWallet.dispose();
        final secrets = await storageService.getSecrets(genRecord.id);
        expect(secrets, isNotNull);

        final (record, wallet) = await walletService.recoverFromDescriptors(
          'Desc Round Trip',
          WalletNetwork.testnet,
          secrets!.descriptor,
          secrets.changeDescriptor,
        );
        wallet.dispose();

        final loaded = await walletService.loadWalletFromRecord(record);
        final addressInfo = loaded.nextUnusedAddress(
          keychain: KeychainKind.external_,
        );
        expect(addressInfo.address.toString(), isNotEmpty);
        loaded.dispose();
      });
    });
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
