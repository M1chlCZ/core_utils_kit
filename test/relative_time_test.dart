import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DateTime now = DateTime(2024, 3, 15, 12);

  group('formatRelativeTime', () {
    test('formats the current time and the last minute as just now', () {
      expect(formatRelativeTime(now, now: now), 'just now');
      expect(
        formatRelativeTime(now.subtract(const Duration(seconds: 59)), now: now),
        'just now',
      );
    });

    test('formats exactly one minute as 1 minute ago', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(seconds: 60)), now: now),
        '1 minute ago',
      );
    });

    test('formats minutes with singular and plural units', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(minutes: 2)), now: now),
        '2 minutes ago',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(minutes: 59)), now: now),
        '59 minutes ago',
      );
    });

    test('formats hours up to the day boundary', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(hours: 1)), now: now),
        '1 hour ago',
      );
      expect(
        formatRelativeTime(
          now.subtract(const Duration(hours: 23, minutes: 59)),
          now: now,
        ),
        '23 hours ago',
      );
    });

    test('formats 24 hours as one day, not yesterday', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(hours: 24)), now: now),
        '1 day ago',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 6)), now: now),
        '6 days ago',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 1)), now: now),
        '1 day ago',
      );
    });

    test('formats seven days as one week and truncates weeks', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 7)), now: now),
        '1 week ago',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 29)), now: now),
        '4 weeks ago',
      );
    });

    test('formats thirty days as one month and truncates months', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 30)), now: now),
        '1 month ago',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 364)), now: now),
        '12 months ago',
      );
    });

    test('formats 365 days as one year and truncates years', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 365)), now: now),
        '1 year ago',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 800)), now: now),
        '2 years ago',
      );
    });

    test('formats future times with in and keeps just now below a minute', () {
      expect(
        formatRelativeTime(now.add(const Duration(minutes: 5)), now: now),
        'in 5 minutes',
      );
      expect(
        formatRelativeTime(now.add(const Duration(hours: 2)), now: now),
        'in 2 hours',
      );
      expect(
        formatRelativeTime(now.add(const Duration(days: 1)), now: now),
        'in 1 day',
      );
      expect(
        formatRelativeTime(now.add(const Duration(seconds: 59)), now: now),
        'just now',
      );
    });
  });
}
