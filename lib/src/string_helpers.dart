import 'package:characters/characters.dart';

const Map<String, String> _foldedLetters = <String, String>{
  'á': 'a',
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'ã': 'a',
  'å': 'a',
  'ā': 'a',
  'ç': 'c',
  'č': 'c',
  'ď': 'd',
  'đ': 'd',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'ě': 'e',
  'ē': 'e',
  'í': 'i',
  'ì': 'i',
  'î': 'i',
  'ï': 'i',
  'ī': 'i',
  'ľ': 'l',
  'ĺ': 'l',
  'ñ': 'n',
  'ň': 'n',
  'ó': 'o',
  'ò': 'o',
  'ô': 'o',
  'ö': 'o',
  'õ': 'o',
  'ø': 'o',
  'ō': 'o',
  'ř': 'r',
  'ŕ': 'r',
  'š': 's',
  'ť': 't',
  'ú': 'u',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ů': 'u',
  'ū': 'u',
  'ý': 'y',
  'ÿ': 'y',
  'ž': 'z',
  'ß': 'ss',
  'æ': 'ae',
  'œ': 'oe',
};

/// Returns up to [count] initials of the words in [name].
///
/// The letters are uppercase: `Ada Lovelace` reads `AL` and
/// `Grace Brewster Hopper` reads `GB`. Empty text returns an empty string.
String initialsOf(String name, {int count = 2}) {
  final List<String> words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) {
    return '';
  }
  return words
      .take(count)
      .map((String word) => word.characters.first.toUpperCase())
      .join();
}

/// Turns text into a lowercase ASCII slug with single dashes.
///
/// Diacritics are folded first: `Příliš žluťoučký kůň` reads
/// `prilis-zlutoucky-kun`. Other characters become dashes, repeated dashes
/// collapse, and leading and trailing dashes are removed.
String slugify(String text) {
  final String lower = text.toLowerCase();
  final StringBuffer buffer = StringBuffer();
  for (final int unit in lower.runes) {
    if (_isCombiningMark(unit)) {
      continue;
    }
    final String character = String.fromCharCode(unit);
    final String folded = _foldedLetters[character] ?? character;
    for (final int foldedUnit in folded.codeUnits) {
      final bool letter = foldedUnit >= 97 && foldedUnit <= 122;
      final bool digit = foldedUnit >= 48 && foldedUnit <= 57;
      buffer.write(letter || digit ? String.fromCharCode(foldedUnit) : '-');
    }
  }
  return buffer
      .toString()
      .replaceAll(RegExp('-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

/// Shortens text to at most [maxLength] characters at a word boundary.
///
/// Cut text ends with an ellipsis: `The quick brown fox` with 12 reads
/// `The quick…`. Text that fits stays unchanged, and a non-positive
/// [maxLength] returns an empty string.
String truncateAtWord(String text, int maxLength) {
  if (maxLength <= 0) {
    return '';
  }
  final Characters characters = text.characters;
  if (characters.length <= maxLength) {
    return text;
  }
  final String prefix = characters.take(maxLength).toString();
  final int space = prefix.lastIndexOf(' ');
  final String cut = space > 0 ? prefix.substring(0, space) : prefix;
  return '${cut.trimRight()}…';
}

bool _isCombiningMark(int rune) {
  return (rune >= 0x0300 && rune <= 0x036F) ||
      (rune >= 0x1AB0 && rune <= 0x1AFF) ||
      (rune >= 0x1DC0 && rune <= 0x1DFF) ||
      (rune >= 0x20D0 && rune <= 0x20FF) ||
      (rune >= 0xFE20 && rune <= 0xFE2F);
}
