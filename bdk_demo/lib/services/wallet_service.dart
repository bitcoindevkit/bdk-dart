import 'dart:io';
import 'package:bdk_dart/bdk.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:uuid/uuid.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/core/constants/bip39_wordlist.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/blockchain_service.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_network_mapper.dart';
import 'package:bdk_demo/services/wallet_sqlite_persistence.dart';

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

enum _SqliteHealth { valid, corrupt, unknown }

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

  static const List<int> _sqliteHeader = <int>[
    0x53,
    0x51,
    0x4c,
    0x69,
    0x74,
    0x65,
    0x20,
    0x66,
    0x6f,
    0x72,
    0x6d,
    0x61,
    0x74,
    0x20,
    0x33,
    0x00,
  ];

  Future<void> _ensureWalletPersistedToSqlite(
    Wallet wallet,
    Persister persister,
    Descriptor descriptor,
    Descriptor changeDescriptor,
    String dbPath,
  ) async {
    await persistWalletSqliteWithReopenVerify(
      wallet: wallet,
      persister: persister,
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      dbPath: dbPath,
      persistRunner: _persistRunner,
      loadRunner: _walletLoadRunner,
    );
  }

  Future<_SqliteHealth> _probeSqliteHealth(File sqliteFile) async {
    final RandomAccessFile handle;
    try {
      handle = await sqliteFile.open(mode: FileMode.read);
    } catch (_) {
      return _SqliteHealth.unknown;
    }

    try {
      final header = await handle.read(_sqliteHeader.length);
      if (header.length < _sqliteHeader.length) {
        return _SqliteHealth.corrupt;
      }
      for (var i = 0; i < _sqliteHeader.length; i++) {
        if (header[i] != _sqliteHeader[i]) {
          return _SqliteHealth.corrupt;
        }
      }
    } catch (_) {
      return _SqliteHealth.unknown;
    } finally {
      await handle.close();
    }

    sqlite.Database? db;
    try {
      db = sqlite.sqlite3.open(sqliteFile.path, mode: sqlite.OpenMode.readOnly);
      final rows = db.select('PRAGMA integrity_check;');
      final result = rows.isNotEmpty ? rows.first['integrity_check'] : null;
      return result == 'ok' ? _SqliteHealth.valid : _SqliteHealth.corrupt;
    } catch (_) {
      return _SqliteHealth.unknown;
    } finally {
      db?.close();
    }
  }

  String validateRecoveryPhrase(String phrase) {
    final normalized = phrase
        .trim()
        .toLowerCase()
        .replaceAll('\t', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
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
    final bdkNetworkKind = walletNetwork.toBdkNetworkKind();

    final mnemonic = Mnemonic(wordCount: WordCount.words12);
    final secretKey = DescriptorSecretKey(
      networkKind: bdkNetworkKind,
      mnemonic: mnemonic,
      password: null,
    );

    final descriptor = _deriveDescriptor(
      secretKey,
      KeychainKind.external_,
      bdkNetworkKind,
      scriptType,
    );
    final changeDescriptor = _deriveDescriptor(
      secretKey,
      KeychainKind.internal,
      bdkNetworkKind,
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
    final bdkNetworkKind = walletNetwork.toBdkNetworkKind();
    final mnemonic = Mnemonic.fromString(mnemonic: normalized);
    final secretKey = DescriptorSecretKey(
      networkKind: bdkNetworkKind,
      mnemonic: mnemonic,
      password: null,
    );

    final descriptor = _deriveDescriptor(
      secretKey,
      KeychainKind.external_,
      bdkNetworkKind,
      scriptType,
    );
    final changeDescriptor = _deriveDescriptor(
      secretKey,
      KeychainKind.internal,
      bdkNetworkKind,
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
    final bdkNetworkKind = walletNetwork.toBdkNetworkKind();
    final descriptor = Descriptor(
      descriptor: trimmedExternal,
      networkKind: bdkNetworkKind,
    );
    final changeDescriptor = Descriptor(
      descriptor: trimmedChange,
      networkKind: bdkNetworkKind,
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
    final bdkNetworkKind = record.network.toBdkNetworkKind();

    final descriptor = Descriptor(
      descriptor: secrets.descriptor,
      networkKind: bdkNetworkKind,
    );
    final changeDescriptor = Descriptor(
      descriptor: secrets.changeDescriptor,
      networkKind: bdkNetworkKind,
    );

    final dbPath = await WalletStoragePaths.sqlitePathForWallet(record.id);
    final sqliteFile = File(dbPath);
    if (await sqliteFile.exists()) {
      final sqliteHealth = await _probeSqliteHealth(sqliteFile);
      if (sqliteHealth == _SqliteHealth.corrupt) {
        return _reseedWalletToFallbackSqlite(
          walletId: record.id,
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          bdkNetwork: bdkNetwork,
        );
      }

      try {
        final persister = Persister.newSqlite(path: dbPath);
        final wallet = _walletLoadRunner(
          descriptor: descriptor,
          changeDescriptor: changeDescriptor,
          persister: persister,
          lookahead: AppConstants.walletLookahead,
        );
        return wallet;
      } catch (error) {
        throw StateError(
          'Failed to load existing SQLite wallet at "$dbPath". '
          'Preserving the current DB because it was not proven corrupt. '
          'Original error: $error',
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

  Future<Psbt> buildTransaction(
    WalletRecord record,
    Wallet wallet,
    String recipientAddress,
    int amountSat,
    int feeRateSatPerVb,
  ) async {
    final trimmedAddress = recipientAddress.trim();
    if (trimmedAddress.isEmpty) {
      throw ArgumentError('Recipient address must not be empty.');
    }
    if (amountSat <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }
    if (feeRateSatPerVb <= 0) {
      throw ArgumentError('Fee rate must be greater than zero.');
    }

    final network = wallet.network();
    final address = Address(address: trimmedAddress, network: network);
    if (!address.isValidForNetwork(network: network)) {
      throw ArgumentError('Recipient address is not valid for this network.');
    }

    final psbt = TxBuilder()
        .addRecipient(
          script: address.scriptPubkey(),
          amount: Amount.fromSat(satoshi: amountSat),
        )
        .feeRate(feeRate: FeeRate.fromSatPerVb(satVb: feeRateSatPerVb))
        .finish(wallet: wallet);

    await _persistStagedWalletChanges(record, wallet);
    return psbt;
  }

  Txid signAndBroadcast(
    Wallet wallet,
    Psbt psbt,
    BlockchainClient blockchainClient,
  ) {
    final signed = wallet.sign(psbt: psbt, signOptions: null);
    if (!signed) {
      throw StateError('Could not sign transaction.');
    }

    final transaction = psbt.extractTx();
    blockchainClient.broadcast(transaction);
    return transaction.computeTxid();
  }

  Future<(AddressInfo, Wallet)> generateAddress(WalletRecord record) async {
    final secrets = await _storage.getSecrets(record.id);
    if (secrets == null) {
      throw StateError(
        'No secrets found for wallet "${record.name}" (${record.id}). '
        'Cannot persist receive address.',
      );
    }

    Descriptor? descriptor;
    Descriptor? changeDescriptor;
    Persister? persister;
    Wallet? wallet;
    var returnedWallet = false;
    try {
      final bdkNetworkKind = record.network.toBdkNetworkKind();
      descriptor = Descriptor(
        descriptor: secrets.descriptor,
        networkKind: bdkNetworkKind,
      );
      changeDescriptor = Descriptor(
        descriptor: secrets.changeDescriptor,
        networkKind: bdkNetworkKind,
      );
      final dbPath = await WalletStoragePaths.sqlitePathForWallet(record.id);
      wallet = await loadWalletFromRecord(record);

      final receive = wallet.revealNextAddress(
        keychain: KeychainKind.external_,
      );
      persister = Persister.newSqlite(path: dbPath);
      await _ensureWalletPersistedToSqlite(
        wallet,
        persister,
        descriptor,
        changeDescriptor,
        dbPath,
      );
      await _verifyReceiveIndexPersisted(
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        dbPath: dbPath,
        revealedIndex: receive.index,
      );
      returnedWallet = true;
      return (receive, wallet);
    } finally {
      if (!returnedWallet) {
        wallet?.dispose();
      }
      persister?.dispose();
      descriptor?.dispose();
      changeDescriptor?.dispose();
    }
  }

  Future<void> _verifyReceiveIndexPersisted({
    required Descriptor descriptor,
    required Descriptor changeDescriptor,
    required String dbPath,
    required int revealedIndex,
  }) async {
    Persister? verifierPersister;
    Wallet? verifierWallet;
    try {
      verifierPersister = Persister.newSqlite(path: dbPath);
      verifierWallet = _walletLoadRunner(
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        persister: verifierPersister,
        lookahead: AppConstants.walletLookahead,
      );
      final nextExternalIndex = verifierWallet.nextDerivationIndex(
        keychain: KeychainKind.external_,
      );
      if (nextExternalIndex <= revealedIndex) {
        throw StateError(
          'Wallet SQLite persistence did not save receive address index '
          '$revealedIndex.',
        );
      }
    } finally {
      verifierWallet?.dispose();
      verifierPersister?.dispose();
    }
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

  Future<void> _persistStagedWalletChanges(
    WalletRecord record,
    Wallet wallet,
  ) async {
    if (wallet.staged() == null) return;

    final secrets = await _storage.getSecrets(record.id);
    if (secrets == null) {
      throw StateError(
        'No secrets found for wallet "${record.name}" (${record.id}). '
        'Cannot persist transaction state.',
      );
    }

    final bdkNetworkKind = record.network.toBdkNetworkKind();
    final descriptor = Descriptor(
      descriptor: secrets.descriptor,
      networkKind: bdkNetworkKind,
    );
    final changeDescriptor = Descriptor(
      descriptor: secrets.changeDescriptor,
      networkKind: bdkNetworkKind,
    );
    final dbPath = await WalletStoragePaths.sqlitePathForWallet(record.id);
    final persister = Persister.newSqlite(path: dbPath);
    try {
      await _ensureWalletPersistedToSqlite(
        wallet,
        persister,
        descriptor,
        changeDescriptor,
        dbPath,
      );
    } finally {
      persister.dispose();
    }
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
    NetworkKind networkKind,
    ScriptType scriptType,
  ) {
    return switch (scriptType) {
      ScriptType.p2wpkh => Descriptor.newBip84(
        secretKey: secretKey,
        keychainKind: keychainKind,
        networkKind: networkKind,
      ),
      ScriptType.p2tr => Descriptor.newBip86(
        secretKey: secretKey,
        keychainKind: keychainKind,
        networkKind: networkKind,
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
