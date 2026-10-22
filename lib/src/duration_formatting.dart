/// Formats [Duration] values as `HH:mm` or `HH:mm:ss` strings.
extension DurationFormatting on Duration {
  /// Converts this duration into a `HH:mm` string, for example `05:15`.
  ///
  /// The method does not wrap hours at 24, so a 26-hour duration formats as
  /// `26:02`.
  String toHoursMinutes() {
    final String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return '${_toTwoDigits(inHours)}:$twoDigitMinutes';
  }

  /// Converts this duration into a `HH:mm:ss` string, for example `05:15:35`.
  ///
  /// The method does not wrap hours at 24, so a 26-hour duration formats as
  /// `26:02:09`.
  String toHoursMinutesSeconds() {
    final String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    final String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return '${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  String _toTwoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }
}

/// Formats [duration] as a compact human-readable string.
///
/// The function truncates seconds, so 90 seconds read `1 min`. A duration
/// below one minute reads in seconds, for example `12 s`. A duration below
/// one hour reads in whole minutes, for example `45 min`. A longer duration
/// reads in hours and padded minutes, for example `1 h 05 min`. A negative
/// duration keeps a leading `-`.
String formatDurationHuman(Duration duration) {
  final int seconds = duration.inSeconds.abs();
  final String sign = duration.isNegative ? '-' : '';
  if (seconds < Duration.secondsPerMinute) {
    return '$sign$seconds s';
  }
  final int minutes = seconds ~/ Duration.secondsPerMinute;
  if (seconds < Duration.secondsPerHour) {
    return '$sign$minutes min';
  }
  final int hours = minutes ~/ Duration.minutesPerHour;
  final String paddedMinutes = minutes
      .remainder(Duration.minutesPerHour)
      .toString()
      .padLeft(2, '0');
  return '$sign$hours h $paddedMinutes min';
}
