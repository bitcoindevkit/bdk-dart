import 'dart:convert';

enum WalletNetwork {
  signet,
  testnet,
  regtest;

  String get displayName => switch (this) {
    WalletNetwork.signet => 'Signet',
    WalletNetwork.testnet => 'Testnet 3',
    WalletNetwork.regtest => 'Regtest',
  };
}

enum ScriptType {
  p2wpkh,
  p2tr,
  unknown;

  String get displayName => switch (this) {
    ScriptType.p2wpkh => 'P2WPKH (Native SegWit)',
    ScriptType.p2tr => 'P2TR (Taproot)',
    ScriptType.unknown => 'Unknown',
  };

  String get shortName => switch (this) {
    ScriptType.p2wpkh => 'P2WPKH',
    ScriptType.p2tr => 'P2TR',
    ScriptType.unknown => 'Unknown',
  };
}

class WalletRecord {
  final String id;
  final String name;
  final WalletNetwork network;
  final ScriptType scriptType;
  final bool fullScanCompleted;

  const WalletRecord({
    required this.id,
    required this.name,
    required this.network,
    required this.scriptType,
    this.fullScanCompleted = false,
  });

  WalletRecord copyWith({
    String? id,
    String? name,
    WalletNetwork? network,
    ScriptType? scriptType,
    bool? fullScanCompleted,
  }) {
    return WalletRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      network: network ?? this.network,
      scriptType: scriptType ?? this.scriptType,
      fullScanCompleted: fullScanCompleted ?? this.fullScanCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'network': network.name,
    'scriptType': scriptType.name,
    'fullScanCompleted': fullScanCompleted,
  };

  factory WalletRecord.fromJson(Map<String, dynamic> json) => WalletRecord(
    id: json['id'] as String,
    name: json['name'] as String,
    network: WalletNetwork.values.byName(json['network'] as String),
    scriptType: ScriptType.values.byName(json['scriptType'] as String),
    fullScanCompleted: json['fullScanCompleted'] as bool? ?? false,
  );

  static String encodeList(List<WalletRecord> records) =>
      jsonEncode(records.map((r) => r.toJson()).toList());

  static List<WalletRecord> decodeList(String encoded) =>
      (jsonDecode(encoded) as List)
          .cast<Map<String, dynamic>>()
          .map(WalletRecord.fromJson)
          .toList();
}

class WalletSecrets {
  final String descriptor;
  final String changeDescriptor;
  final String recoveryPhrase;

  const WalletSecrets({
    required this.descriptor,
    required this.changeDescriptor,
    this.recoveryPhrase = '',
  });

  Map<String, dynamic> toJson() => {
    'descriptor': descriptor,
    'changeDescriptor': changeDescriptor,
    'recoveryPhrase': recoveryPhrase,
  };

  factory WalletSecrets.fromJson(Map<String, dynamic> json) => WalletSecrets(
    descriptor: json['descriptor'] as String,
    changeDescriptor: json['changeDescriptor'] as String,
    recoveryPhrase: json['recoveryPhrase'] as String? ?? '',
  );
}
