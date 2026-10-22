import 'package:intl/intl.dart';

const List<String> _czechGenitiveMonths = <String>[
  'ledna',
  'února',
  'března',
  'dubna',
  'května',
  'června',
  'července',
  'srpna',
  'září',
  'října',
  'listopadu',
  'prosince',
];

String _languageOf(String locale) =>
    locale.split(RegExp('[-_]')).first.toLowerCase();

/// Formats [date] as a long date in [locale].
///
/// The default locale is `en`, which reads `March 15, 2024`. English and Czech
/// use built-in patterns, so they need no locale data initialization. Czech
/// long dates use genitive month names, for example `15. března 2024`.
/// Another locale delegates to `intl`. Call `initializeDateFormatting(locale)`
/// from `package:intl/date_symbol_data_local.dart` before you use another
/// locale.
String formatLongDate(DateTime date, {String locale = 'en'}) {
  switch (_languageOf(locale)) {
    case 'en':
      return DateFormat('MMMM d, y', 'en_US').format(date);
    case 'cs':
      return '${date.day}. ${_czechGenitiveMonths[date.month - 1]} '
          '${date.year}';
    default:
      return DateFormat.yMMMMd(locale).format(date);
  }
}

/// Formats [date] as a short numeric date in [locale].
///
/// The default locale is `en`, which reads `3/15/2024`. English and Czech use
/// explicit numeric patterns, so they need no locale data initialization.
/// Another locale delegates to `intl`. Call `initializeDateFormatting(locale)`
/// from `package:intl/date_symbol_data_local.dart` before you use another
/// locale.
String formatShortDate(DateTime date, {String locale = 'en'}) {
  switch (_languageOf(locale)) {
    case 'en':
      return DateFormat('M/d/y', 'en_US').format(date);
    case 'cs':
      return DateFormat('d. M. y', 'en_US').format(date);
    default:
      return DateFormat.yMd(locale).format(date);
  }
}

/// Formats [date] as a short date and time in [locale].
///
/// The default locale is `en`, which reads `3/15/2024 2:30 PM`. English and
/// Czech use explicit patterns, so they need no locale data initialization.
/// The Czech pattern uses a 24-hour clock, for example `15. 3. 2024 14:30`.
/// Another locale delegates to `intl`. Call `initializeDateFormatting(locale)`
/// from `package:intl/date_symbol_data_local.dart` before you use another
/// locale.
String formatShortDateTime(DateTime date, {String locale = 'en'}) {
  switch (_languageOf(locale)) {
    case 'en':
      return DateFormat('M/d/y h:mm a', 'en_US').format(date);
    case 'cs':
      return DateFormat('d. M. y H:mm', 'en_US').format(date);
    default:
      return DateFormat.yMd(locale).add_jm().format(date);
  }
}
