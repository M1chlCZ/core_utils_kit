/// Formats [Duration] values as `HH:mm` or `HH:mm:ss` strings.
extension DurationFormatting on Duration {
  /// Converts this duration into a `HH:mm` string, for example `05:15`.
  ///
  /// Hours are not wrapped at 24, so a 26-hour duration formats as `26:02`.
  String toHoursMinutes() {
    final String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return '${_toTwoDigits(inHours)}:$twoDigitMinutes';
  }

  /// Converts this duration into a `HH:mm:ss` string, for example `05:15:35`.
  ///
  /// Hours are not wrapped at 24, so a 26-hour duration formats as `26:02:09`.
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
