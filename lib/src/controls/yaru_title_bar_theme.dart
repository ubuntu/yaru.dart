import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The title bar style.
enum YaruTitleBarStyle {
  /// The title bar is hidden.
  hidden,

  /// The title bar is shown without window controls.
  undecorated,

  /// The title bar is shown as normal.
  normal,
}

@immutable
class YaruTitleBarThemeData extends ThemeExtension<YaruTitleBarThemeData>
    with Diagnosticable {
  const YaruTitleBarThemeData({
    this.elevation = 0,
    this.centerTitle = true,
    this.titleSpacing,
    this.buttonSpacing = 14,
    this.buttonPadding = const EdgeInsets.symmetric(horizontal: 10),
    this.foregroundColor,
    this.backgroundColor,
    this.titleTextStyle,
    this.shape,
    this.border,
    this.style,
  });

  final double? elevation;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? buttonSpacing;
  final EdgeInsets? buttonPadding;
  final MaterialStateProperty<Color?>? foregroundColor;
  final MaterialStateProperty<Color?>? backgroundColor;
  final TextStyle? titleTextStyle;
  final ShapeBorder? shape;
  final BorderSide? border;
  final YaruTitleBarStyle? style;

  @override
  YaruTitleBarThemeData copyWith({
    double? elevation,
    bool? centerTitle,
    double? titleSpacing,
    double? buttonSpacing,
    EdgeInsets? buttonPadding,
    MaterialStateProperty<Color?>? foregroundColor,
    MaterialStateProperty<Color?>? backgroundColor,
    TextStyle? titleTextStyle,
    ShapeBorder? shape,
    BorderSide? border,
    YaruTitleBarStyle? style,
  }) {
    return YaruTitleBarThemeData(
      elevation: elevation ?? this.elevation,
      centerTitle: centerTitle ?? this.centerTitle,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      buttonSpacing: buttonSpacing ?? this.buttonSpacing,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      shape: shape ?? this.shape,
      border: border ?? this.border,
      style: style ?? this.style,
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
      buttonSpacing: lerpDouble(buttonSpacing, o?.buttonSpacing, t),
      buttonPadding: EdgeInsets.lerp(buttonPadding, o?.buttonPadding, t),
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
      border: BorderSide.lerp(
        border ?? BorderSide.none,
        o?.border ?? BorderSide.none,
        t,
      ),
      style: t < 0.5 ? style : o?.style,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DiagnosticsProperty('centerTitle', centerTitle));
    properties.add(DoubleProperty('titleSpacing', titleSpacing));
    properties.add(DoubleProperty('buttonSpacing', buttonSpacing));
    properties.add(DiagnosticsProperty('buttonPadding', buttonPadding));
    properties.add(DiagnosticsProperty('foregroundColor', foregroundColor));
    properties.add(DiagnosticsProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty('titleTextStyle', titleTextStyle));
    properties.add(DiagnosticsProperty('shape', shape));
    properties.add(DiagnosticsProperty('border', border));
    properties.add(DiagnosticsProperty('style', style));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruTitleBarThemeData &&
        other.elevation == elevation &&
        other.centerTitle == centerTitle &&
        other.titleSpacing == titleSpacing &&
        other.buttonSpacing == buttonSpacing &&
        other.buttonPadding == buttonPadding &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor &&
        other.titleTextStyle == titleTextStyle &&
        other.shape == shape &&
        other.border == border &&
        other.style == style;
  }

  @override
  int get hashCode {
    return Object.hash(
      elevation,
      centerTitle,
      titleSpacing,
      buttonSpacing,
      buttonPadding,
      foregroundColor,
      backgroundColor,
      titleTextStyle,
      shape,
      border,
      style,
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
