import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines default property values for descendant [ToggleButton] widgets.
///
/// Descendant widgets obtain the current [YaruToggleButtonThemeData] object
/// using `YaruToggleButtonTheme.of(context)`. Instances of [YaruToggleButtonThemeData]
/// can be customized with [YaruToggleButtonThemeData.copyWith].
@immutable
class YaruToggleButtonThemeData
    extends ThemeExtension<YaruToggleButtonThemeData> with Diagnosticable {
  /// Creates a theme that can be used for [YaruToggleButtonTheme.data].
  const YaruToggleButtonThemeData({
    this.horizontalSpacing,
    this.verticalSpacing,
    this.titleStyle,
    this.subtitleStyle,
    this.mouseCursor,
  });

  /// The spacing between the indicator and the title.
  final double? horizontalSpacing;

  /// The spacing between the title and the subtitle.
  final double? verticalSpacing;

  /// The style of the title text.
  final TextStyle? titleStyle;

  /// The style of the subtitle text.
  final TextStyle? subtitleStyle;

  /// The mouse cursor.
  final MaterialStateProperty<MouseCursor?>? mouseCursor;

  /// Creates a copy with the given fields replaced with new values.
  @override
  YaruToggleButtonThemeData copyWith({
    double? horizontalSpacing,
    double? verticalSpacing,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    MaterialStateProperty<MouseCursor?>? mouseCursor,
  }) {
    return YaruToggleButtonThemeData(
      horizontalSpacing: horizontalSpacing ?? this.horizontalSpacing,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  @override
  ThemeExtension<YaruToggleButtonThemeData> lerp(
    ThemeExtension<YaruToggleButtonThemeData>? other,
    double t,
  ) {
    final o = other as YaruToggleButtonThemeData?;
    return YaruToggleButtonThemeData(
      horizontalSpacing: lerpDouble(horizontalSpacing, o?.horizontalSpacing, t),
      verticalSpacing: lerpDouble(verticalSpacing, o?.verticalSpacing, t),
      titleStyle: TextStyle.lerp(titleStyle, o?.titleStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, o?.subtitleStyle, t),
      mouseCursor: t < 0.5 ? mouseCursor : o?.mouseCursor,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      horizontalSpacing,
      verticalSpacing,
      titleStyle,
      subtitleStyle,
      mouseCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is YaruToggleButtonThemeData &&
        other.horizontalSpacing == horizontalSpacing &&
        other.verticalSpacing == verticalSpacing &&
        other.titleStyle == titleStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.mouseCursor == mouseCursor;
  }
}

/// Applies a theme to descendant [ToggleButton] widgets.
///
/// Descendant widgets obtain the current [YaruToggleButtonTheme] object using
/// [YaruToggleButtonTheme.of]. When a widget uses [YaruToggleButtonTheme.of],
/// it is automatically rebuilt if the theme later changes.
///
/// See also:
///
///  * [YaruToggleButtonThemeData], which describes the actual configuration of
///    a toggle button theme.
class YaruToggleButtonTheme extends InheritedWidget {
  /// Constructs a checkbox theme that configures all descendant [ToggleButton]
  /// widgets.
  const YaruToggleButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [ToggleButton] widgets.
  final YaruToggleButtonThemeData data;

  /// Returns the configuration [data] from the closest [YaruToggleButtonTheme]
  /// ancestor. If there is no ancestor, it returns `null`.
  static YaruToggleButtonThemeData? of(BuildContext context) {
    final t =
        context.dependOnInheritedWidgetOfExactType<YaruToggleButtonTheme>();
    return t?.data ?? Theme.of(context).extension<YaruToggleButtonThemeData>();
  }

  @override
  bool updateShouldNotify(YaruToggleButtonTheme oldWidget) {
    return data != oldWidget.data;
  }
}
