import 'dart:math';

import 'package:material_ui/material_ui.dart';

/// Builds a [MaterialColor] swatch from [color].
///
/// Shade 500 is [color] itself, including its alpha. The helper derives every
/// other shade with [tintColor] or [shadeColor], which force alpha to 1. The
/// factors match the original app utility.
MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.toARGB32(), <int, Color>{
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

/// Mixes [value] toward 255 by [factor]. The result stays in the `0..255`
/// range.
int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

/// Lightens every channel of [color] by [factor].
Color tintColor(Color color, double factor) => Color.fromRGBO(
  tintValue(_red(color), factor),
  tintValue(_green(color), factor),
  tintValue(_blue(color), factor),
  1,
);

/// Darkens [value] by [factor]. The result stays in the `0..255` range.
int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

/// Darkens every channel of [color] by [factor].
Color shadeColor(Color color, double factor) => Color.fromRGBO(
  shadeValue(_red(color), factor),
  shadeValue(_green(color), factor),
  shadeValue(_blue(color), factor),
  1,
);

int _red(Color color) => (color.toARGB32() >> 16) & 0xFF;

int _green(Color color) => (color.toARGB32() >> 8) & 0xFF;

int _blue(Color color) => color.toARGB32() & 0xFF;
