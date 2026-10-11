import 'dart:math';

const String _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

final Random _random = Random();

/// Generates a random string of [length] characters.
///
/// The function draws characters from the ASCII letters and digits in the
/// original app charset (`A-Z`, `a-z`, `0-9`). [length] must not be negative.
/// The function throws an [ArgumentError] otherwise.
///
/// The function uses [Random], which is not cryptographically secure. Do not
/// use the result for security tokens, passwords, or keys.
String generateRandomString(int length) {
  if (length < 0) {
    throw ArgumentError.value(length, 'length', 'must not be negative');
  }
  return String.fromCharCodes(
    Iterable<int>.generate(
      length,
      (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
    ),
  );
}
