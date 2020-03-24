import 'package:flutter/material.dart';

class Swatch {
  final Color primary;
  final Color info;
  final Color link;
  final Color danger;
  final Color success;
  final Color warning;
  final Color grey;

  const Swatch({
    @required this.primary,
    @required this.info,
    @required this.link,
    @required this.danger,
    @required this.success,
    @required this.warning,
    @required this.grey,
  });
}

final bulma = Swatch(
  primary: HSLColor.fromAHSL(1.0, 171, 1.0, 0.41).toColor(),
  info: HSLColor.fromAHSL(1.0, 204, 0.86, 0.53).toColor(),
  link: HSLColor.fromAHSL(1.0, 217, 0.71, 0.53).toColor(),
  danger: HSLColor.fromAHSL(1.0, 348, 1.0, 0.61).toColor(),
  success: HSLColor.fromAHSL(1.0, 141, 0.71, 0.48).toColor(),
  warning: HSLColor.fromAHSL(1.0, 48, 1.0, 0.67).toColor(),
  grey: HSLColor.fromAHSL(1.0, 0, 0, 0.48).toColor(),
);
