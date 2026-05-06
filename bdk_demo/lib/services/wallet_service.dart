import 'dart:io';
import 'package:bdk_dart/bdk.dart';
import 'package:uuid/uuid.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/core/constants/bip39_wordlist.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_network_mapper.dart';

typedef WalletDisposer = void Function(Wallet wallet);

typedef WalletPersistRunner =
    Future<bool> Function(Wallet wallet, Persister persister);
typedef WalletLoadRunner =
    Wallet Function({
      required Descriptor descriptor,
      required Descriptor changeDescriptor,
      required Persister persister,
      required int lookahead,
    });

class WalletService {
  WalletService({
    required StorageService storage,
    required Uuid uuid,
    WalletDisposer? walletDisposer,
    WalletPersistRunner? persistRunner,
    WalletLoadRunner? walletLoadRunner,
  }) : _storage = storage,
       _uuid = uuid,
       _walletDisposer = walletDisposer ?? _defaultDisposer,
       _persistRunner = persistRunner ?? _defaultPersistRunner,
       _walletLoadRunner = walletLoadRunner ?? _defaultWalletLoadRunner;

  final StorageService _storage;
  final Uuid _uuid;
  final WalletDisposer _walletDisposer;
  final WalletPersistRunner _persistRunner;
  final WalletLoadRunner _walletLoadRunner;

  static Future<bool> _defaultPersistRunner(
    Wallet wallet,
    Persister persister,
  ) async => wallet.persist(persister: persister);

  static Wallet _defaultWalletLoadRunner({
    required Descriptor descriptor,
    required Descriptor changeDescriptor,
    required Persister persister,
    required int lookahead,
  }) {
    return Wallet.load(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      persister: persister,
      lookahead: lookahead,
    );
  }

  static void _defaultDisposer(Wallet wallet) => wallet.dispose();

  Future<void> _ensureWalletPersistedToSqlite(
    Wallet wallet,
    Persister persister,
    Descriptor descriptor,
    Descriptor changeDescriptor,
    String dbPath,
  ) async {
    final persisted = await _persistRunner(wallet, persister);
    if (persisted) return;
    if (await _verifySqliteCanBeReopened(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      dbPath: dbPath,
    )) {
      return;
    }
    throw StateError('Wallet SQLite persistence returned false.');
  }

  Future<bool> _verifySqliteCanBeReopened({
    required Descriptor descriptor,
    required Descriptor changeDescriptor,
    required String dbPath,
  }) async {
    try {
      final verifierPersister = Persister.newSqlite(path: dbPath);
      final verifierWallet = _walletLoadRunner(
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        persister: verifierPersister,
        lookahead: AppConstants.walletLookahead,
      );
      verifierWallet.dispose();
      return true;
    } catch (_) {
      return false;
    }
  }

  String validateRecoveryPhrase(String phrase) {
    final normalized = phrase
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .join(' ');
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

  Future<(WalletRecord, Wallet)> recoverFromPhrase(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
    String phrase,
  ) async {
    if (scriptType == ScriptType.unknown) {
      throw ArgumentError(
        'Script type must be known for phrase recovery (got $scriptType).',
      );
    }

    final normalized = validateRecoveryPhrase(phrase);
    final bdkNetwork = walletNetwork.toBdkNetwork();
    final mnemonic = Mnemonic.fromString(mnemonic: normalized);
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
      name: name,
      network: walletNetwork,
      scriptType: scriptType,
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      persistedDescriptor: descriptor.toStringWithSecret(),
      persistedChangeDescriptor: changeDescriptor.toStringWithSecret(),
      bdkNetwork: bdkNetwork,
      recoveryPhrase: normalized,
    );
  }

