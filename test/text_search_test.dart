import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_search/text_search.dart';

void main() {
  const MethodChannel channel = MethodChannel('text_search');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TextSearch.platformVersion, '42');
  });
}
