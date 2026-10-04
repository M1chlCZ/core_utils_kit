import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('DateFormats.utcDayStart', () {
    test('returns the local start of day converted to UTC', () {
      final result = DateFormats.utcDayStart();
      final now = DateTime.now();
      final expected = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime(now.year, now.month, now.day).toUtc());

      expect(result, expected);
    });
  });

  group('DateFormats.formatDuration', () {
    test('formats mixed units', () {
      expect(
        DateFormats.formatDuration(
          const Duration(days: 1, hours: 2, minutes: 3, seconds: 4),
        ),
        '1d:2h:3m:4s',
      );
      expect(
        DateFormats.formatDuration(
          const Duration(hours: 2, minutes: 3, seconds: 4),
        ),
        '2h:3m:4s',
      );
      expect(DateFormats.formatDuration(const Duration(minutes: 3)), '3m:0s');
      expect(DateFormats.formatDuration(const Duration(seconds: 5)), '5s');
      expect(
        DateFormats.formatDuration(const Duration(hours: 25)),
        '1d:1h:0m:0s',
      );
    });

    test('formats zero', () {
      expect(DateFormats.formatDuration(Duration.zero), '0s');
    });
  });

  group('DateFormats.convertDate', () {
    test('returns an empty string for null input', () {
      expect(DateFormats.convertDate(null), '');
    });

    test('formats a local timestamp with a fixed expected value', () {
      expect(
        DateFormats.convertDate('2024-03-15T10:30:00', 'en_US'),
        '3/15/2024 10:30\u202fAM',
      );
    });

    test('converts a UTC timestamp to local time', () {
      const iso = '2024-03-15T10:30:00Z';

      expect(DateFormats.convertDate(iso, 'en_US'), _expected(iso, 'en_US'));
    });

    test('handles a fractional +05:30 offset', () {
      const iso = '2024-06-01T09:15:00+05:30';

      expect(DateFormats.convertDate(iso, 'en_US'), _expected(iso, 'en_US'));
    });

    test('handles a negative -04:00 offset', () {
      const iso = '2024-11-02T23:45:00-04:00';

      expect(DateFormats.convertDate(iso, 'en_US'), _expected(iso, 'en_US'));
    });

    test('uses the offset at the parsed instant across DST changes', () {
      const iso = '2024-01-15T12:00:00Z';

      expect(DateFormats.convertDate(iso, 'en_US'), _expected(iso, 'en_US'));
    });

    test('formats non-English locales after initialization', () {
      const iso = '2024-03-15T10:30:00Z';

      expect(DateFormats.convertDate(iso, 'de_DE'), _expected(iso, 'de_DE'));
    });

    test('uses Intl.defaultLocale when no locale is given', () {
      final previous = Intl.defaultLocale;
      Intl.defaultLocale = 'de_DE';
      addTearDown(() => Intl.defaultLocale = previous);
      const iso = '2024-03-15T10:30:00';

      expect(DateFormats.convertDate(iso), _expected(iso, 'de_DE'));
    });
  });
}

String _expected(String iso, String locale) =>
    DateFormat.yMd(locale).add_jm().format(DateTime.parse(iso).toLocal());
