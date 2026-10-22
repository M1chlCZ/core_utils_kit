import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DateTime date = DateTime(2024, 3, 15, 14, 30);

  group('formatLongDate', () {
    test('formats English long dates without initialization', () {
      expect(formatLongDate(date), 'March 15, 2024');
      expect(formatLongDate(DateTime(2024, 1, 5)), 'January 5, 2024');
      expect(formatLongDate(date, locale: 'en_US'), 'March 15, 2024');
      expect(formatLongDate(date, locale: 'en-GB'), 'March 15, 2024');
    });

    test('formats Czech long dates with genitive month names', () {
      expect(formatLongDate(date, locale: 'cs'), '15. března 2024');
      expect(
        formatLongDate(DateTime(2024, 1, 5), locale: 'cs'),
        '5. ledna 2024',
      );
    });
  });

  group('formatShortDate', () {
    test('formats English short dates without initialization', () {
      expect(formatShortDate(date), '3/15/2024');
      expect(formatShortDate(date, locale: 'en_GB'), '3/15/2024');
    });

    test('formats Czech short dates without initialization', () {
      expect(formatShortDate(date, locale: 'cs'), '15. 3. 2024');
      expect(formatShortDate(DateTime(2024, 1, 5), locale: 'cs'), '5. 1. 2024');
    });
  });

  group('formatShortDateTime', () {
    test('formats English short date and time without initialization', () {
      expect(formatShortDateTime(date), '3/15/2024 2:30 PM');
    });

    test('formats Czech short date and time with a 24-hour clock', () {
      expect(formatShortDateTime(date, locale: 'cs'), '15. 3. 2024 14:30');
      expect(
        formatShortDateTime(DateTime(2024, 1, 5, 9, 5), locale: 'cs'),
        '5. 1. 2024 9:05',
      );
    });
  });
}
