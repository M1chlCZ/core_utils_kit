import 'dart:math';

const String _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

final Random _random = Random();

/// Generates a random string of [length] characters.
///
/// Characters are drawn from the ASCII letters and digits in the original
/// app charset (`A-Z`, `a-z`, `0-9`).
String generateRandomString(int length) => String.fromCharCodes(
  Iterable<int>.generate(
    length,
    (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
  ),
);
