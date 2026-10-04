import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

const String _charset =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

void main() {
  group('generateRandomString', () {
    test('returns a string of the requested length', () {
      expect(generateRandomString(0), '');
      expect(generateRandomString(1).length, 1);
      expect(generateRandomString(32).length, 32);
    });

    test('only uses characters from the documented charset', () {
      final result = generateRandomString(512);

      for (final unit in result.codeUnits) {
        expect(_charset.codeUnits, contains(unit));
      }
    });

    test('eventually uses every character in the charset', () {
      final observed = generateRandomString(5000).split('').toSet();

      expect(observed, _charset.split('').toSet());
    });

    test('produces different values on successive calls', () {
      expect(generateRandomString(32), isNot(equals(generateRandomString(32))));
    });
  });
}
