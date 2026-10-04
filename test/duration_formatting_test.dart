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
}
