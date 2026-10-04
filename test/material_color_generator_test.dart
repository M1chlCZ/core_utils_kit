import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base = Color(0xFF3F51B5);

  group('generateMaterialColor', () {
    test('produces a complete swatch', () {
      final swatch = generateMaterialColor(base);

      expect(swatch.keys.toSet(), {
        50,
        100,
        200,
        300,
        400,
        500,
        600,
        700,
        800,
        900,
      });
      for (final shade in swatch.keys) {
        expect(swatch[shade], isNotNull, reason: 'missing shade $shade');
      }
    });

    test('keeps the original color at shade 500', () {
      final swatch = generateMaterialColor(base);

      expect(swatch[500], base);
      expect(swatch.toARGB32(), base.toARGB32());
    });

    test('derives tints and shades with the documented factors', () {
      final swatch = generateMaterialColor(base);

      expect(swatch[50], tintColor(base, 0.9));
      expect(swatch[100], tintColor(base, 0.8));
      expect(swatch[200], tintColor(base, 0.6));
      expect(swatch[300], tintColor(base, 0.4));
      expect(swatch[400], tintColor(base, 0.2));
      expect(swatch[600], shadeColor(base, 0.1));
      expect(swatch[700], shadeColor(base, 0.2));
      expect(swatch[800], shadeColor(base, 0.3));
      expect(swatch[900], shadeColor(base, 0.4));
    });
  });

  group('tint and shade helpers', () {
    test('tintValue clamps to the 0..255 range', () {
      expect(tintValue(0, 0), 0);
      expect(tintValue(0, 1), 255);
      expect(tintValue(255, 1), 255);
      expect(tintValue(0, 0.9), 230);
    });

    test('shadeValue clamps to the 0..255 range', () {
      expect(shadeValue(255, 0), 255);
      expect(shadeValue(0, 0.5), 0);
      expect(shadeValue(255, 1), 0);
      expect(shadeValue(255, 0.1), 229);
    });

    test('tintColor applies tintValue to every channel and keeps alpha', () {
      const color = Color(0xFF102030);
      final tinted = tintColor(color, 0.5);
      final argb = tinted.toARGB32();

      expect((argb >> 16) & 0xFF, tintValue(0x10, 0.5));
      expect((argb >> 8) & 0xFF, tintValue(0x20, 0.5));
      expect(argb & 0xFF, tintValue(0x30, 0.5));
      expect((argb >> 24) & 0xFF, 0xFF);
    });

    test('shadeColor applies shadeValue to every channel and keeps alpha', () {
      const color = Color(0xFF102030);
      final shaded = shadeColor(color, 0.5);
      final argb = shaded.toARGB32();

      expect((argb >> 16) & 0xFF, shadeValue(0x10, 0.5));
      expect((argb >> 8) & 0xFF, shadeValue(0x20, 0.5));
      expect(argb & 0xFF, shadeValue(0x30, 0.5));
      expect((argb >> 24) & 0xFF, 0xFF);
    });
  });
}
