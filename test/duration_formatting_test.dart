import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DurationFormatting', () {
    test('toHoursMinutes pads hours and minutes to two digits', () {
      expect(const Duration(hours: 5, minutes: 15).toHoursMinutes(), '05:15');
      expect(const Duration(hours: 1, minutes: 2).toHoursMinutes(), '01:02');
      expect(const Duration(minutes: 90).toHoursMinutes(), '01:30');
    });

    test('toHoursMinutes handles zero', () {
      expect(Duration.zero.toHoursMinutes(), '00:00');
    });

    test('toHoursMinutes keeps hours above 24', () {
      expect(const Duration(hours: 26, minutes: 2).toHoursMinutes(), '26:02');
      expect(const Duration(hours: 100).toHoursMinutes(), '100:00');
    });

    test('toHoursMinutesSeconds pads all components', () {
      expect(
        const Duration(
          hours: 5,
          minutes: 15,
          seconds: 35,
        ).toHoursMinutesSeconds(),
        '05:15:35',
      );
      expect(const Duration(seconds: 59).toHoursMinutesSeconds(), '00:00:59');
    });

    test('toHoursMinutesSeconds handles zero and durations above 24h', () {
      expect(Duration.zero.toHoursMinutesSeconds(), '00:00:00');
      expect(
        const Duration(
          hours: 26,
          minutes: 2,
          seconds: 9,
        ).toHoursMinutesSeconds(),
        '26:02:09',
      );
    });
  });

  group('formatDurationHuman', () {
    test('formats zero and seconds only', () {
      expect(formatDurationHuman(Duration.zero), '0 s');
      expect(formatDurationHuman(const Duration(seconds: 12)), '12 s');
    });

    test('truncates seconds to whole minutes', () {
      expect(formatDurationHuman(const Duration(seconds: 90)), '1 min');
      expect(
        formatDurationHuman(const Duration(minutes: 59, seconds: 59)),
        '59 min',
      );
    });

    test('formats whole minutes', () {
      expect(formatDurationHuman(const Duration(minutes: 45)), '45 min');
    });

    test('pads minutes after hours', () {
      expect(
        formatDurationHuman(const Duration(hours: 1, minutes: 5)),
        '1 h 05 min',
      );
      expect(formatDurationHuman(const Duration(hours: 2)), '2 h 00 min');
      expect(
        formatDurationHuman(const Duration(hours: 1, minutes: 5, seconds: 30)),
        '1 h 05 min',
      );
    });

    test('keeps a leading minus sign', () {
      expect(formatDurationHuman(const Duration(seconds: -45)), '-45 s');
      expect(formatDurationHuman(const Duration(seconds: -90)), '-1 min');
      expect(
        formatDurationHuman(const Duration(hours: -1, minutes: -5)),
        '-1 h 05 min',
      );
    });
  });
}
