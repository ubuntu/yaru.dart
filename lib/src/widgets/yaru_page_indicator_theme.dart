import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'yaru_page_indicator.dart';

/// Defines default property values for descendant [YaruPageIndicator] widgets.
///
/// Descendant widgets obtain the current [YaruPageIndicatorThemeData] object
/// using `YaruPageIndicatorTheme.of(context)`. Instances of [YaruPageIndicatorThemeData]
/// can be customized with [YaruPageIndicatorThemeData.copyWith].
@immutable
class YaruPageIndicatorThemeData
    extends ThemeExtension<YaruPageIndicatorThemeData> with Diagnosticable {
  /// Creates a theme that can be used for [YaruPageIndicatorTheme.data].
  const YaruPageIndicatorThemeData({
    this.animationDuration,
    this.animationCurve,
    this.dotSize,
    this.dotSpacing,
    this.dotDecorationBuilder,
  });

  /// Duration of a transition between two items.
  /// Use [Duration.zero] (defaults) to disable transition.
  final Duration? animationDuration;

  /// Curve used in a transition between two items.
  final Curve? animationCurve;

  /// Size of the dots.
  final double? dotSize;

  /// Base length for the space between the dots.
  /// Will be automatically reduced to fit the vertical constraints.
  final double? dotSpacing;

  /// Decoration of the dots.
  final DotDecorationBuilder? dotDecorationBuilder;

  /// Creates a copy with the given fields replaced with new values.
  @override
  YaruPageIndicatorThemeData copyWith({
    Duration? animationDuration,
    Curve? animationCurve,
    double? dotSize,
    double? dotSpacing,
    DotDecorationBuilder? dotDecorationBuilder,
  }) {
    return YaruPageIndicatorThemeData(
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      dotSize: dotSize ?? this.dotSize,
      dotSpacing: dotSpacing ?? this.dotSpacing,
      dotDecorationBuilder: dotDecorationBuilder ?? this.dotDecorationBuilder,
    );
  }

  @override
  ThemeExtension<YaruPageIndicatorThemeData> lerp(
    ThemeExtension<YaruPageIndicatorThemeData>? other,
    double t,
  ) {
    final o = other as YaruPageIndicatorThemeData?;
    return YaruPageIndicatorThemeData(
      animationDuration: lerpDuration(
        animationDuration ?? Duration.zero,
        o?.animationDuration ?? Duration.zero,
        t,
      ),
      animationCurve: t < 0.5 ? animationCurve : o?.animationCurve,
      dotSize: lerpDouble(dotSize, o?.dotSize, t),
      dotSpacing: lerpDouble(dotSpacing, o?.dotSpacing, t),
      dotDecorationBuilder:
          t < 0.5 ? dotDecorationBuilder : o?.dotDecorationBuilder,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      animationDuration,
      animationCurve,
      dotSize,
      dotSpacing,
      dotDecorationBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is YaruPageIndicatorThemeData &&
        other.animationDuration == animationDuration &&
        other.animationCurve == animationCurve &&
        other.dotSize == dotSize &&
        other.dotSpacing == dotSpacing &&
        other.dotDecorationBuilder == dotDecorationBuilder;
  }
}

/// Applies a theme to descendant [YaruPageIndicator] widgets.
///
/// Descendant widgets obtain the current [YaruPageIndicatorTheme] object using
/// [YaruPageIndicatorTheme.of]. When a widget uses [YaruPageIndicatorTheme.of],
/// it is automatically rebuilt if the theme later changes.
///
/// See also:
///
///  * [YaruPageIndicatorThemeData], which describes the actual configuration of
///    a toggle button theme.
class YaruPageIndicatorTheme extends InheritedWidget {
  /// Constructs a theme that configures all descendant [YaruPageIndicator] widgets.
  const YaruPageIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [PageIndicator] widgets.
  final YaruPageIndicatorThemeData data;

  /// Returns the configuration [data] from the closest [YaruPageIndicatorTheme]
  /// ancestor. If there is no ancestor, it returns `null`.
  static YaruPageIndicatorThemeData? of(BuildContext context) {
    final t =
        context.dependOnInheritedWidgetOfExactType<YaruPageIndicatorTheme>();
    return t?.data ?? Theme.of(context).extension<YaruPageIndicatorThemeData>();
  }

  @override
  bool updateShouldNotify(YaruPageIndicatorTheme oldWidget) {
    return data != oldWidget.data;
  }
}
