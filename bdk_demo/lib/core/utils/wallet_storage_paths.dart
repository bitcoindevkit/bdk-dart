import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract final class WalletStoragePaths {
  static Directory? _documentsRootOverride;
  static const _walletsDirName = 'wallets';
  static const _sqliteFileName = 'bdk.sqlite';
  static const _fallbackSuffix = '_reseed_tmp';

  static void setDocumentsRootOverride(Directory? directory) {
    _documentsRootOverride = directory;
  }

  static Future<Directory> _documentsRoot() async {
    final override = _documentsRootOverride;
    if (override != null) return override;
    final dir = await getApplicationDocumentsDirectory();
    return Directory(dir.path);
  }

  static Future<Directory> _walletDataDirectory(String walletDirName) async {
    final base = await _documentsRoot();
    final dir = Directory(p.join(base.path, _walletsDirName, walletDirName));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<String> sqlitePathForWallet(String walletId) async {
    final dir = await _walletDataDirectory(walletId);
    final relativePath = p.join(dir.path, _sqliteFileName);
    return File(relativePath).absolute.path;
  }

  static Future<String> sqliteFallbackPathForWallet(String walletId) async {
    final dir = await _walletDataDirectory('$walletId$_fallbackSuffix');
    final relativePath = p.join(dir.path, _sqliteFileName);
    return File(relativePath).absolute.path;
  }

  static Future<void> deleteWalletData(String walletId) async {
    final base = await _documentsRoot();
    final dir = Directory(p.join(base.path, _walletsDirName, walletId));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  static Future<void> deleteFallbackWalletData(String walletId) async {
    final base = await _documentsRoot();
    final dir = Directory(
      p.join(base.path, _walletsDirName, '$walletId$_fallbackSuffix'),
    );
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  static Future<void> replaceWalletDataWithFallback(String walletId) async {
    final base = await _documentsRoot();
    final targetDir = Directory(p.join(base.path, _walletsDirName, walletId));
    final fallbackDir = Directory(
      p.join(base.path, _walletsDirName, '$walletId$_fallbackSuffix'),
    );
    if (!await fallbackDir.exists()) {
      throw StateError('No fallback wallet data exists for "$walletId".');
    }
    if (await targetDir.exists()) {
      await targetDir.delete(recursive: true);
    }
    await fallbackDir.rename(targetDir.path);
  }
}
