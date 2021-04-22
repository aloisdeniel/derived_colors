import 'package:flutter/widgets.dart';
import 'dart:math' as math;

/// A set of color variants base on a [regular] color.
///
/// A set can be generated automatically from the [ColorVariants.fromRegular] factory.
class ColorVariants {
  /// A color that fits well as the foreground of the [regular] color.
  final Color invert;

  /// A very light variant of the [regular] color.
  final Color light;

  /// A dark variant of the [regular] color.
  final Color dark;

  /// The base color.
  final Color regular;

  /// Creates a new set of variants from all the colors.
  const ColorVariants({
    required this.regular,
    required this.light,
    required this.dark,
    required this.invert,
  });

  /// Generates automatically variants, based on an input [color].
  ///
  /// The methods used for generating variants are [findInvert], [findDark] and [findLight].
  factory ColorVariants.fromRegular(Color color) {
    return ColorVariants(
      regular: color,
      invert: color.findInvert(),
      dark: color.findDark(),
      light: color.findLight(),
    );
  }
}

/// A set of extensions for processing colors.
extension ColorExtenions on Color {
  /// Gets a set of color variants for the color.
  ///
  /// The calculated variants are globally cached.
  ColorVariants get variants {
    return _cache.putIfAbsent(this, () => ColorVariants.fromRegular(this));
  }

  /// Finds an invert color which results a black or white color regarding
  /// the color luminance.
  Color findInvert() {
    final luminance = computeLuminance();
    if (luminance > 0.55) {
      return const Color(0xFF000000).withOpacity(0.7);
    }
    return const Color(0xFFFFFFFF);
  }

  /// Finds a lighter variant of the color.
  Color findLight() {
    final hsl = HSLColor.fromColor(this);
    var lightness = math.max(0.96, hsl.lightness);

    if (_isWhiteOrBlack) {
      final v = (lightness * 255).round().clamp(0, 255);
      return Color.fromARGB(alpha, v, v, v);
    }

    return hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
  }

  /// Finds a darker variant of the color.
  Color findDark() {
    final hsl = HSLColor.fromColor(this);
    final luminance = computeLuminance();
    const baseLuminance = 0.30;
    final luminanceDelta = 0.15;
    final lightness = baseLuminance +
        luminanceDelta * ((luminance - 0.5) * 2.0).clamp(0.0, 1.0);

    if (_isWhiteOrBlack) {
      final v = (lightness * 255).round().clamp(0, 255);
      return Color.fromARGB(alpha, v, v, v);
    }

    return hsl
        .withLightness(lightness)
        .withSaturation(_isWhiteOrBlack ? 0 : hsl.saturation)
        .toColor();
  }

  /// Find a subtle variant of a color (for example, for displaying hover states).
  ///
  /// The [amount] (defaults to `0.06`) is substracted from color lightness is lightness if
  /// greater than [darkenLimit] (defaults to `0.2`), else it is added to color lightness.
  Color subtle([double amount = 0.06, double darkenLimit = 0.2]) {
    final hsl = HSLColor.fromColor(this);
    if (hsl.lightness > darkenLimit) {
      amount *= -1.0;
    }

    if (_isWhiteOrBlack) {
      final v = (red + amount * 255).round().clamp(0, 255);
      return Color.fromARGB(alpha, v, v, v);
    }

    return hsl
        .withLightness(
          (hsl.lightness + amount).clamp(0.0, 1.0),
        )
        .toColor();
  }

  /// Darken the color by removing the given [amount] to lightness.
  Color darken([double amount = 0.06]) => lighten(-amount);

  /// Lighten the color by adding the given [amount] to lightness.
  Color lighten([double amount = 0.06]) {
    if (_isWhiteOrBlack) {
      final v = (red + amount * 255).round().clamp(0, 255);
      return Color.fromARGB(alpha, v, v, v);
    }

    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness(
          (hsl.lightness + amount).clamp(0.0, 1.0),
        )
        .toColor();
  }

  bool get _isWhiteOrBlack =>
      (red == 0 && blue == 0 && green == 0) ||
      (red == 255 && blue == 255 && green == 255);
}

/// Keep a global cache for already calculated variants.
final Map<Color, ColorVariants> _cache = {};
