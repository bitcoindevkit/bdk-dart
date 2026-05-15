import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/constants/app_constants.dart';

typedef SqlitePersistRunner =
    Future<bool> Function(Wallet wallet, Persister persister);

typedef SqliteLoadRunner =
    Wallet Function({
      required Descriptor descriptor,
      required Descriptor changeDescriptor,
      required Persister persister,
      required int lookahead,
    });

Future<void> persistWalletSqliteWithReopenVerify({
  required Wallet wallet,
  required Persister persister,
  required Descriptor descriptor,
  required Descriptor changeDescriptor,
  required String dbPath,
  SqlitePersistRunner persistRunner = _defaultPersistRunner,
  SqliteLoadRunner loadRunner = _defaultLoadRunner,
}) async {
  final persisted = await persistRunner(wallet, persister);
  if (persisted) return;
  if (await _verifySqliteCanBeReopened(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    dbPath: dbPath,
    loadRunner: loadRunner,
  )) {
    return;
  }
  throw StateError('Wallet SQLite persistence returned false.');
}

Future<bool> _verifySqliteCanBeReopened({
  required Descriptor descriptor,
  required Descriptor changeDescriptor,
  required String dbPath,
  required SqliteLoadRunner loadRunner,
}) async {
  try {
    final verifierPersister = Persister.newSqlite(path: dbPath);
    final verifierWallet = loadRunner(
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

Future<bool> _defaultPersistRunner(Wallet wallet, Persister persister) async =>
    wallet.persist(persister: persister);

Wallet _defaultLoadRunner({
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