  Future<(WalletRecord, Wallet)> recoverFromDescriptors(
    String name,
    WalletNetwork walletNetwork,
    String descriptorStr,
    String changeDescriptorStr,
  ) async {
    final trimmedExternal = descriptorStr.trim();
    final trimmedChange = changeDescriptorStr.trim();
    if (trimmedExternal.isEmpty || trimmedChange.isEmpty) {
      throw ArgumentError('Descriptor strings must not be empty.');
    }

    final bdkNetwork = walletNetwork.toBdkNetwork();
    final descriptor = Descriptor(
      descriptor: trimmedExternal,
      network: bdkNetwork,
    );
    final changeDescriptor = Descriptor(
      descriptor: trimmedChange,
      network: bdkNetwork,
    );

    return _buildAndPersistWallet(
      name: name,
      network: walletNetwork,
      scriptType: ScriptType.unknown,
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      persistedDescriptor: trimmedExternal,
      persistedChangeDescriptor: trimmedChange,
      bdkNetwork: bdkNetwork,
      recoveryPhrase: '',
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

    final dbPath = await WalletStoragePaths.sqlitePathForWallet(record.id);
    final sqliteFile = File(dbPath);
    if (await sqliteFile.exists()) {
      try {
        final persister = Persister.newSqlite(path: dbPath);
        final wallet = _walletLoadRunner(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          persister: persister,
          lookahead: AppConstants.walletLookahead,
        );
        return wallet;
      } catch (_) {
        return _reseedWalletToFallbackSqlite(
          walletId: record.id,
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          bdkNetwork: bdkNetwork,
        );
      }
    }

    return _reseedWalletToPrimarySqlite(
      walletId: record.id,
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      bdkNetwork: bdkNetwork,
    );
  }

  Future<Wallet> _reseedWalletToPrimarySqlite({
    required String walletId,
    required Descriptor descriptor,
    required Descriptor changeDescriptor,
    required Network bdkNetwork,
  }) async {
    final dbPath = await WalletStoragePaths.sqlitePathForWallet(walletId);
    final persister = Persister.newSqlite(path: dbPath);
    final wallet = Wallet(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      network: bdkNetwork,
      persister: persister,
      lookahead: AppConstants.walletLookahead,
    );
    try {
      await _ensureWalletPersistedToSqlite(
        wallet,
        persister,
        descriptor,
        changeDescriptor,
        dbPath,
      );
    } catch (_) {
      _walletDisposer(wallet);
      await WalletStoragePaths.deleteWalletData(walletId);
      rethrow;
    }
    return wallet;
  }

  Future<Wallet> _reseedWalletToFallbackSqlite({
    required String walletId,
    required Descriptor descriptor,
    required Descriptor changeDescriptor,
    required Network bdkNetwork,
  }) async {
    await WalletStoragePaths.deleteFallbackWalletData(walletId);
    final fallbackDbPath = await WalletStoragePaths.sqliteFallbackPathForWallet(
      walletId,
    );
    final fallbackPersister = Persister.newSqlite(path: fallbackDbPath);
    final wallet = Wallet(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      network: bdkNetwork,
      persister: fallbackPersister,
      lookahead: AppConstants.walletLookahead,
    );

    try {
      await _ensureWalletPersistedToSqlite(
        wallet,
        fallbackPersister,
        descriptor,
        changeDescriptor,
        fallbackDbPath,
      );
      await WalletStoragePaths.replaceWalletDataWithFallback(walletId);
      return wallet;
    } catch (_) {
      _walletDisposer(wallet);
      await WalletStoragePaths.deleteFallbackWalletData(walletId);
      rethrow;
    }
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

    Wallet? wallet;
    try {
      final dbPath = await WalletStoragePaths.sqlitePathForWallet(record.id);
      final persister = Persister.newSqlite(path: dbPath);
      wallet = Wallet(
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        network: bdkNetwork,
        persister: persister,
        lookahead: AppConstants.walletLookahead,
      );

      await _ensureWalletPersistedToSqlite(
        wallet,
        persister,
        descriptor,
        changeDescriptor,
        dbPath,
      );

      await _storage.addWalletRecord(record, secrets);
    } catch (_) {
      if (wallet != null) {
        _walletDisposer(wallet);
      }
      await WalletStoragePaths.deleteWalletData(record.id);
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
      _ =>
        'Recovery phrase validation failed. Please verify the phrase and try again.',
    };
  }
}
