import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatBytes', () {
    test('keeps whole bytes below one kibibyte', () {
      expect(formatBytes(0), '0 B');
      expect(formatBytes(512), '512 B');
      expect(formatBytes(1023), '1023 B');
    });

    test('uses one decimal place from one kibibyte up', () {
      expect(formatBytes(1024), '1.0 KiB');
      expect(formatBytes(1536), '1.5 KiB');
      expect(formatBytes(1048576), '1.0 MiB');
      expect(formatBytes(3 * 1024 * 1024 * 1024), '3.0 GiB');
    });

    test('keeps the sign of negative values', () {
      expect(formatBytes(-2048), '-2.0 KiB');
    });
  });

  group('formatCompactNumber', () {
    test('keeps values below one thousand as digits', () {
      expect(formatCompactNumber(0), '0');
      expect(formatCompactNumber(999), '999');
    });

    test('adds the k, M, B and T suffixes', () {
      expect(formatCompactNumber(1200), '1.2k');
      expect(formatCompactNumber(2000), '2k');
      expect(formatCompactNumber(3400000), '3.4M');
      expect(formatCompactNumber(5000000000), '5B');
      expect(formatCompactNumber(2500000000000), '2.5T');
    });

    test('promotes a value that would round to 1000', () {
      expect(formatCompactNumber(999999), '1.0M');
    });

    test('keeps the sign of negative values', () {
      expect(formatCompactNumber(-1500), '-1.5k');
    });
  });

  group('formatPercent', () {
    test('formats a fraction with one decimal place', () {
      expect(formatPercent(0.256), '25.6 %');
      expect(formatPercent(0.005), '0.5 %');
    });

    test('drops trailing zeros', () {
      expect(formatPercent(0.25), '25 %');
      expect(formatPercent(0), '0 %');
      expect(formatPercent(1), '100 %');
    });

    test('honours the decimals argument', () {
      expect(formatPercent(0.2567, decimals: 2), '25.67 %');
      expect(formatPercent(0.25, decimals: 0), '25 %');
    });

    test('keeps the sign of negative fractions', () {
      expect(formatPercent(-0.125), '-12.5 %');
    });
  });
}
