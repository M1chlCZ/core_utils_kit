import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidEmail', () {
    test('accepts common address shapes', () {
      expect(isValidEmail('ada@example.com'), isTrue);
      expect(isValidEmail('a.b+c@sub.example.co'), isTrue);
      expect(isValidEmail('  ada@example.com  '), isTrue);
    });

    test('rejects broken addresses', () {
      for (final String value in <String>[
        '',
        'ada',
        'ada@',
        '@example.com',
        'ada@example',
        'ada example@example.com',
        'ada@@example.com',
      ]) {
        expect(isValidEmail(value), isFalse, reason: value);
      }
    });
  });

  group('isValidUrl', () {
    test('accepts absolute HTTP and HTTPS URLs with a host', () {
      expect(isValidUrl('https://example.com'), isTrue);
      expect(isValidUrl('http://example.com/path?q=1'), isTrue);
      expect(isValidUrl('  https://example.com  '), isTrue);
    });

    test('rejects other schemes and relative text', () {
      for (final String value in <String>[
        '',
        'example.com',
        'ftp://example.com',
        'https://',
        'not a url',
      ]) {
        expect(isValidUrl(value), isFalse, reason: value);
      }
    });
  });

  group('isValidIban', () {
    test('accepts known IBANs with and without spaces', () {
      expect(isValidIban('CZ65 0800 0000 1920 0014 5399'), isTrue);
      expect(isValidIban('cz6508000000192000145399'), isTrue);
      expect(isValidIban('DE89 3704 0044 0532 0130 00'), isTrue);
    });

    test('rejects a changed digit and broken shapes', () {
      expect(isValidIban('CZ65 0800 0000 1920 0014 5398'), isFalse);
      expect(isValidIban('CZ65'), isFalse);
      expect(isValidIban('CZ65 0800 0000 1920 0014 539*'), isFalse);
    });

    test('rejects a structure that only satisfies MOD-97', () {
      expect(isValidIban('000100000000000'), isFalse);
      expect(isValidIban('CZ658000000192000145399'), isFalse);
    });
  });

  group('isValidE164Phone', () {
    test('accepts international numbers', () {
      expect(isValidE164Phone('+420601123456'), isTrue);
      expect(isValidE164Phone('+123456789012345'), isTrue);
    });

    test(
      'rejects numbers without a plus, with a leading zero or with spaces',
      () {
        for (final String value in <String>[
          '420601123456',
          '+0123456789',
          '+1 234 567',
          '+1234567890123456',
          '',
        ]) {
          expect(isValidE164Phone(value), isFalse, reason: value);
        }
      },
    );
  });
}
