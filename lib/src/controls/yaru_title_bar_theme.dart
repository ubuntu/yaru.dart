import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class YaruTitleBarThemeData extends ThemeExtension<YaruTitleBarThemeData>
    with Diagnosticable {
  const YaruTitleBarThemeData({
    this.elevation = 0,
    this.centerTitle = true,
    this.titleSpacing,
    this.foregroundColor,
    this.backgroundColor,
    this.titleTextStyle,
    this.shape,
  });

  final double? elevation;
  final bool? centerTitle;
  final double? titleSpacing;
  final MaterialStateProperty<Color?>? foregroundColor;
  final MaterialStateProperty<Color?>? backgroundColor;
  final TextStyle? titleTextStyle;
  final ShapeBorder? shape;

  @override
  YaruTitleBarThemeData copyWith({
    double? elevation,
    bool? centerTitle,
    double? titleSpacing,
    MaterialStateProperty<Color?>? foregroundColor,
    MaterialStateProperty<Color?>? backgroundColor,
    TextStyle? titleTextStyle,
    ShapeBorder? shape,
  }) {
    return YaruTitleBarThemeData(
      elevation: elevation ?? this.elevation,
      centerTitle: centerTitle ?? this.centerTitle,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      shape: shape ?? this.shape,
    );
  }

  @override
  ThemeExtension<YaruTitleBarThemeData> lerp(
    ThemeExtension<YaruTitleBarThemeData>? other,
    double t,
  ) {
    final o = other as YaruTitleBarThemeData?;
    return YaruTitleBarThemeData(
      elevation: lerpDouble(elevation, o?.elevation, t),
      centerTitle: t < 0.5 ? centerTitle : o?.centerTitle,
      titleSpacing: lerpDouble(titleSpacing, o?.titleSpacing, t),
      foregroundColor: MaterialStateProperty.lerp<Color?>(
        foregroundColor,
        o?.foregroundColor,
        t,
        Color.lerp,
      ),
      backgroundColor: MaterialStateProperty.lerp<Color?>(
        backgroundColor,
        o?.backgroundColor,
        t,
        Color.lerp,
      ),
      titleTextStyle: TextStyle.lerp(titleTextStyle, o?.titleTextStyle, t),
      shape: ShapeBorder.lerp(shape, o?.shape, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty('centerTitle', centerTitle));
    properties.add(DoubleProperty('titleSpacing', titleSpacing));
    properties.add(DiagnosticsProperty('foregroundColor', foregroundColor));
    properties.add(DiagnosticsProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty('titleTextStyle', titleTextStyle));
    properties.add(DiagnosticsProperty('shape', shape));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruTitleBarThemeData &&
        other.elevation == elevation &&
        other.centerTitle == centerTitle &&
        other.titleSpacing == titleSpacing &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor &&
        other.titleTextStyle == titleTextStyle &&
        other.shape == shape;
  }

  @override
  int get hashCode {
    return Object.hash(
      elevation,
      centerTitle,
      titleSpacing,
      foregroundColor,
      backgroundColor,
      titleTextStyle,
      shape,
    );
  }
}

class YaruTitleBarTheme extends InheritedTheme {
  const YaruTitleBarTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruTitleBarThemeData data;

  static YaruTitleBarThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<YaruTitleBarTheme>();
    return theme?.data ??
        Theme.of(context).extension<YaruTitleBarThemeData>() ??
        const YaruTitleBarThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruTitleBarTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruTitleBarTheme oldWidget) {
    return data != oldWidget.data;
  }
}
