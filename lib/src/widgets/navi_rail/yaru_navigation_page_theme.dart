import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

@immutable
class YaruNavigationPageThemeData
    extends ThemeExtension<YaruNavigationPageThemeData> with Diagnosticable {
  /// Creates a theme that can be used with [YaruNavigationPage].
  const YaruNavigationPageThemeData({
    this.railPadding,
    this.pageTransitions,
    this.includeSeparator,
    this.sideBarColor,
  });

  factory YaruNavigationPageThemeData.fallback(BuildContext context) {
    final materialTheme = Theme.of(context);
    final light = materialTheme.brightness == Brightness.light;
    return YaruNavigationPageThemeData(
      pageTransitions: YaruPageTransitionsTheme.vertical,
      includeSeparator: true,
      sideBarColor: light
          ? materialTheme.colorScheme.background.scale(lightness: -0.029)
          : materialTheme.colorScheme.surface,
    );
  }

  /// The padding around the navigation rail.
  final EdgeInsetsGeometry? railPadding;

  /// The page transitions to use.
  final PageTransitionsTheme? pageTransitions;

  /// Controls whether a separator should be included between the content and the sidebar.
  /// Defaults to `true`
  final bool? includeSeparator;

  /// The color of the sidebar. Defaults to `Theme.of(context).colorScheme.surface`,
  /// where `Theme` is the material theme.
  final Color? sideBarColor;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  YaruNavigationPageThemeData copyWith({
    EdgeInsetsGeometry? railPadding,
    PageTransitionsTheme? pageTransitions,
    bool? includeSeparator,
    Color? sideBarColor,
  }) {
    return YaruNavigationPageThemeData(
      railPadding: railPadding ?? this.railPadding,
      pageTransitions: pageTransitions ?? this.pageTransitions,
      includeSeparator: includeSeparator ?? this.includeSeparator,
      sideBarColor: sideBarColor ?? this.sideBarColor,
    );
  }

  @override
  ThemeExtension<YaruNavigationPageThemeData> lerp(
    ThemeExtension<YaruNavigationPageThemeData>? other,
    double t,
  ) {
    final o = other as YaruNavigationPageThemeData?;
    return YaruNavigationPageThemeData(
      railPadding: EdgeInsetsGeometry.lerp(railPadding, o?.railPadding, t),
      pageTransitions: t < 0.5 ? pageTransitions : o?.pageTransitions,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('railPadding', railPadding));
    properties.add(DiagnosticsProperty('pageTransitions', pageTransitions));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruNavigationPageThemeData &&
        other.railPadding == railPadding &&
        other.pageTransitions == pageTransitions;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      railPadding,
      pageTransitions,
    ]);
  }
}

class YaruNavigationPageTheme extends InheritedTheme {
  const YaruNavigationPageTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruNavigationPageThemeData data;

  static YaruNavigationPageThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<YaruNavigationPageTheme>();
    return theme?.data ??
        Theme.of(context).extension<YaruNavigationPageThemeData>() ??
        YaruNavigationPageThemeData.fallback(context);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruNavigationPageTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruNavigationPageTheme oldWidget) {
    return data != oldWidget.data;
  }
}
