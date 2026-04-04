import 'package:flutter/material.dart';

TextTheme createTextTheme(Color textColor) {
  return TextTheme(
    displayLarge: _UbuntuTextStyle(
      fontSize: 96,
      fontWeight: FontWeight.w300,
      color: textColor,
    ),
    displayMedium: _UbuntuTextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      color: textColor,
    ),
    displaySmall: _UbuntuTextStyle(
      fontSize: 48,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    headlineLarge: _UbuntuTextStyle(
      fontSize: 40,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    headlineMedium: _UbuntuTextStyle(
      fontSize: 34,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    headlineSmall: _UbuntuTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    titleLarge: _UbuntuTextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    titleMedium: _UbuntuTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    titleSmall: _UbuntuTextStyle(
      fontSize: 14.66,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    bodyLarge: _UbuntuTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    bodyMedium: _UbuntuTextStyle(
      fontSize: 14.66,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    bodySmall: _UbuntuTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    labelLarge: _UbuntuTextStyle(
      fontSize: 14.66,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    labelMedium: _UbuntuTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
    labelSmall: _UbuntuTextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: textColor,
    ),
  );
}

class _UbuntuTextStyle extends TextStyle {
  const _UbuntuTextStyle({
    super.fontSize,
    super.fontWeight,
    required Color super.color,
  }) : super(
         fontFamily: 'packages/yaru/Ubuntu',
         letterSpacing: 0, // Override Material/Flutter's letter spacing
       );
}
