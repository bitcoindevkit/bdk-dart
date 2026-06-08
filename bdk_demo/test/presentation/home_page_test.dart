import 'dart:async';
import 'dart:io';
import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/utils/wallet_storage_paths.dart';
import 'package:bdk_demo/features/home/home_page.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/blockchain_providers.dart';
import 'package:bdk_demo/providers/connectivity_provider.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:bdk_demo/services/wallet_sync_job.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _testExtendedPrivKey =
    'tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B';

Wallet _createTestWallet({Network network = Network.testnet}) {
  final descriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/0/*)',
    networkKind: NetworkKind.test,
  );
  final changeDescriptor = Descriptor(
    descriptor: 'wpkh($_testExtendedPrivKey/84h/1h/0h/1/*)',
    networkKind: NetworkKind.test,
  );
  return Wallet(
    descriptor: descriptor,
    changeDescriptor: changeDescriptor,
    network: network,
    persister: Persister.newInMemory(),
    lookahead: 25,
  );
}

Future<WalletSyncResult> _noopSyncRunner(WalletSyncRequest request) async {
  return WalletSyncResult.success(
    walletId: request.walletId,
    performedFullScan: true,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Directory? walletDocsRoot;

  setUp(() async {
    walletDocsRoot = await Directory.systemTemp.createTemp('home_page_wallet_');
    WalletStoragePaths.setDocumentsRootOverride(walletDocsRoot);
  });

  tearDown(() async {
    WalletStoragePaths.setDocumentsRootOverride(null);
    final root = walletDocsRoot;
    walletDocsRoot = null;
    if (root != null && root.existsSync()) {
      await root.delete(recursive: true);
    }
  });

  Future<StorageService> initStorage() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs: prefs);
  }

  Future<ProviderContainer> createContainer({
    List<Override> overrides = const [],
    List<ConnectivityResult> connectivityResults = const [
      ConnectivityResult.wifi,
    ],
    Stream<List<ConnectivityResult>>? connectivityStream,
    WalletSyncJobRunner syncRunner = _noopSyncRunner,
    Future<void> Function()? syncTrigger,
  }) async {
    final storage = await initStorage();
    final walletService = _HomePageTestWalletService(storage: storage);
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        walletServiceProvider.overrideWithValue(walletService),
        walletSyncJobRunnerProvider.overrideWithValue(syncRunner),
        if (syncTrigger != null)
          syncActiveWalletTriggerProvider.overrideWithValue(syncTrigger),
        connectivityProvider.overrideWith(
          (ref) => connectivityStream ?? Stream.value(connectivityResults),
        ),
        ...overrides,
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> pumpHomePage(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  Future<void> flushAutoSync(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
  }

  Future<void> triggerPullToRefresh(WidgetTester tester) async {
    await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  Future<(WalletRecord, Wallet)> seedActiveWallet(
    ProviderContainer container, {
    String id = 'home-test-wallet',
    String name = 'Home Wallet',
    WalletNetwork network = WalletNetwork.testnet,
    bool persistToStorage = false,
  }) async {
    final wallet = _createTestWallet(
      network: switch (network) {
        WalletNetwork.signet => Network.signet,
        WalletNetwork.testnet => Network.testnet,
        WalletNetwork.regtest => Network.regtest,
      },
    );
    final record = WalletRecord(
      id: id,
      name: name,
      network: network,
      scriptType: ScriptType.p2wpkh,
    );

    if (persistToStorage) {
      final storage = container.read(storageServiceProvider);
      await storage.addWalletRecord(
        record,
        const WalletSecrets(
          descriptor: 'dummy-desc',
          changeDescriptor: 'dummy-change',
        ),
      );
      container.read(walletRecordsProvider.notifier).refresh();
    }

    container.read(activeWalletRecordProvider.notifier).set(record);
    container.read(activeWalletProvider.notifier).set(wallet);
    return (record, wallet);
  }

  void seedBalanceSnapshot(
    ProviderContainer container,
    Wallet wallet,
    String walletId,
  ) {
    container
        .read(balanceSnapshotProvider.notifier)
        .applyFromWallet(wallet, walletId);
  }

  test('fake sync runner is invoked by SyncController', () async {
    var syncCalls = 0;
    final container = await createContainer(
      syncRunner: (request) async {
        syncCalls += 1;
        return WalletSyncResult.success(
          walletId: request.walletId,
          performedFullScan: true,
        );
      },
    );
    await seedActiveWallet(container, persistToStorage: true);

    await container.read(syncControllerProvider.notifier).syncActiveWallet();

    expect(syncCalls, 1);
  });

  testWidgets('renders total balance in BTC mode and toggles to sats', (
    tester,
  ) async {
    final container = await createContainer();
    final (record, wallet) = await seedActiveWallet(container);
    seedBalanceSnapshot(container, wallet, record.id);

    await pumpHomePage(tester, container);

    expect(find.text('0.00000000'), findsOneWidget);

    await tester.tap(find.text('0.00000000'));
    await tester.pump();

    expect(find.text('0 sat'), findsWidgets);
  });

  testWidgets('renders sync chip states', (tester) async {
    for (final entry in [
      (SyncStatus.idle, 'idle'),
      (SyncStatus.syncing, 'syncing'),
      (SyncStatus.synced, 'synced'),
      (SyncStatus.error, 'error'),
    ]) {
      final container = await createContainer();
      final (record, wallet) = await seedActiveWallet(
        container,
        id: 'status-${entry.$2}',
        name: 'Status ${entry.$2}',
      );
      seedBalanceSnapshot(container, wallet, record.id);
      container.read(syncStatusProvider.notifier).set(entry.$1);

      await pumpHomePage(tester, container);

      expect(find.text(entry.$2), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('renders sync progress steps while syncing', (tester) async {
    final container = await createContainer();
    await seedActiveWallet(container);
    container.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
    container.read(syncProgressProvider.notifier).start(isFirstSync: true);
    container.read(syncProgressProvider.notifier).setPhase(SyncPhase.scanning);

    await pumpHomePage(tester, container);

    expect(find.text('Connecting to server'), findsOneWidget);
    expect(find.text('First sync (checking addresses)'), findsOneWidget);
    expect(find.text('Saving wallet'), findsOneWidget);
    expect(find.text('Up to date'), findsOneWidget);
    expect(find.text('This usually takes about 5–10 seconds.'), findsOneWidget);
  });

  testWidgets('renders completed sync progress steps when synced', (
    tester,
  ) async {
    final container = await createContainer();
    final (record, wallet) = await seedActiveWallet(container);
    seedBalanceSnapshot(container, wallet, record.id);
    container.read(syncProgressProvider.notifier).start(isFirstSync: true);
    container.read(syncProgressProvider.notifier).setPhase(SyncPhase.upToDate);
    container.read(syncStatusProvider.notifier).set(SyncStatus.synced);

    await pumpHomePage(tester, container);

    expect(find.text('Up to date'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsWidgets);
  });

  testWidgets('renders safe pre-sync state without a balance snapshot', (
    tester,
  ) async {
    final container = await createContainer();
    await seedActiveWallet(container);
    container.read(syncStatusProvider.notifier).set(SyncStatus.syncing);

    await pumpHomePage(tester, container);

    expect(find.text('0.00000000'), findsOneWidget);
    expect(find.text('Syncing wallet...'), findsOneWidget);
  });

  testWidgets('auto-sync fires once for active wallet without snapshot', (
    tester,
  ) async {
    var syncCalls = 0;
    final container = await createContainer(
      syncTrigger: () async {
        syncCalls += 1;
      },
    );
    await pumpHomePage(tester, container);
    await seedActiveWallet(container);
    await flushAutoSync(tester);

    expect(syncCalls, 1);

    await flushAutoSync(tester);

    expect(syncCalls, 1);
  });

  testWidgets('auto-sync does not fire while already syncing', (tester) async {
    var syncCalls = 0;
    final container = await createContainer(
      syncTrigger: () async {
        syncCalls += 1;
      },
    );
    await pumpHomePage(tester, container);
    container.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
    await seedActiveWallet(container);
    await flushAutoSync(tester);

    expect(syncCalls, 0);
  });

  testWidgets('auto-sync does not fire while offline', (tester) async {
    var syncCalls = 0;
    final container = await createContainer(
      connectivityResults: const [ConnectivityResult.none],
      syncTrigger: () async {
        syncCalls += 1;
      },
    );
    await pumpHomePage(tester, container);
    await seedActiveWallet(container);
    await flushAutoSync(tester);

    expect(syncCalls, 0);
  });

  testWidgets('regtest wallet hides sync card and does not auto-sync', (
    tester,
  ) async {
    var syncCalls = 0;
    final container = await createContainer(
      syncTrigger: () async {
        syncCalls += 1;
      },
    );

    await pumpHomePage(tester, container);
    await seedActiveWallet(
      container,
      network: WalletNetwork.regtest,
      name: 'Regtest Wallet',
    );
    await flushAutoSync(tester);

    expect(syncCalls, 0);
    expect(find.text('Sync idle'), findsNothing);
    expect(find.text('Sync error'), findsNothing);
    expect(find.text('Regtest Wallet'), findsOneWidget);
  });

  testWidgets('auto-sync starts when connectivity becomes available', (
    tester,
  ) async {
    final connectivity = StreamController<List<ConnectivityResult>>();
    addTearDown(connectivity.close);

    var syncCalls = 0;
    final container = await createContainer(
      connectivityStream: connectivity.stream,
      syncTrigger: () async {
        syncCalls += 1;
      },
    );

    await pumpHomePage(tester, container);
    await seedActiveWallet(container);
    await flushAutoSync(tester);

    expect(syncCalls, 0);

    connectivity.add(const [ConnectivityResult.none]);
    await tester.pump();
    await flushAutoSync(tester);

    expect(syncCalls, 0);

    connectivity.add(const [ConnectivityResult.wifi]);
    await tester.pump();
    await flushAutoSync(tester);

    expect(syncCalls, 1);
  });

  testWidgets('auto-sync can start when previous wallet left synced status', (
    tester,
  ) async {
    var syncCalls = 0;
    final container = await createContainer(
      syncTrigger: () async {
        syncCalls += 1;
      },
    );
    await pumpHomePage(tester, container);
    await seedActiveWallet(container);
    container.read(syncStatusProvider.notifier).set(SyncStatus.synced);
    await flushAutoSync(tester);

    expect(syncCalls, 1);
  });

  testWidgets('auto-sync dedupe follows a changed active wallet id', (
    tester,
  ) async {
    final syncedWalletIds = <String>[];
    late ProviderContainer container;
    container = await createContainer(
      syncTrigger: () async {
        final walletId = container.read(activeWalletRecordProvider)?.id;
        if (walletId != null) {
          syncedWalletIds.add(walletId);
        }
      },
    );
    await pumpHomePage(tester, container);
    final (recordA, _) = await seedActiveWallet(
      container,
      id: 'wallet-a',
      name: 'Wallet A',
    );

    await flushAutoSync(tester);

    final (recordB, walletB) = (
      recordA.copyWith(id: 'wallet-b', name: 'Wallet B'),
      _createTestWallet(),
    );
    container.read(activeWalletRecordProvider.notifier).set(recordB);
    container.read(activeWalletProvider.notifier).set(walletB);
    container.read(syncStatusProvider.notifier).set(SyncStatus.error);

    await tester.pump();
    await flushAutoSync(tester);

    expect(syncedWalletIds, ['wallet-a', 'wallet-b']);
  });

  testWidgets('failed sync can retry after connectivity returns', (
    tester,
  ) async {
    final connectivity = StreamController<List<ConnectivityResult>>();
    addTearDown(connectivity.close);

    var syncCalls = 0;
    final container = await createContainer(
      connectivityStream: connectivity.stream,
      syncTrigger: () async {
        syncCalls += 1;
      },
    );

    await pumpHomePage(tester, container);
    await seedActiveWallet(container);

    connectivity.add(const [ConnectivityResult.wifi]);
    await tester.pump();
    await flushAutoSync(tester);

    expect(syncCalls, 1);

    container.read(syncStatusProvider.notifier).set(SyncStatus.error);
    await tester.pump();
    await flushAutoSync(tester);

    expect(syncCalls, 1);

    connectivity.add(const [ConnectivityResult.none]);
    await tester.pump();
    await flushAutoSync(tester);

    expect(syncCalls, 1);

    connectivity.add(const [ConnectivityResult.wifi]);
    await tester.pump();
    await flushAutoSync(tester);

    expect(syncCalls, 2);
  });

  testWidgets('disables Send when offline', (tester) async {
    final container = await createContainer(
      connectivityResults: const [ConnectivityResult.none],
    );
    final (record, wallet) = await seedActiveWallet(container);
    seedBalanceSnapshot(container, wallet, record.id);

    await pumpHomePage(tester, container);

    expect(find.text('Receive'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
    final sendButton = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('Send'),
        matching: find.byWidgetPredicate(
          (widget) => widget is ButtonStyleButton,
        ),
      ),
    );
    expect(sendButton.onPressed, isNull);
  });

  testWidgets('pull-to-refresh requests sync when online', (tester) async {
    var syncCalls = 0;
    final container = await createContainer(
      syncTrigger: () async {
        syncCalls += 1;
      },
    );
    final (record, wallet) = await seedActiveWallet(container);
    seedBalanceSnapshot(container, wallet, record.id);

    await pumpHomePage(tester, container);
    expect(syncCalls, 0);

    await triggerPullToRefresh(tester);
    await flushAutoSync(tester);

    expect(syncCalls, 1);
  });

  testWidgets('pull-to-refresh does not request sync while offline', (
    tester,
  ) async {
    var syncCalls = 0;
    final container = await createContainer(
      connectivityResults: const [ConnectivityResult.none],
      syncTrigger: () async {
        syncCalls += 1;
      },
    );
    final (record, wallet) = await seedActiveWallet(container);
    seedBalanceSnapshot(container, wallet, record.id);

    await pumpHomePage(tester, container);
    expect(syncCalls, 0);

    await triggerPullToRefresh(tester);
    await flushAutoSync(tester);

    expect(syncCalls, 0);
  });

  testWidgets('keeps Send disabled while connectivity is still loading', (
    tester,
  ) async {
    final connectivity = StreamController<List<ConnectivityResult>>();
    addTearDown(connectivity.close);

    final container = await createContainer(
      connectivityStream: connectivity.stream,
    );
    final (record, wallet) = await seedActiveWallet(container);
    seedBalanceSnapshot(container, wallet, record.id);

    await pumpHomePage(tester, container);

    final sendButton = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('Send'),
        matching: find.byWidgetPredicate(
          (widget) => widget is ButtonStyleButton,
        ),
      ),
    );
    expect(sendButton.onPressed, isNull);
  });

  testWidgets('renders empty state without an active wallet', (tester) async {
    final container = await createContainer();

    await pumpHomePage(tester, container);

    expect(find.text('No active wallet'), findsOneWidget);
    expect(
      find.text('Create or load a wallet to view balance and sync status.'),
      findsOneWidget,
    );
  });

  testWidgets('renders empty state when active record has no live wallet', (
    tester,
  ) async {
    final container = await createContainer();
    container
        .read(activeWalletRecordProvider.notifier)
        .set(
          const WalletRecord(
            id: 'record-only',
            name: 'Record Only',
            network: WalletNetwork.testnet,
            scriptType: ScriptType.p2wpkh,
          ),
        );

    await pumpHomePage(tester, container);

    expect(find.text('No active wallet'), findsOneWidget);
  });

  testWidgets('does not auto-sync when a matching snapshot already exists', (
    tester,
  ) async {
    var syncCalls = 0;
    final container = await createContainer(
      syncRunner: (request) async {
        syncCalls += 1;
        return WalletSyncResult.success(
          walletId: request.walletId,
          performedFullScan: true,
        );
      },
    );
    final (record, wallet) = await seedActiveWallet(container);
    seedBalanceSnapshot(container, wallet, record.id);

    await pumpHomePage(tester, container);
    await flushAutoSync(tester);

    expect(syncCalls, 0);
  });
}

class _HomePageTestWalletService extends WalletService {
  _HomePageTestWalletService({required super.storage})
    : super(uuid: const Uuid());

  @override
  Future<Wallet> loadWalletFromRecord(WalletRecord record) async {
    return _createTestWallet();
  }
}
