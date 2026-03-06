import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStatus { idle, syncing, synced, error }

final syncStatusProvider =
    NotifierProvider<SyncStatusNotifier, SyncStatus>(SyncStatusNotifier.new);

class SyncStatusNotifier extends Notifier<SyncStatus> {
  @override
  SyncStatus build() => SyncStatus.idle;

  void set(SyncStatus status) => state = status;
}

// TODO: Add blockchainServiceProvider, esploraClientProvider, etc.
