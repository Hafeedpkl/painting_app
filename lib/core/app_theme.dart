import 'package:flutter/material.dart';

class AppTheme {
  // static final AppTextStyle textStyle
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primarySwatch: Colors.green,
  );
  static ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primarySwatch: Colors.green);
}
