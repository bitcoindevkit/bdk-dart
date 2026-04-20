import 'package:uuid/uuid.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

late StorageService storageService;
late WalletService walletService;

const _valid12WordPhrase =
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon about';
const _valid24WordPhrase =
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon abandon abandon abandon abandon art';
const _invalidChecksumPhrase =
    'abandon abandon abandon abandon abandon abandon abandon abandon '
    'abandon abandon abandon ability';

Future<void> _initServices() async {
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  storageService = StorageService(prefs: prefs);
  walletService = WalletService(storage: storageService, uuid: const Uuid());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletService.validateRecoveryPhrase()', () {
    setUp(_initServices);

    test('returns canonical normalized string for a valid 12-word phrase', () {
      expect(
        walletService.validateRecoveryPhrase(_valid12WordPhrase),
        _valid12WordPhrase,
      );
    });

    test('returns canonical normalized string for a valid 24-word phrase', () {
      expect(
        walletService.validateRecoveryPhrase(_valid24WordPhrase),
        _valid24WordPhrase,
      );
    });

    test('throws ArgumentError for empty or whitespace-only phrase', () {
      expect(
        () => walletService.validateRecoveryPhrase(''),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            'Recovery phrase cannot be empty.',
          ),
        ),
      );

      expect(
        () => walletService.validateRecoveryPhrase('   \n\t   '),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            'Recovery phrase cannot be empty.',
          ),
        ),
      );
    });

    test('throws ArgumentError for invalid word count', () {
      expect(
        () => walletService.validateRecoveryPhrase(
          'abandon abandon abandon abandon abandon abandon '
          'abandon abandon abandon abandon abandon',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('12 or 24 words'),
          ),
        ),
      );
    });

    test('throws ArgumentError when a word is not in the BIP-39 list', () {
      expect(
        () => walletService.validateRecoveryPhrase(
          'abandon abandon abandon abandon abandon abandon '
          'abandon abandon abandon abandon abandon zzzzz',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('zzzzz'),
          ),
        ),
      );
    });

    test('throws ArgumentError for invalid checksum', () {
      expect(
        () => walletService.validateRecoveryPhrase(_invalidChecksumPhrase),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('checksum is invalid'),
          ),
        ),
      );
    });

    test('normalizes mixed case and extra whitespace once', () {
      expect(
        walletService.validateRecoveryPhrase(
          '  ABANDON abandon  abandon \n abandon\tabandon abandon '
          'abandon abandon abandon abandon abandon ABOUT  ',
        ),
        _valid12WordPhrase,
      );
    });
  });
}
