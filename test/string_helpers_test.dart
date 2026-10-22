import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('initialsOf', () {
    test('takes the first letters of the words', () {
      expect(initialsOf('Ada Lovelace'), 'AL');
      expect(initialsOf('Grace Brewster Hopper'), 'GB');
      expect(initialsOf('Plato'), 'P');
    });

    test('honours the count argument', () {
      expect(initialsOf('Grace Brewster Hopper', count: 3), 'GBH');
    });

    test('returns an empty string for empty text', () {
      expect(initialsOf(''), '');
      expect(initialsOf('   '), '');
    });
  });

  group('slugify', () {
    test('folds diacritics and joins words with dashes', () {
      expect(slugify('Příliš žluťoučký kůň'), 'prilis-zlutoucky-kun');
      expect(slugify('café au lait'), 'cafe-au-lait');
      expect(slugify('ÄÖÜ ß'), 'aou-ss');
    });

    test('drops other characters and collapses dashes', () {
      expect(slugify('Hello, World!'), 'hello-world');
      expect(slugify('  spaced  out  '), 'spaced-out');
      expect(slugify('a -- b'), 'a-b');
    });

    test('keeps digits', () {
      expect(slugify('Invoice 2026/42'), 'invoice-2026-42');
    });
  });

  group('truncateAtWord', () {
    test('cuts at the last word boundary before the limit', () {
      expect(truncateAtWord('The quick brown fox', 12), 'The quick…');
      expect(truncateAtWord('The quick brown fox', 10), 'The quick…');
    });

    test('keeps text that fits unchanged', () {
      expect(truncateAtWord('Short text', 20), 'Short text');
      expect(truncateAtWord('Short text', 10), 'Short text');
    });

    test('cuts long single words at the limit', () {
      expect(truncateAtWord('Supercalifragilistic', 8), 'Supercal…');
    });

    test('returns an empty string for a non-positive limit', () {
      expect(truncateAtWord('Anything', 0), '');
      expect(truncateAtWord('Anything', -3), '');
    });
  });

  group('Unicode text', () {
    test('initialsOf keeps complete characters', () {
      expect(initialsOf('𠮷田 太郎'), '𠮷太');
    });

    test('truncateAtWord keeps complete characters', () {
      expect(truncateAtWord('A😀BC', 2), 'A😀…');
    });

    test('slugify folds decomposed accents', () {
      expect(slugify('Při\u0301liš'), 'prilis');
    });
  });
}
