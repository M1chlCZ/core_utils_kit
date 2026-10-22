/// Formats [time] as a short relative phrase in English.
///
/// The function compares [time] with [now] and truncates the difference to a
/// whole unit. The ladder starts with `just now` below 60 seconds and then
/// continues with minutes, hours, days, weeks, months, and years. A month
/// holds 30 days and a year holds 365 days. A past time reads `5 minutes ago`,
/// and a future time reads `in 5 minutes`. Callers can localize the result by
/// wrapping this function.
String formatRelativeTime(DateTime time, {DateTime? now}) {
  final DateTime reference = now ?? DateTime.now();
  final bool isFuture = time.isAfter(reference);
  final Duration difference = isFuture
      ? time.difference(reference)
      : reference.difference(time);
  final int seconds = difference.inSeconds;
  if (seconds < Duration.secondsPerMinute) {
    return 'just now';
  }
  final int value;
  final String unit;
  if (seconds < Duration.secondsPerHour) {
    value = seconds ~/ Duration.secondsPerMinute;
    unit = 'minute';
  } else if (seconds < Duration.secondsPerDay) {
    value = seconds ~/ Duration.secondsPerHour;
    unit = 'hour';
  } else if (seconds < 7 * Duration.secondsPerDay) {
    value = seconds ~/ Duration.secondsPerDay;
    unit = 'day';
  } else if (seconds < 30 * Duration.secondsPerDay) {
    value = seconds ~/ (7 * Duration.secondsPerDay);
    unit = 'week';
  } else if (seconds < 365 * Duration.secondsPerDay) {
    value = seconds ~/ (30 * Duration.secondsPerDay);
    unit = 'month';
  } else {
    value = seconds ~/ (365 * Duration.secondsPerDay);
    unit = 'year';
  }
  final String phrase = value == 1 ? '1 $unit' : '$value ${unit}s';
  return isFuture ? 'in $phrase' : '$phrase ago';
}
