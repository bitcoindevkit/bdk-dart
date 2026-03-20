import 'package:bdk_demo/models/wallet_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bdk_dart/bdk.dart';
import 'settings_providers.dart';

typedef WalletDisposer = void Function(Wallet wallet);

final walletDisposerProvider = Provider<WalletDisposer>(
  (ref) =>
      (wallet) => wallet.dispose(),
);

final activeWalletRecordProvider =
    NotifierProvider<ActiveWalletRecordNotifier, WalletRecord?>(
      ActiveWalletRecordNotifier.new,
    );

class ActiveWalletRecordNotifier extends Notifier<WalletRecord?> {
  @override
  WalletRecord? build() => null;

  void set(WalletRecord record) => state = record;
  void clear() => state = null;
}

final activeWalletProvider = NotifierProvider<ActiveWalletNotifier, Wallet?>(
  ActiveWalletNotifier.new,
);

class ActiveWalletNotifier extends Notifier<Wallet?> {
  late WalletDisposer _walletDisposer;
  Wallet? _currentWallet;

  void _disposeWallet(Wallet? wallet) {
    if (wallet == null) return;
    _walletDisposer(wallet);
  }

  @override
  Wallet? build() {
    _walletDisposer = ref.read(walletDisposerProvider);
    _currentWallet = null;
    ref.onDispose(() => _disposeWallet(_currentWallet));
    return null;
  }

  void set(Wallet wallet) {
    if (identical(_currentWallet, wallet)) {
      return;
    }
    _disposeWallet(_currentWallet);
    _currentWallet = wallet;
    state = wallet;
  }

  void clear() {
    _disposeWallet(_currentWallet);
    _currentWallet = null;
    state = null;
  }
}

final walletRecordsProvider =
    NotifierProvider<WalletRecordsNotifier, List<WalletRecord>>(
      WalletRecordsNotifier.new,
    );

class WalletRecordsNotifier extends Notifier<List<WalletRecord>> {
  @override
  List<WalletRecord> build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.getWalletRecords();
  }

  Future<void> addWalletRecord(
    WalletRecord record,
    WalletSecrets secrets,
  ) async {
    final storage = ref.read(storageServiceProvider);
    await storage.addWalletRecord(record, secrets);
    state = storage.getWalletRecords();
  }

  Future<void> setFullScanCompleted(String walletId) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setFullScanCompleted(walletId);
    state = storage.getWalletRecords();
  }

  void refresh() {
    state = ref.read(storageServiceProvider).getWalletRecords();
  }
}

// TODO: Add balanceProvider, syncStateProvider.
