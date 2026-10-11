import 'package:intl/intl.dart';

/// Date and duration formatting helpers.
class DateFormats {
  DateFormats._();

  /// Returns the start of the current local day as a UTC string in
  /// `yyyy-MM-dd HH:mm:ss` format.
  ///
  /// The helper builds the value from the current local date and the current
  /// timezone offset. It parses and formats the result again, matching the
  /// original app helper.
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

  /// Formats [date] in [locale]. When you omit [locale], the method uses the
  /// current locale.
  ///
  /// [date] must be an ISO-8601 string accepted by [DateTime.parse]. The
  /// method converts the value with [DateTime.toLocal] before formatting, so
  /// explicit UTC offsets, fractional offsets, and daylight-saving transitions
  /// work correctly. Returns an empty string when [date] is `null`.
  ///
  /// For a locale other than `en`, call `initializeDateFormatting(locale)` from
  /// `package:intl/date_symbol_data_local.dart` first to load the date symbol
  /// data.
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
  /// The method omits leading zero units, but includes every smaller unit once
  /// a unit is present. It formats a zero duration as `0s`.
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
