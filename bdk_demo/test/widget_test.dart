import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bdk_demo/main.dart';

void main() {
  testWidgets('BDK bindings demo test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial state shows the prompt message.
    expect(find.text('Press the button to load bindings'), findsOneWidget);
    expect(find.text('BDK bindings status'), findsOneWidget);
    expect(find.byIcon(Icons.network_check), findsOneWidget);

    // Verify the button exists.
    expect(find.text('Load Dart binding'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);

    // Tap the 'Load Dart binding' button and trigger a frame.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the network and descriptor are displayed.
    expect(find.textContaining('Network:'), findsOneWidget);
    expect(find.textContaining('testnet'), findsOneWidget);
    expect(find.textContaining('Descriptor sample:'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
