import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/wallet_record.dart';

abstract final class _PrefKeys {
  static const introDone = 'intro_done';
  static const darkTheme = 'dark_theme';
  static const walletRecords = 'wallet_records';
}

abstract final class _SecureKeys {
  static String secrets(String walletId) => 'wallet_secrets_$walletId';
}

class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secure;

  StorageService({
    required SharedPreferences prefs,
    FlutterSecureStorage? secure,
  }) : _prefs = prefs,
       _secure = secure ?? const FlutterSecureStorage();

  bool getIntroDone() => _prefs.getBool(_PrefKeys.introDone) ?? false;

  Future<void> setIntroDone() => _prefs.setBool(_PrefKeys.introDone, true);

  bool getDarkTheme() => _prefs.getBool(_PrefKeys.darkTheme) ?? false;

  Future<void> setDarkTheme(bool isDark) =>
      _prefs.setBool(_PrefKeys.darkTheme, isDark);

  List<WalletRecord> getWalletRecords() {
    final encoded = _prefs.getString(_PrefKeys.walletRecords);
    if (encoded == null) return [];
    return WalletRecord.decodeList(encoded);
  }

  Future<void> addWalletRecord(
    WalletRecord record,
    WalletSecrets secrets,
  ) async {
    final records = getWalletRecords();
    records.add(record);
    await _prefs.setString(
      _PrefKeys.walletRecords,
      WalletRecord.encodeList(records),
    );
    await _secure.write(
      key: _SecureKeys.secrets(record.id),
      value: jsonEncode(secrets.toJson()),
    );
  }

  Future<WalletSecrets?> getSecrets(String walletId) async {
    final encoded = await _secure.read(
      key: _SecureKeys.secrets(walletId),
    );
    if (encoded == null) return null;
    return WalletSecrets.fromJson(
      jsonDecode(encoded) as Map<String, dynamic>,
    );
  }

  Future<void> setFullScanCompleted(String walletId) async {
    final records = getWalletRecords();
    final updated = records.map((r) {
      if (r.id == walletId) return r.copyWith(fullScanCompleted: true);
      return r;
    }).toList();
    await _prefs.setString(
      _PrefKeys.walletRecords,
      WalletRecord.encodeList(updated),
    );
  }
}
