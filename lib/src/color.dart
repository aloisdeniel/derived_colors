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
    @required this.regular,
    @required this.light,
    @required this.dark,
    @required this.invert,
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
    return hsl.withLightness(lightness).toColor();
  }

  /// Finds a darker variant of the color.
  Color findDark() {
    final hsl = HSLColor.fromColor(this);
    final luminance = computeLuminance();
    const baseLuminance = 0.29;
    final luminanceDelta = (0.53 - luminance);
    final targetLuminance =
        (baseLuminance + (luminanceDelta * 0.53)).roundToDouble();
    final lightness = math.max(baseLuminance, targetLuminance);
    return hsl.withLightness(lightness).toColor();
  }

  /// Find a subtle variant of a color (for example, for displaying hover states).
  ///
  /// The [amount] (defaults to `0.06`) is substracted from color lightness is lightness is
  /// greater than [darkenLimit] (defaults to `0.2`), else it is added to color lightness.
  Color decline([double amount = 0.06, double darkenLimit = 0.2]) {
    if (amount == null) return this;
    final hsl = HSLColor.fromColor(this);
    if (hsl.lightness > 0.2) {
      return darken(amount);
    }
    return lighten(amount);
  }

  /// Darken the color by removing the given [amount] to lightness.
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness(
          (hsl.lightness - amount).clamp(0, 1),
        )
        .toColor();
  }

  /// Lighten the color by adding the given [amount] to lightness.
  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness(
          (hsl.lightness + amount).clamp(0, 1),
        )
        .toColor();
  }
}

/// Keep a global cache for already calculated variants.
final Map<Color, ColorVariants> _cache = {};
