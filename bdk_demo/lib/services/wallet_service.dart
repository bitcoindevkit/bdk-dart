import 'package:bdk_dart/bdk.dart';
import 'package:uuid/uuid.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/core/constants/bip39_wordlist.dart';
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

  String validateRecoveryPhrase(String phrase) {
    final normalized = phrase.trim().toLowerCase().split(RegExp(r'\s+')).join(' ');
    if (normalized.isEmpty) {
      throw ArgumentError('Recovery phrase cannot be empty.');
    }

    final words = normalized.split(' ');
    if (words.length != 12 && words.length != 24) {
      throw ArgumentError(
        'Recovery phrase must be 12 or 24 words (got ${words.length}).',
      );
    }

    for (var i = 0; i < words.length; i++) {
      if (!Bip39Wordlist.words.contains(words[i])) {
        throw ArgumentError(
          'Word ${i + 1} ("${words[i]}") is not a valid BIP-39 word.',
        );
      }
    }

    try {
      Mnemonic.fromString(mnemonic: normalized);
    } on Bip39Exception catch (error) {
      throw ArgumentError(_bip39ErrorMessage(error));
    }

    return normalized;
  }

  Future<(WalletRecord, Wallet)> createWallet(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
  ) async {
    final trimmedName = _validateNewWalletName(name);

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

    return _buildAndPersistWallet(
      name: trimmedName,
      network: walletNetwork,
      scriptType: scriptType,
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      persistedDescriptor: descriptor.toStringWithSecret(),
      persistedChangeDescriptor: changeDescriptor.toStringWithSecret(),
      bdkNetwork: bdkNetwork,
      recoveryPhrase: mnemonic.toString(),
    );
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

  Future<(WalletRecord, Wallet)> _buildAndPersistWallet({
    required String name,
    required WalletNetwork network,
    required ScriptType scriptType,
    required Descriptor descriptor,
    required Descriptor changeDescriptor,
    required String persistedDescriptor,
    required String persistedChangeDescriptor,
    required Network bdkNetwork,
    String recoveryPhrase = '',
  }) async {
    final trimmedName = _validateNewWalletName(name);

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
      network: network,
      scriptType: scriptType,
      fullScanCompleted: false,
    );

    final secrets = WalletSecrets(
      descriptor: persistedDescriptor,
      changeDescriptor: persistedChangeDescriptor,
      recoveryPhrase: recoveryPhrase,
    );

    try {
      await _storage.addWalletRecord(record, secrets);
    } catch (_) {
      _walletDisposer(wallet);
      rethrow;
    }

    return (record, wallet);
  }

  String _validateNewWalletName(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Wallet name must not be empty.');
    }

    final existing = _storage.getWalletRecords();
    final duplicate = existing.any(
      (record) => record.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicate) {
      throw StateError('A wallet named "$trimmedName" already exists.');
    }

    return trimmedName;
  }

  String _bip39ErrorMessage(Bip39Exception error) {
    return switch (error) {
      BadWordCountBip39Exception(wordCount: final wordCount) =>
        'Recovery phrase must be 12 or 24 words (got $wordCount).',
      UnknownWordBip39Exception(index: final index) =>
        'Recovery phrase contains an unknown word at position ${index + 1}.',
      InvalidChecksumBip39Exception() =>
        'Recovery phrase checksum is invalid. Please double-check the phrase.',
      _ => 'Recovery phrase validation failed. Please verify the phrase and try again.',
    };
  }
}
