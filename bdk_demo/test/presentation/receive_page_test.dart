import 'package:bdk_dart/bdk.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/features/receive/receive_page.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/address_providers.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _testExtendedPrivKey =
    'tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B';

Wallet _createTestWallet() {
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
    network: Network.testnet,
    persister: Persister.newInMemory(),
    lookahead: 25,
  );
}

class _ReceivePageTestWalletService extends WalletService {
  _ReceivePageTestWalletService({
    required super.storage,
    required this.wallet,
    this.shouldThrow = false,
    this.throwOnCall,
  }) : super(uuid: const Uuid());

  final Wallet wallet;
  final bool shouldThrow;
  final int? throwOnCall;
  var _generateCalls = 0;

  @override
  Future<(AddressInfo, Wallet)> generateAddress(WalletRecord record) async {
    _generateCalls += 1;
    if (shouldThrow || throwOnCall == _generateCalls) {
      throw StateError('generation failed');
    }
    final addressInfo = wallet.revealNextAddress(
      keychain: KeychainKind.external_,
    );
    return (addressInfo, wallet);
  }
}

class _UnusedWalletService extends WalletService {
  _UnusedWalletService({required super.storage}) : super(uuid: const Uuid());

  @override
  Future<(AddressInfo, Wallet)> generateAddress(WalletRecord record) {
    throw UnimplementedError('Use _ReceivePageTestWalletService instead.');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            return null;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Future<ProviderContainer> createContainer({
    WalletService Function(StorageService storage)? walletServiceFactory,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs: prefs);
    final walletService =
        walletServiceFactory?.call(storage) ??
        _UnusedWalletService(storage: storage);
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        walletServiceProvider.overrideWithValue(walletService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<(WalletRecord, Wallet)> seedActiveWallet(
    ProviderContainer container,
  ) async {
    final wallet = _createTestWallet();
    const record = WalletRecord(
      id: 'receive-ui-wallet',
      name: 'Receive UI Wallet',
      network: WalletNetwork.testnet,
      scriptType: ScriptType.p2wpkh,
    );
    container.read(activeWalletProvider.notifier).set(wallet);
    container.read(activeWalletRecordProvider.notifier).set(record);
    return (record, wallet);
  }

  Future<void> pumpReceivePage(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ReceivePage()),
      ),
    );
    await tester.pump();
  }

  Future<void> generateAddressFromButton(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.text('Generate New Address'),
      100,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate New Address'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders empty state without an active wallet', (tester) async {
    final container = await createContainer();

    await pumpReceivePage(tester, container);

    expect(find.text('Receive'), findsOneWidget);
    expect(find.text('No active wallet'), findsOneWidget);
    expect(
      find.text('Create or load a wallet before generating a receive address.'),
      findsOneWidget,
    );
    expect(find.text('Generate New Address'), findsNothing);
  });

  testWidgets('renders active wallet before address generation', (
    tester,
  ) async {
    final container = await createContainer();
    await seedActiveWallet(container);

    await pumpReceivePage(tester, container);

    expect(find.text('Receive bitcoin'), findsOneWidget);
    expect(find.text('No receive address yet'), findsOneWidget);
    expect(find.text('Generate New Address'), findsOneWidget);
    expect(find.byType(PrettyQrView), findsNothing);
  });

  testWidgets('generates and renders receive address details', (tester) async {
    final wallet = _createTestWallet();
    final container = await createContainer(
      walletServiceFactory: (storage) =>
          _ReceivePageTestWalletService(storage: storage, wallet: wallet),
    );
    container.read(activeWalletProvider.notifier).set(wallet);
    container
        .read(activeWalletRecordProvider.notifier)
        .set(
          const WalletRecord(
            id: 'receive-ui-wallet',
            name: 'Receive UI Wallet',
            network: WalletNetwork.testnet,
            scriptType: ScriptType.p2wpkh,
          ),
        );
    await pumpReceivePage(tester, container);

    await generateAddressFromButton(tester);

    final state = container.read(currentReceiveAddressProvider);
    final address = state.address;
    expect(address, isNotNull);
    expect(state.index, 0);
    expect(find.byType(PrettyQrView), findsOneWidget);
    expect(find.text(Formatters.formatAddress(address!)), findsOneWidget);
    expect(find.text('Address index #0'), findsOneWidget);
  });

  testWidgets('copies generated address with snackbar confirmation', (
    tester,
  ) async {
    final wallet = _createTestWallet();
    final container = await createContainer(
      walletServiceFactory: (storage) =>
          _ReceivePageTestWalletService(storage: storage, wallet: wallet),
    );
    container.read(activeWalletProvider.notifier).set(wallet);
    container
        .read(activeWalletRecordProvider.notifier)
        .set(
          const WalletRecord(
            id: 'receive-ui-wallet',
            name: 'Receive UI Wallet',
            network: WalletNetwork.testnet,
            scriptType: ScriptType.p2wpkh,
          ),
        );
    await pumpReceivePage(tester, container);
    await generateAddressFromButton(tester);

    await tester.scrollUntilVisible(
      find.text('Copy Address'),
      100,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
    final copyButton = find.ancestor(
      of: find.text('Copy Address'),
      matching: find.byType(OutlinedButton),
    );

    await tester.tap(copyButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Address copied'), findsOneWidget);
  });

  testWidgets('renders generation errors and keeps retry action', (
    tester,
  ) async {
    final container = await createContainer(
      walletServiceFactory: (storage) => _ReceivePageTestWalletService(
        storage: storage,
        wallet: _createTestWallet(),
        shouldThrow: true,
      ),
    );
    await seedActiveWallet(container);
    await pumpReceivePage(tester, container);

    await generateAddressFromButton(tester);

    expect(find.text('Could not generate address'), findsOneWidget);
    expect(find.textContaining('generation failed'), findsOneWidget);
    expect(find.text('Generate New Address'), findsOneWidget);
  });

  testWidgets('keeps previous address visible after retry failure', (
    tester,
  ) async {
    final wallet = _createTestWallet();
    final container = await createContainer(
      walletServiceFactory: (storage) => _ReceivePageTestWalletService(
        storage: storage,
        wallet: wallet,
        throwOnCall: 2,
      ),
    );
    container.read(activeWalletProvider.notifier).set(wallet);
    container
        .read(activeWalletRecordProvider.notifier)
        .set(
          const WalletRecord(
            id: 'receive-ui-wallet',
            name: 'Receive UI Wallet',
            network: WalletNetwork.testnet,
            scriptType: ScriptType.p2wpkh,
          ),
        );
    await pumpReceivePage(tester, container);
    await generateAddressFromButton(tester);
    final firstAddress = container.read(currentReceiveAddressProvider).address;

    await generateAddressFromButton(tester);

    expect(firstAddress, isNotNull);
    expect(find.text(Formatters.formatAddress(firstAddress!)), findsOneWidget);
    expect(find.text('Address index #0'), findsOneWidget);
    expect(find.text('Could not generate new address'), findsOneWidget);
    expect(find.textContaining('generation failed'), findsOneWidget);
  });
}
