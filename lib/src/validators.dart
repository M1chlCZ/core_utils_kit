final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
final RegExp _e164 = RegExp(r'^\+[1-9][0-9]{1,14}$');

/// Returns true when [value] looks like an e-mail address.
///
/// The check accepts one `@`, no spaces before or after it, and a dot in the
/// domain. It is a shape check for forms, not an address verification.
bool isValidEmail(String value) => _email.hasMatch(value.trim());

/// Returns true when [value] is an absolute HTTP or HTTPS URL with a host.
///
/// Other schemes, relative paths, and empty hosts return false.
bool isValidUrl(String value) {
  final Uri? uri = Uri.tryParse(value.trim());
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}

/// Returns true when [value] is a valid IBAN in the sense of ISO 13616.
///
/// The check removes spaces, uppercases the text, verifies the length range,
/// moves the first four characters to the end, and confirms a MOD-97
/// remainder of one. Example: `CZ65 0800 0000 1920 0014 5399`.
bool isValidIban(String value) {
  final String compact = value.replaceAll(RegExp(r'\s'), '').toUpperCase();
  if (compact.length < 15 || compact.length > 34) {
    return false;
  }
  final String rearranged = compact.substring(4) + compact.substring(0, 4);
  var remainder = 0;
  for (final int unit in rearranged.codeUnits) {
    final String digits;
    if (unit >= 48 && unit <= 57) {
      digits = String.fromCharCode(unit);
    } else if (unit >= 65 && unit <= 90) {
      digits = (unit - 55).toString();
    } else {
      return false;
    }
    for (final int digit in digits.codeUnits) {
      remainder = (remainder * 10 + (digit - 48)) % 97;
    }
  }
  return remainder == 1;
}

/// Returns true when [value] is an E.164 phone number.
///
/// The check accepts a leading `+`, a first digit from 1 to 9, and at most 15
/// digits in total, for example `+420601123456`.
bool isValidE164Phone(String value) => _e164.hasMatch(value.trim());
