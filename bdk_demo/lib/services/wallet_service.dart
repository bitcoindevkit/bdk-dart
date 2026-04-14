import 'package:bdk_dart/bdk.dart' hide TxDetails;
import 'package:uuid/uuid.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';
import 'package:bdk_demo/models/tx_details.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_network_mapper.dart';

typedef WalletDisposer = void Function(Wallet wallet);

class DemoWalletInfo {
  final String title;
  final WalletNetwork network;
  final String descriptor;
  final String descriptorLabel;

  const DemoWalletInfo({
    required this.title,
    required this.network,
    required this.descriptor,
    this.descriptorLabel = 'External descriptor',
  });
}

class WalletService {
  final StorageService? _storage;
  final Uuid? _uuid;
  final WalletDisposer _walletDisposer;

  static const _placeholderDescriptor =
      'wpkh([demo/84h/1h/0h]tpubReferenceScaffold/0/*)#scafld00';
  static final _placeholderTransactions = <TxDetails>[
    TxDetails(
      txid: '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
      sent: 0,
      received: 42000,
      balanceDelta: 42000,
      pending: false,
      blockHeight: 120,
      confirmationTime: DateTime(2024, 1, 2, 3, 4),
    ),
    TxDetails(
      txid: 'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
      sent: 1600,
      received: 0,
      balanceDelta: -1600,
      pending: true,
    ),
  ];

  WalletService({
    StorageService? storage,
    Uuid? uuid,
    WalletDisposer? walletDisposer,
  }) : _storage = storage,
       _uuid = uuid,
       _walletDisposer = walletDisposer ?? _defaultDisposer;

  static void _defaultDisposer(Wallet wallet) => wallet.dispose();

  StorageService get _requiredStorage {
    final storage = _storage;
    if (storage == null) {
      throw StateError('WalletService requires StorageService for this action.');
    }
    return storage;
  }

  Uuid get _requiredUuid {
    final uuid = _uuid;
    if (uuid == null) {
      throw StateError('WalletService requires Uuid for this action.');
    }
    return uuid;
  }

  Future<(WalletRecord, Wallet)> createWallet(
    String name,
    WalletNetwork walletNetwork,
    ScriptType scriptType,
  ) async {
    final storage = _requiredStorage;
    final uuid = _requiredUuid;
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Wallet name must not be empty.');
    }

    final existing = storage.getWalletRecords();
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
      id: uuid.v4(),
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
      await storage.addWalletRecord(record, secrets);
    } catch (_) {
      _walletDisposer(wallet);
      rethrow;
    }

    return (record, wallet);
  }

  Future<Wallet> loadWalletFromRecord(WalletRecord record) async {
    final storage = _requiredStorage;
    final secrets = await storage.getSecrets(record.id);
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

  Future<DemoWalletInfo> loadReferenceWallet() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));

    return const DemoWalletInfo(
      title: 'Reference Wallet Scaffold',
      network: WalletNetwork.testnet,
      descriptor: _placeholderDescriptor,
      descriptorLabel: 'Placeholder descriptor',
    );
  }

  Future<List<TxDetails>> loadTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _placeholderTransactions;
  }

  Future<TxDetails?> loadTransactionByTxid(String txid) async {
    final transactions = await loadTransactions();

    for (final transaction in transactions) {
      if (transaction.txid == txid) return transaction;
    }

    return null;
  }

  void dispose() {}

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
