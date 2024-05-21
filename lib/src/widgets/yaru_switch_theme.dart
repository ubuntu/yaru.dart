import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class YaruSwitchThemeData extends ThemeExtension<YaruSwitchThemeData>
    with Diagnosticable {
  const YaruSwitchThemeData({
    this.color,
    this.borderColor,
    this.thumbColor,
    this.indicatorColor,
    this.mouseCursor,
  });

  final WidgetStateProperty<Color?>? color;
  final WidgetStateProperty<Color?>? borderColor;
  final WidgetStateProperty<Color?>? thumbColor;
  final WidgetStateProperty<Color?>? indicatorColor;
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  @override
  YaruSwitchThemeData copyWith({
    WidgetStateProperty<Color?>? color,
    WidgetStateProperty<Color?>? borderColor,
    WidgetStateProperty<Color?>? thumbColor,
    WidgetStateProperty<Color?>? indicatorColor,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
  }) {
    return YaruSwitchThemeData(
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      thumbColor: thumbColor ?? this.thumbColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  @override
  ThemeExtension<YaruSwitchThemeData> lerp(
    ThemeExtension<YaruSwitchThemeData>? other,
    double t,
  ) {
    final o = other as YaruSwitchThemeData?;
    return YaruSwitchThemeData(
      color: WidgetStateProperty.lerp<Color?>(
        color,
        o?.color,
        t,
        Color.lerp,
      ),
      borderColor: WidgetStateProperty.lerp<Color?>(
        borderColor,
        o?.borderColor,
        t,
        Color.lerp,
      ),
      thumbColor: WidgetStateProperty.lerp<Color?>(
        thumbColor,
        o?.thumbColor,
        t,
        Color.lerp,
      ),
      indicatorColor: WidgetStateProperty.lerp<Color?>(
        indicatorColor,
        o?.indicatorColor,
        t,
        Color.lerp,
      ),
      mouseCursor: WidgetStateProperty.lerp<MouseCursor?>(
        mouseCursor,
        o?.mouseCursor,
        t,
        (a, b, t) => t < 0.5 ? a : b,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', color));
    properties.add(
      DiagnosticsProperty('borderColor', borderColor),
    );
    properties.add(DiagnosticsProperty('thumbColor', thumbColor));
    properties.add(DiagnosticsProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty('mouseCursor', mouseCursor));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruSwitchThemeData &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.thumbColor == thumbColor &&
        other.indicatorColor == indicatorColor &&
        other.mouseCursor == mouseCursor;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      borderColor,
      thumbColor,
      indicatorColor,
      mouseCursor,
    );
  }
}

class YaruSwitchTheme extends InheritedTheme {
  const YaruSwitchTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruSwitchThemeData data;

  static YaruSwitchThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<YaruSwitchTheme>();
    return theme?.data ??
        Theme.of(context).extension<YaruSwitchThemeData>() ??
        const YaruSwitchThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruSwitchTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruSwitchTheme oldWidget) {
    return data != oldWidget.data;
  }
}
