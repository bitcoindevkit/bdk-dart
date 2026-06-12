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

void _activateWallet(
  ProviderContainer container,
  Wallet wallet,
  WalletRecord record,
) {
  container.read(activeWalletProvider.notifier).set(wallet);
  container.read(activeWalletRecordProvider.notifier).set(record);
}

Future<void> _waitForActiveExternalIndex(
  ProviderContainer container,
  int expectedIndex,
) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    final wallet = container.read(activeWalletProvider);
    final index = wallet?.nextDerivationIndex(keychain: KeychainKind.external_);
    if (index == expectedIndex) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('Timed out waiting for active wallet external index $expectedIndex.');
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

      _activateWallet(container, wallet, record);

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

    test(
      'missing active wallet sets error then clears on activation',
      () async {
        final container = await _createContainer();
        final walletService = container.read(walletServiceProvider);

        await container
            .read(currentReceiveAddressProvider.notifier)
            .generateForActiveWallet();

        final errorState = container.read(currentReceiveAddressProvider);
        expect(errorState.address, isNull);
        expect(errorState.index, isNull);
        expect(errorState.errorMessage, contains('No active wallet'));
        expect(errorState.isGenerating, isFalse);

        final (record, wallet) = await walletService.createWallet(
          'Activation Wallet',
          WalletNetwork.testnet,
          ScriptType.p2wpkh,
        );
        _activateWallet(container, wallet, record);

        final activatedState = container.read(currentReceiveAddressProvider);
        expect(activatedState.walletId, isNull);
        expect(activatedState.address, isNull);
        expect(activatedState.index, isNull);
        expect(activatedState.errorMessage, isNull);
      },
    );

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

      _activateWallet(container, walletA, recordA);

      await container
          .read(currentReceiveAddressProvider.notifier)
          .generateForActiveWallet();
      expect(
        container.read(currentReceiveAddressProvider).walletId,
        recordA.id,
      );

      _activateWallet(container, walletB, recordB);

      final state = container.read(currentReceiveAddressProvider);
      expect(state.walletId, isNull);
      expect(state.address, isNull);
      expect(state.index, isNull);
      expect(state.errorMessage, isNull);
    });

    test(
      'stale completion caches result and restores it on reactivation',
      () async {
        final gate = Completer<void>();
        addTearDown(() {
          if (!gate.isCompleted) gate.complete();
        });

        late String gatedWalletId;
        final container = await _createContainer(
          walletServiceFactory: (storage) => _ControllableWalletService(
            storage: storage,
            uuid: const Uuid(),
            generateAddressOverride: (record) async {
              if (record.id == gatedWalletId) {
                await gate.future;
              }
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
        gatedWalletId = recordA.id;

        _activateWallet(container, walletA, recordA);

        final generateFuture = container
            .read(currentReceiveAddressProvider.notifier)
            .generateForActiveWallet();
        expect(
          container.read(currentReceiveAddressProvider).isGenerating,
          isTrue,
        );

        _activateWallet(container, walletB, recordB);

        gate.complete();
        await generateFuture;

        final staleState = container.read(currentReceiveAddressProvider);
        expect(staleState.walletId, isNull);
        expect(staleState.address, isNull);
        expect(staleState.index, isNull);
        expect(staleState.errorMessage, isNull);
        expect(container.read(activeWalletRecordProvider)?.id, recordB.id);
        expect(
          identical(container.read(activeWalletProvider), walletB),
          isTrue,
        );

        final reactivatedWalletA = await walletService.loadWalletFromRecord(
          recordA,
        );
        _activateWallet(container, reactivatedWalletA, recordA);

        final restoredState = container.read(currentReceiveAddressProvider);
        expect(restoredState.walletId, recordA.id);
        expect(restoredState.address, isNotEmpty);
        expect(restoredState.index, 0);
        expect(restoredState.errorMessage, isNull);
        await _waitForActiveExternalIndex(container, 1);
        expect(
          identical(container.read(activeWalletProvider), reactivatedWalletA),
          isTrue,
        );
      },
    );

    test('wallet B generation is not blocked by wallet A in flight', () async {
      final gate = Completer<void>();
      addTearDown(() {
        if (!gate.isCompleted) gate.complete();
      });

      late String gatedWalletId;
      final container = await _createContainer(
        walletServiceFactory: (storage) => _ControllableWalletService(
          storage: storage,
          uuid: const Uuid(),
          generateAddressOverride: (record) async {
            if (record.id == gatedWalletId) {
              await gate.future;
            }
            return WalletService(
              storage: storage,
              uuid: const Uuid(),
            ).generateAddress(record);
          },
        ),
      );
      final walletService = container.read(walletServiceProvider);

      final (recordA, walletA) = await walletService.createWallet(
        'In Flight A',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      final (recordB, walletB) = await walletService.createWallet(
        'In Flight B',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      gatedWalletId = recordA.id;

      _activateWallet(container, walletA, recordA);
      final walletAFuture = container
          .read(currentReceiveAddressProvider.notifier)
          .generateForActiveWallet();

      _activateWallet(container, walletB, recordB);
      await container
          .read(currentReceiveAddressProvider.notifier)
          .generateForActiveWallet();

      final walletBState = container.read(currentReceiveAddressProvider);
      expect(walletBState.walletId, recordB.id);
      expect(walletBState.address, isNotEmpty);
      expect(walletBState.index, 0);
      expect(
        container
            .read(activeWalletProvider)
            ?.nextDerivationIndex(keychain: KeychainKind.external_),
        1,
      );

      gate.complete();
      await walletAFuture;

      final finalState = container.read(currentReceiveAddressProvider);
      expect(finalState.walletId, recordB.id);
      expect(finalState.address, isNotEmpty);
      expect(finalState.index, 0);
    });

    test('service failure publishes error for the active wallet', () async {
      var shouldThrow = false;
      final container = await _createContainer(
        walletServiceFactory: (storage) => _ControllableWalletService(
          storage: storage,
          uuid: const Uuid(),
          generateAddressOverride: (record) async {
            if (shouldThrow) {
              throw StateError('boom');
            }
            return WalletService(
              storage: storage,
              uuid: const Uuid(),
            ).generateAddress(record);
          },
        ),
      );
      final walletService = container.read(walletServiceProvider);

      final (record, wallet) = await walletService.createWallet(
        'Failure Wallet',
        WalletNetwork.testnet,
        ScriptType.p2wpkh,
      );
      _activateWallet(container, wallet, record);
      shouldThrow = true;

      await container
          .read(currentReceiveAddressProvider.notifier)
          .generateForActiveWallet();

      final state = container.read(currentReceiveAddressProvider);
      expect(state.walletId, record.id);
      expect(state.errorMessage, contains('boom'));
      expect(state.isGenerating, isFalse);
    });

    test(
      'duplicate calls while in flight are dropped for the same wallet',
      () async {
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

        _activateWallet(container, wallet, record);

        final notifier = container.read(currentReceiveAddressProvider.notifier);
        final firstFuture = notifier.generateForActiveWallet();
        await notifier.generateForActiveWallet();
        await notifier.generateForActiveWallet();

        gate.complete();
        await firstFuture;

        expect(generateCalls, 1);
        expect(container.read(currentReceiveAddressProvider).index, 0);
      },
    );
  });
}
