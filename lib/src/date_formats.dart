import 'package:intl/intl.dart';

/// Date and duration formatting helpers.
class DateFormats {
  DateFormats._();

  /// Returns the start of the current local day expressed in UTC and
  /// formatted as `yyyy-MM-dd HH:mm:ss`.
  ///
  /// The value is built from the current local date and timezone offset, then
  /// parsed and formatted again, matching the original app helper.
  static String utcDayStart() {
    final DateTime dateTime = DateTime.now();
    final String date = DateFormat('yyyy-MM-dd').format(dateTime);
    final String dateZero = '$date 00:00:00';
    String val = DateFormat(
      "yyyy-MM-dd'T'HH:mm:ss.SSS",
    ).format(DateTime.parse(dateZero));
    final Duration offset = dateTime.timeZoneOffset;
    final int hours = offset.inHours > 0 ? offset.inHours : 1;
    if (!offset.isNegative) {
      val =
          '$val+${offset.inHours.toString().padLeft(2, '0')}:'
          '${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}';
    } else {
      val =
          '$val-${(-offset.inHours).toString().padLeft(2, '0')}:'
          '${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}';
    }
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(val));
  }

  /// Formats [date] in [locale], or in the current locale when [locale] is
  /// omitted.
  ///
  /// [date] must be an ISO-8601 string accepted by [DateTime.parse]. The value
  /// is converted with [DateTime.toLocal] before formatting, so explicit UTC
  /// offsets, fractional offsets, and daylight-saving transitions are handled
  /// correctly. Returns an empty string when [date] is `null`.
  ///
  /// Locales other than `en` require their date symbol data to be initialized
  /// first, for example with `initializeDateFormatting(locale)` from
  /// `package:intl/date_symbol_data_local.dart`.
  static String convertDate(String? date, [String? locale]) {
    if (date == null) {
      return '';
    }
    final DateTime local = DateTime.parse(date).toLocal();
    return DateFormat.yMd(
      locale ?? Intl.getCurrentLocale(),
    ).add_jm().format(local);
  }

  /// Formats [d] as `d:h:m:s` tokens.
  ///
  /// Leading zero units are omitted, but once a unit is present every smaller
  /// unit is included. A zero duration formats as `0s`.
  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final int days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final int hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final int minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = <String>[];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }
}
