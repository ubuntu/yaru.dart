import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

@immutable
class YaruCompactLayoutThemeData with Diagnosticable {
  /// Creates a theme that can be used with [YaruCompactLayout].
  const YaruCompactLayoutThemeData({
    this.pageTransitions,
  });

  factory YaruCompactLayoutThemeData.fallback() {
    return const YaruCompactLayoutThemeData(
      pageTransitions: YaruPageTransitionsTheme.vertical,
    );
  }

  /// The page transitions to use.
  final PageTransitionsTheme? pageTransitions;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  YaruCompactLayoutThemeData copyWith({
    PageTransitionsTheme? pageTransitions,
  }) {
    return YaruCompactLayoutThemeData(
      pageTransitions: pageTransitions ?? this.pageTransitions,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('pageTransitions', pageTransitions));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruCompactLayoutThemeData &&
        other.pageTransitions == pageTransitions;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      pageTransitions,
    ]);
  }
}

class YaruCompactLayoutTheme extends InheritedTheme {
  const YaruCompactLayoutTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruCompactLayoutThemeData data;

  static YaruCompactLayoutThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<YaruCompactLayoutTheme>();
    return theme?.data ?? YaruCompactLayoutThemeData.fallback();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruCompactLayoutTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruCompactLayoutTheme oldWidget) {
    return data != oldWidget.data;
  }
}
