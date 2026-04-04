import 'package:flutter/material.dart';

TextTheme createTextTheme({
  required Color textColor,
  String? fontFamily,
  List<String>? fontFamilyFallback,
}) {
  return TextTheme(
    displayLarge: _UbuntuTextStyle(
      fontSize: 96,
      fontWeight: FontWeight.w300,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    displayMedium: _UbuntuTextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    displaySmall: _UbuntuTextStyle(
      fontSize: 48,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headlineLarge: _UbuntuTextStyle(
      fontSize: 40,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headlineMedium: _UbuntuTextStyle(
      fontSize: 34,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headlineSmall: _UbuntuTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    titleLarge: _UbuntuTextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    titleMedium: _UbuntuTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    titleSmall: _UbuntuTextStyle(
      fontSize: 14.66,
      fontWeight: FontWeight.w500,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodyLarge: _UbuntuTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodyMedium: _UbuntuTextStyle(
      fontSize: 14.66,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodySmall: _UbuntuTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    labelLarge: _UbuntuTextStyle(
      fontSize: 14.66,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    labelMedium: _UbuntuTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    labelSmall: _UbuntuTextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
  );
}

class _UbuntuTextStyle extends TextStyle {
  const _UbuntuTextStyle({
    super.fontSize,
    super.fontWeight,
    required Color super.color,
    String? fontFamily,
    super.fontFamilyFallback,
  }) : super(
         fontFamily: fontFamily ?? 'packages/yaru/Ubuntu',
         letterSpacing: 0, // Override Material/Flutter's letter spacing
       );
}
