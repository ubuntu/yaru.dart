import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';

@immutable
class YaruMasterDetailThemeData with Diagnosticable {
  /// Creates a theme that can be used with [YaruMasterDetailPage].
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
  final EdgeInsets? listPadding;

  /// The page transitions to use when in portrait mode.
  final PageTransitionsTheme? portraitTransitions;

  /// The page transitions to use when in landscape mode.
  final PageTransitionsTheme? landscapeTransitions;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  YaruMasterDetailThemeData copyWith({
    double? breakpoint,
    double? tileSpacing,
    EdgeInsets? listPadding,
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
    return theme?.data ?? YaruMasterDetailThemeData.fallback();
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
