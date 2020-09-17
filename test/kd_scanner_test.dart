import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_scanner/kd_scanner.dart';

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

  test('scan', () async {
    expect(await scan(), '1234567890123');
  });
}
