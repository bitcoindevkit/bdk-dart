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

final walletRecordsProvider = Provider<List<WalletRecord>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getWalletRecords();
});

// TODO: Add activeWalletProvider.
// TODO: Add balanceProvider, syncStateProvider.
