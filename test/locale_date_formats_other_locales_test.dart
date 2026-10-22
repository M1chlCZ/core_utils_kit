import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('de_DE');
  });

  final DateTime date = DateTime(2024, 3, 15, 14, 30);

  group('other locales delegate to intl', () {
    test('formats long dates after initialization', () {
      expect(formatLongDate(date, locale: 'de_DE'), '15. März 2024');
    });

    test('formats short dates after initialization', () {
      expect(formatShortDate(date, locale: 'de_DE'), '15.3.2024');
    });

    test('formats short date and time after initialization', () {
      expect(formatShortDateTime(date, locale: 'de_DE'), '15.3.2024 14:30');
    });
  });
}
