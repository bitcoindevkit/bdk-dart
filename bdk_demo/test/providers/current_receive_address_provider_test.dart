import 'dart:async';
import 'dart:io';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/address_providers.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class _ControllableWalletService extends WalletService {
  _ControllableWalletService({
    required super.storage,
    required super.uuid,
    this.generateAddressOverride,
  });

  final Future<(AddressInfo, Wallet)> Function(WalletRecord record)?
  generateAddressOverride;

  @override
  Future<(AddressInfo, Wallet)> generateAddress(WalletRecord record) {
    final override = generateAddressOverride;
    if (override != null) {
      return override(record);
    }
    return super.generateAddress(record);
  }
}

Future<ProviderContainer> _createContainer({
  WalletService Function(StorageService storage)? walletServiceFactory,
}) async {
  final dir = await Directory.systemTemp.createTemp(
    'receive_address_provider_test_',
  );
  WalletStoragePaths.setDocumentsRootOverride(dir);
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs: prefs);
  final service =
      walletServiceFactory?.call(storage) ??
      WalletService(storage: storage, uuid: const Uuid());

  final container = ProviderContainer(
    overrides: [
      storageServiceProvider.overrideWithValue(storage),
      walletServiceProvider.overrideWithValue(service),
    ],
  );
  addTearDown(() async {
    container.dispose();
    WalletStoragePaths.setDocumentsRootOverride(null);
    if (dir.existsSync()) await dir.delete(recursive: true);
  });
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CurrentReceiveAddressNotifier', () {
    test('generates and stores receive address for active wallet', () async {
      final container = await _createContainer();
      final walletService = container.read(walletServiceProvider);

      final (record, wallet) = await walletService.createWallet(
        'Receive Provider',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(activeWalletRecordProvider.notifier).set(record);
      container.read(activeWalletProvider.notifier).set(wallet);

      await container
          .read(currentReceiveAddressProvider.notifier)
          .generateForActiveWallet();

      final state = container.read(currentReceiveAddressProvider);
      expect(state.walletId, record.id);
      expect(state.index, 0);
      expect(state.address, isNotEmpty);
      expect(state.isGenerating, isFalse);
      expect(state.errorMessage, isNull);
      expect(
        container
            .read(activeWalletProvider)
            ?.nextDerivationIndex(keychain: KeychainKind.external_),
        1,
      );
    });

    test('missing active wallet sets error and does not generate', () async {
      final container = await _createContainer();

      await container
          .read(currentReceiveAddressProvider.notifier)
          .generateForActiveWallet();

      final state = container.read(currentReceiveAddressProvider);
      expect(state.address, isNull);
      expect(state.index, isNull);
      expect(state.errorMessage, contains('No active wallet'));
      expect(state.isGenerating, isFalse);
    });

    test('switching wallets clears existing receive address state', () async {
      final container = await _createContainer();
      final walletService = container.read(walletServiceProvider);

      final (recordA, walletA) = await walletService.createWallet(
        'Receive A',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      final (recordB, walletB) = await walletService.createWallet(
        'Receive B',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(activeWalletRecordProvider.notifier).set(recordA);
      container.read(activeWalletProvider.notifier).set(walletA);

      await container
          .read(currentReceiveAddressProvider.notifier)
          .generateForActiveWallet();
      expect(
        container.read(currentReceiveAddressProvider).walletId,
        recordA.id,
      );

      container.read(activeWalletRecordProvider.notifier).set(recordB);
      container.read(activeWalletProvider.notifier).set(walletB);

      expect(
        container.read(currentReceiveAddressProvider),
        ReceiveAddressState.empty,
      );
    });

    test(
      'stale completion does not publish address after wallet switch',
      () async {
        final gate = Completer<void>();
        addTearDown(() {
          if (!gate.isCompleted) gate.complete();
        });

        final container = await _createContainer(
          walletServiceFactory: (storage) => _ControllableWalletService(
            storage: storage,
            uuid: const Uuid(),
            generateAddressOverride: (record) async {
              await gate.future;
              return WalletService(
                storage: storage,
                uuid: const Uuid(),
              ).generateAddress(record);
            },
          ),
        );
        final walletService = container.read(walletServiceProvider);

        final (recordA, walletA) = await walletService.createWallet(
          'Stale A',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        final (recordB, walletB) = await walletService.createWallet(
          'Stale B',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );

        container.read(activeWalletRecordProvider.notifier).set(recordA);
        container.read(activeWalletProvider.notifier).set(walletA);

        final generateFuture = container
            .read(currentReceiveAddressProvider.notifier)
            .generateForActiveWallet();
        expect(
          container.read(currentReceiveAddressProvider).isGenerating,
          isTrue,
        );

        container.read(activeWalletRecordProvider.notifier).set(recordB);
        container.read(activeWalletProvider.notifier).set(walletB);

        gate.complete();
        await generateFuture;

        expect(
          container.read(currentReceiveAddressProvider),
          ReceiveAddressState.empty,
        );
        expect(container.read(activeWalletRecordProvider)?.id, recordB.id);
      },
    );

    test('duplicate calls while in flight are dropped', () async {
      final gate = Completer<void>();
      addTearDown(() {
        if (!gate.isCompleted) gate.complete();
      });

      var generateCalls = 0;
      final container = await _createContainer(
        walletServiceFactory: (storage) => _ControllableWalletService(
          storage: storage,
          uuid: const Uuid(),
          generateAddressOverride: (record) async {
            generateCalls += 1;
            await gate.future;
            return WalletService(
              storage: storage,
              uuid: const Uuid(),
            ).generateAddress(record);
          },
        ),
      );
      final walletService = container.read(walletServiceProvider);

      final (record, wallet) = await walletService.createWallet(
        'Duplicate Guard',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );

      container.read(activeWalletRecordProvider.notifier).set(record);
      container.read(activeWalletProvider.notifier).set(wallet);

      final notifier = container.read(currentReceiveAddressProvider.notifier);
      final firstFuture = notifier.generateForActiveWallet();
      await notifier.generateForActiveWallet();
      await notifier.generateForActiveWallet();

      gate.complete();
      await firstFuture;

      expect(generateCalls, 1);
      expect(container.read(currentReceiveAddressProvider).index, 0);
    });
  });
}
