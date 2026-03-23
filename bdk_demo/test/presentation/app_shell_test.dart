import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bdk_demo/app/app.dart';
import 'package:bdk_demo/models/tx_details.dart';
import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';
import 'package:bdk_demo/services/wallet_service.dart';

class FakeWalletService extends WalletService {
  final DemoWalletInfo walletInfo;
  final List<TxDetails> transactions;

  FakeWalletService({required this.walletInfo, required this.transactions});

  @override
  Future<DemoWalletInfo> loadReferenceWallet() async => walletInfo;

  @override
  Future<List<TxDetails>> loadTransactions() async => transactions;

  @override
  void dispose() {}
}

void main() {
  testWidgets('App builds and shows WalletChoicePage', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(
            StorageService(prefs: prefs),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Use an Active Wallet'), findsOneWidget);
    expect(find.text('Create a New Wallet'), findsOneWidget);
    expect(find.text('Recover an Existing Wallet'), findsOneWidget);
  });

  testWidgets('Theme defaults to light mode', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(
            StorageService(prefs: prefs),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.light);
  });

  testWidgets('Reference wallet scaffold page shows placeholder transactions', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final fakeWalletService = FakeWalletService(
      walletInfo: const DemoWalletInfo(
        title: 'Reference Wallet Scaffold',
        network: WalletNetwork.testnet,
        descriptor: 'wpkh([demo/84h/1h/0h]tpubReferenceScaffold/0/*)#demo1234',
        descriptorLabel: 'Placeholder descriptor',
      ),
      transactions: const [
        TxDetails(
          txid:
              '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcd',
          sent: 0,
          received: 42000,
          balanceDelta: 42000,
          pending: false,
          blockHeight: 120,
        ),
        TxDetails(
          txid:
              'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890',
          sent: 1600,
          received: 0,
          balanceDelta: -1600,
          pending: true,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(
            StorageService(prefs: prefs),
          ),
          walletServiceProvider.overrideWithValue(fakeWalletService),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Use an Active Wallet'));
    await tester.pumpAndSettle();

    expect(find.text('Reference Wallet Scaffold'), findsNWidgets(2));
    expect(find.text('Load Reference Scaffold'), findsOneWidget);

    await tester.tap(find.text('Load Reference Scaffold'));
    await tester.pumpAndSettle();

    expect(find.text('Wallet Snapshot'), findsOneWidget);
    expect(find.text('Testnet 3'), findsOneWidget);
    expect(find.text('Placeholder descriptor'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('confirmed'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('+42000 sat'), findsOneWidget);
    expect(find.text('-1600 sat'), findsOneWidget);
    expect(find.text('123456...abcd'), findsOneWidget);
    expect(find.text('abcdef...7890'), findsOneWidget);
    expect(find.text('confirmed'), findsOneWidget);
    expect(find.text('pending'), findsOneWidget);
  });

  testWidgets(
    'Reference wallet scaffold supports the empty transaction state',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final fakeWalletService = FakeWalletService(
        walletInfo: const DemoWalletInfo(
          title: 'Reference Wallet Scaffold',
          network: WalletNetwork.testnet,
          descriptor:
              'wpkh([demo/84h/1h/0h]tpubReferenceScaffold/0/*)#demo1234',
          descriptorLabel: 'Placeholder descriptor',
        ),
        transactions: const [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(
              StorageService(prefs: prefs),
            ),
            walletServiceProvider.overrideWithValue(fakeWalletService),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Use an Active Wallet'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Load Reference Scaffold'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('No transactions yet'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('No transactions yet'), findsOneWidget);
    },
  );
}
