import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class YaruCheckboxThemeData extends ThemeExtension<YaruCheckboxThemeData>
    with Diagnosticable {
  const YaruCheckboxThemeData({
    this.color,
    this.borderColor,
    this.checkmarkColor,
    this.indicatorColor,
    this.mouseCursor,
  });

  final WidgetStateProperty<Color?>? color;
  final WidgetStateProperty<Color?>? borderColor;
  final WidgetStateProperty<Color?>? checkmarkColor;
  final WidgetStateProperty<Color?>? indicatorColor;
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  @override
  YaruCheckboxThemeData copyWith({
    WidgetStateProperty<Color?>? color,
    WidgetStateProperty<Color?>? borderColor,
    WidgetStateProperty<Color?>? checkmarkColor,
    WidgetStateProperty<Color?>? indicatorColor,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
  }) {
    return YaruCheckboxThemeData(
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      checkmarkColor: checkmarkColor ?? this.checkmarkColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  @override
  ThemeExtension<YaruCheckboxThemeData> lerp(
    ThemeExtension<YaruCheckboxThemeData>? other,
    double t,
  ) {
    final o = other as YaruCheckboxThemeData?;
    return YaruCheckboxThemeData(
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
      checkmarkColor: WidgetStateProperty.lerp<Color?>(
        checkmarkColor,
        o?.checkmarkColor,
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
    properties.add(DiagnosticsProperty('checkmarkColor', checkmarkColor));
    properties.add(DiagnosticsProperty('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty('mouseCursor', mouseCursor));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruCheckboxThemeData &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.checkmarkColor == checkmarkColor &&
        other.indicatorColor == indicatorColor &&
        other.mouseCursor == mouseCursor;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      borderColor,
      checkmarkColor,
      indicatorColor,
      mouseCursor,
    );
  }
}

class YaruCheckboxTheme extends InheritedTheme {
  const YaruCheckboxTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruCheckboxThemeData data;

  static YaruCheckboxThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<YaruCheckboxTheme>();
    return theme?.data ??
        Theme.of(context).extension<YaruCheckboxThemeData>() ??
        const YaruCheckboxThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruCheckboxTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruCheckboxTheme oldWidget) {
    return data != oldWidget.data;
  }
}
