import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';

/// Holds theme data for [YaruMasterDetailTheme].
@immutable
class YaruMasterDetailThemeData
    extends ThemeExtension<YaruMasterDetailThemeData> with Diagnosticable {
  const YaruMasterDetailThemeData({
    this.breakpoint,
    this.tileSpacing,
    this.listPadding,
    this.portraitTransitions,
    this.landscapeTransitions,
  });

  factory YaruMasterDetailThemeData.fallback() {
    return const YaruMasterDetailThemeData(
      breakpoint: kYaruMasterDetailBreakpoint,
      tileSpacing: 6,
      listPadding: EdgeInsets.symmetric(vertical: 8),
      portraitTransitions: YaruPageTransitionsTheme.horizontal,
      landscapeTransitions: YaruPageTransitionsTheme.vertical,
    );
  }

  /// The breakpoint at which `YaruMasterDetailPage` switches between portrait
  /// and landscape layouts.
  final double? breakpoint;

  /// The spacing between tiles in the master list.
  final double? tileSpacing;

  /// The padding around the master list.
  final EdgeInsetsGeometry? listPadding;

  /// The page transitions to use when in portrait mode.
  final PageTransitionsTheme? portraitTransitions;

  /// The page transitions to use when in landscape mode.
  final PageTransitionsTheme? landscapeTransitions;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  YaruMasterDetailThemeData copyWith({
    double? breakpoint,
    double? tileSpacing,
    EdgeInsetsGeometry? listPadding,
    PageTransitionsTheme? portraitTransitions,
    PageTransitionsTheme? landscapeTransitions,
  }) {
    return YaruMasterDetailThemeData(
      breakpoint: breakpoint ?? this.breakpoint,
      tileSpacing: tileSpacing ?? this.tileSpacing,
      listPadding: listPadding ?? this.listPadding,
      portraitTransitions: portraitTransitions ?? this.portraitTransitions,
      landscapeTransitions: landscapeTransitions ?? this.landscapeTransitions,
    );
  }

  @override
  ThemeExtension<YaruMasterDetailThemeData> lerp(
    ThemeExtension<YaruMasterDetailThemeData>? other,
    double t,
  ) {
    final o = other as YaruMasterDetailThemeData?;
    return YaruMasterDetailThemeData(
      breakpoint: lerpDouble(breakpoint, o?.breakpoint, t),
      tileSpacing: lerpDouble(tileSpacing, o?.tileSpacing, t),
      listPadding: EdgeInsetsGeometry.lerp(listPadding, o?.listPadding, t),
      portraitTransitions:
          t < 0.5 ? portraitTransitions : o?.portraitTransitions,
      landscapeTransitions:
          t < 0.5 ? landscapeTransitions : o?.landscapeTransitions,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('breakpoint', breakpoint));
    properties.add(DoubleProperty('tileSpacing', tileSpacing));
    properties.add(DiagnosticsProperty('listPadding', listPadding));
    properties
        .add(DiagnosticsProperty('portraitTransitions', portraitTransitions));
    properties
        .add(DiagnosticsProperty('landscapeTransitions', landscapeTransitions));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruMasterDetailThemeData &&
        other.breakpoint == breakpoint &&
        other.tileSpacing == tileSpacing &&
        other.listPadding == listPadding &&
        other.portraitTransitions == portraitTransitions &&
        other.landscapeTransitions == landscapeTransitions;
  }

  @override
  int get hashCode {
    return Object.hash(
      breakpoint,
      tileSpacing,
      listPadding,
      portraitTransitions,
      landscapeTransitions,
    );
  }
}

/// Applies theme to a descendant [YaruMasterDetailPage].
class YaruMasterDetailTheme extends InheritedTheme {
  const YaruMasterDetailTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruMasterDetailThemeData data;

  static YaruMasterDetailThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<YaruMasterDetailTheme>();
    return theme?.data ??
        Theme.of(context).extension<YaruMasterDetailThemeData>() ??
        YaruMasterDetailThemeData.fallback();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruMasterDetailTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruMasterDetailTheme oldWidget) {
    return data != oldWidget.data;
  }
}
