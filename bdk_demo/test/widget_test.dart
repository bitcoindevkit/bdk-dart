import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bdk_demo/app/app.dart';
import 'package:bdk_demo/providers/settings_providers.dart';
import 'package:bdk_demo/services/storage_service.dart';

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
}
