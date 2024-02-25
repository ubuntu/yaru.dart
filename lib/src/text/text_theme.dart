import 'package:flutter/material.dart';

TextTheme createTextTheme(Color textColor) {
  return TextTheme(
    displayLarge: _UbuntuTextStyle(
      fontSize: 96,
      fontWeight: FontWeight.w300,
      textColor: textColor,
    ),
    displayMedium: _UbuntuTextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      textColor: textColor,
    ),
    displaySmall: _UbuntuTextStyle(
      fontSize: 48,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    headlineLarge: _UbuntuTextStyle(
      fontSize: 40,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    headlineMedium: _UbuntuTextStyle(
      fontSize: 34,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    headlineSmall: _UbuntuTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    titleLarge: _UbuntuTextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      textColor: textColor,
    ),
    titleMedium: _UbuntuTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    titleSmall: _UbuntuTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      textColor: textColor,
    ),
    bodyLarge: _UbuntuTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    bodyMedium: _UbuntuTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    bodySmall: _UbuntuTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    labelLarge: _UbuntuTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      textColor: textColor,
    ),
    labelMedium: _UbuntuTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    labelSmall: _UbuntuTextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
  );
}

class _UbuntuTextStyle extends TextStyle {
  const _UbuntuTextStyle({
    super.fontSize,
    super.fontWeight,
    required this.textColor,
  }) : super(
          fontFamily: 'Ubuntu',
          package: 'yaru',
          color: textColor,
        );
  final Color textColor;
}
