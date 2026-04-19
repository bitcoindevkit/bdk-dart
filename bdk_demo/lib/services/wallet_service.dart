import 'package:bdk_dart/bdk.dart';
import 'package:uuid/uuid.dart';

import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_network_mapper.dart';

typedef WalletDisposer = void Function(Wallet wallet);

class WalletService {
  final StorageService _storage;
  final Uuid _uuid;
  final WalletDisposer _walletDisposer;

  WalletService({
    required StorageService storage,
    required Uuid uuid,
    WalletDisposer? walletDisposer,
  }) : _storage = storage,
       _uuid = uuid,
       _walletDisposer = walletDisposer ?? _defaultDisposer;

  static void _defaultDisposer(Wallet wallet) => wallet.dispose();

  Future<(WalletRecord, Wallet)> createWallet(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
  ) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Wallet name must not be empty.');
    }

    final existing = _storage.getWalletRecords();
    final duplicate = existing.any(
      (r) => r.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicate) {
      throw StateError('A wallet named "$trimmedName" already exists.');
    }

    final bdkNetwork = walletNetwork.toBdkNetwork();

    final mnemonic = Mnemonic(wordCount: WordCount.words12);
    final secretKey = DescriptorSecretKey(
      network: bdkNetwork,
      mnemonic: mnemonic,
      password: null,
    );

    final descriptor = _deriveDescriptor(
      secretKey,
      KeychainKind.external_,
      bdkNetwork,
      scriptType,
    );
    final changeDescriptor = _deriveDescriptor(
      secretKey,
      KeychainKind.internal,
      bdkNetwork,
      scriptType,
    );

    final persister = Persister.newInMemory();
    final wallet = Wallet(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      network: bdkNetwork,
      persister: persister,
      lookahead: AppConstants.walletLookahead,
    );

    final record = WalletRecord(
      id: _uuid.v4(),
      name: trimmedName,
      network: walletNetwork,
      scriptType: scriptType,
    );

    final secrets = WalletSecrets(
      descriptor: descriptor.toStringWithSecret(),
      changeDescriptor: changeDescriptor.toStringWithSecret(),
      recoveryPhrase: mnemonic.toString(),
    );

    try {
      await _storage.addWalletRecord(record, secrets);
    } catch (_) {
      _walletDisposer(wallet);
      rethrow;
    }

    return (record, wallet);
  }

  Future<Wallet> loadWalletFromRecord(WalletRecord record) async {
    final secrets = await _storage.getSecrets(record.id);
    if (secrets == null) {
      throw StateError(
        'No secrets found for wallet "${record.name}" (${record.id}). '
        'Cannot reconstruct wallet.',
      );
    }

    final bdkNetwork = record.network.toBdkNetwork();

    final descriptor = Descriptor(
      descriptor: secrets.descriptor,
      network: bdkNetwork,
    );
    final changeDescriptor = Descriptor(
      descriptor: secrets.changeDescriptor,
      network: bdkNetwork,
    );

    final persister = Persister.newInMemory();
    return Wallet(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      network: bdkNetwork,
      persister: persister,
      lookahead: AppConstants.walletLookahead,
    );
  }

  Descriptor _deriveDescriptor(
    DescriptorSecretKey secretKey,
    KeychainKind keychainKind,
    Network network,
    ScriptType scriptType,
  ) {
    return switch (scriptType) {
      ScriptType.p2wpkh => Descriptor.newBip84(
        secretKey: secretKey,
        keychainKind: keychainKind,
        network: network,
      ),
      ScriptType.p2tr => Descriptor.newBip86(
        secretKey: secretKey,
        keychainKind: keychainKind,
        network: network,
      ),
      ScriptType.unknown => throw ArgumentError(
        'Unsupported script type: $scriptType',
      ),
    };
  }
}
