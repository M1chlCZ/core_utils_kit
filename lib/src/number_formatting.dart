/// Formats a count in a compact form with the k, M, B and T suffixes.
///
/// Values below 1000 keep their digits, 1200 reads `1.2k`, and whole values
/// drop the decimal part: `2k`, `3M`. Negative values keep their sign.
String formatCompactNumber(num value) {
  const List<String> suffixes = <String>['', 'k', 'M', 'B', 'T'];
  final bool negative = value < 0;
  double number = value.abs().toDouble();
  var index = 0;
  while (number >= 1000 && index < suffixes.length - 1) {
    number /= 1000;
    index++;
  }
  String text = number == number.roundToDouble()
      ? number.round().toString()
      : number.toStringAsFixed(1);
  if (text == '1000.0' && index < suffixes.length - 1) {
    number /= 1000;
    index++;
    text = number.toStringAsFixed(1);
  }
  return '${negative ? '-' : ''}$text${suffixes[index]}';
}

/// Formats a fraction between 0 and 1 as a percentage.
///
/// 0.256 reads `25.6 %` and 0.25 reads `25 %`. [decimals] sets the number of
/// decimal places and trims trailing zeros. Negative fractions keep their
/// sign.
String formatPercent(num fraction, {int decimals = 1}) {
  final num percent = fraction * 100;
  var text = percent.toStringAsFixed(decimals);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'\.?0+$'), '');
  }
  return '$text %';
}
