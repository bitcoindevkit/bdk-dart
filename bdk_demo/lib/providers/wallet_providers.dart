import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/wallet_record.dart';
import 'settings_providers.dart';

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

// TODO: Add activeWalletProvider.
// TODO: Add balanceProvider, syncStateProvider.
