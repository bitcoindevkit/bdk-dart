import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bdk_demo/main.dart';

void main() {
  testWidgets('BDK demo shows onboarding copy and UI states', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('BDK Dart Reference Demo'), findsOneWidget);
    expect(find.text('Ready to run the demo'), findsOneWidget);
    expect(find.text('Idle'), findsOneWidget);
    expect(
      find.textContaining('constructs an example testnet descriptor in memory'),
      findsOneWidget,
    );
    expect(find.text('Load example testnet data'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('Loading'), findsOneWidget);
    expect(find.text('Loading example wallet data'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Success'), findsOneWidget);
    expect(find.text('Demo data loaded'), findsOneWidget);
    expect(find.text('Network'), findsOneWidget);
    expect(find.text('testnet'), findsOneWidget);
    expect(find.text('Descriptor preview'), findsOneWidget);
    expect(find.textContaining('wpkh('), findsOneWidget);
    expect(find.text('Status message'), findsOneWidget);
    expect(find.text('Reload demo data'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
