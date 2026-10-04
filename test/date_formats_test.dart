import 'dart:io';

import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('DateFormats.utcDayStart', () {
    test('returns the start of the local day in the expected pattern', () {
      final result = DateFormats.utcDayStart();

      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$')));

      final parsed = DateFormat('yyyy-MM-dd HH:mm:ss').parse(result, true);
      final today = DateTime.now().toUtc();
      final dateDelta = DateTime.utc(
        parsed.year,
        parsed.month,
        parsed.day,
      ).difference(DateTime.utc(today.year, today.month, today.day)).inDays;

      expect(dateDelta.abs(), lessThanOrEqualTo(1));
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
    test('formats a known UTC timestamp in the current locale', () {
      const iso = '2024-03-15T10:30:00Z';

      expect(DateFormats.convertDate(iso), _expectedConvertDate(iso));
    });

    test('formats a timestamp with an explicit offset', () {
      const iso = '2024-11-02T23:45:00+02:00';

      expect(DateFormats.convertDate(iso), _expectedConvertDate(iso));
    });
  });
}

String _expectedConvertDate(String iso) {
  final dt = DateTime.parse(iso);
  final now = DateTime.now();
  final fixed = now.timeZoneOffset.isNegative
      ? dt.subtract(Duration(hours: now.timeZoneOffset.inHours))
      : dt.add(Duration(hours: now.timeZoneOffset.inHours));
  return DateFormat.yMd(Platform.localeName).add_jm().format(fixed);
}
