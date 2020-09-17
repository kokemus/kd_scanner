// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kd_scanner_example/main.dart';

void main() {
  const MethodChannel channel = MethodChannel('kd_scanner');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '1234567890123';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  testWidgets('Verify initial state', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('Scan code', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('1234567890123'), findsOneWidget);
  });
}
