import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/url_launcher');
  final uri = Uri.parse('https://example.com/path');
  late List<Map<Object?, Object?>> launchCalls;

  setUp(() {
    launchCalls = <Map<Object?, Object?>>[];
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  void mockLaunches(List<Object?> results) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method != 'launch') {
            return null;
          }
          final index = launchCalls.length;
          launchCalls.add(Map<Object?, Object?>.from(call.arguments as Map));
          final result = index < results.length ? results[index] : results.last;
          if (result is PlatformException) {
            throw result;
          }
          return result;
        });
  }

  test('tries all three modes in fallback order and returns false', () async {
    mockLaunches([false, false, false]);

    expect(await openLink(uri), isFalse);
    expect(launchCalls, hasLength(3));

    expect(launchCalls[0]['url'], uri.toString());
    expect(launchCalls[0]['universalLinksOnly'], isTrue);
    expect(launchCalls[0]['useWebView'], isFalse);

    expect(launchCalls[1]['universalLinksOnly'], isFalse);
    expect(launchCalls[1]['useWebView'], isFalse);

    expect(launchCalls[2]['universalLinksOnly'], isFalse);
    expect(launchCalls[2]['useWebView'], isTrue);
  });

  test('stops at the first successful launch mode', () async {
    mockLaunches([false, true]);

    expect(await openLink(uri), isTrue);
    expect(launchCalls, hasLength(2));
    expect(launchCalls[1]['universalLinksOnly'], isFalse);
    expect(launchCalls[1]['useWebView'], isFalse);
  });

  test('returns the platformDefault result when earlier modes fail', () async {
    mockLaunches([false, false, true]);

    expect(await openLink(uri), isTrue);
    expect(launchCalls, hasLength(3));
  });

  test('falls through when a launch mode throws', () async {
    mockLaunches([PlatformException(code: 'boom'), true]);

    expect(await openLink(uri), isTrue);
    expect(launchCalls, hasLength(2));
  });

  test('swallows errors and returns false when every mode fails', () async {
    mockLaunches([
      PlatformException(code: 'boom'),
      PlatformException(code: 'boom'),
      PlatformException(code: 'boom'),
    ]);

    expect(await openLink(uri), isFalse);
    expect(launchCalls, hasLength(3));
  });
}
