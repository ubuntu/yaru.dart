import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum YaruBackButtonStyle { rounded, square }

@immutable
class YaruBackButtonThemeData extends ThemeExtension<YaruBackButtonThemeData>
    with Diagnosticable {
  /// Creates a theme that can be used with [YaruBackButton].
  const YaruBackButtonThemeData({
    this.style,
  });

  /// The button style to use.
  final YaruBackButtonStyle? style;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  YaruBackButtonThemeData copyWith({
    YaruBackButtonStyle? style,
  }) {
    return YaruBackButtonThemeData(
      style: style ?? this.style,
    );
  }

  @override
  ThemeExtension<YaruBackButtonThemeData> lerp(
    ThemeExtension<YaruBackButtonThemeData>? other,
    double t,
  ) {
    final o = other as YaruBackButtonThemeData?;
    return YaruBackButtonThemeData(
      style: t < 0.5 ? style : o?.style,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('style', style));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruBackButtonThemeData && other.style == style;
  }

  @override
  int get hashCode => style.hashCode;
}

class YaruBackButtonTheme extends InheritedTheme {
  const YaruBackButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruBackButtonThemeData data;

  static YaruBackButtonThemeData? of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<YaruBackButtonTheme>();
    return theme?.data ??
        Theme.of(context).extension<YaruBackButtonThemeData>();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruBackButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruBackButtonTheme oldWidget) {
    return data != oldWidget.data;
  }
}
