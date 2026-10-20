/// Formats a byte count with binary units.
///
/// Values below 1024 read as whole bytes, `512 B`. Larger values use one
/// decimal place and the units KiB, MiB, GiB, TiB and PiB: `1.5 KiB`,
/// `2.0 MiB`. Negative values keep their sign.
String formatBytes(int bytes) {
  const List<String> units = <String>['B', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB'];
  final bool negative = bytes < 0;
  double value = bytes.abs().toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final String text = unit == 0
      ? value.round().toString()
      : value.toStringAsFixed(1);
  return '${negative ? '-' : ''}$text ${units[unit]}';
}
