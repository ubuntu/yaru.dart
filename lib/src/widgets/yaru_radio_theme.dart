import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class YaruRadioThemeData extends ThemeExtension<YaruRadioThemeData>
    with Diagnosticable {
  const YaruRadioThemeData({
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
  YaruRadioThemeData copyWith({
    WidgetStateProperty<Color?>? color,
    WidgetStateProperty<Color?>? borderColor,
    WidgetStateProperty<Color?>? checkmarkColor,
    WidgetStateProperty<Color?>? indicatorColor,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
  }) {
    return YaruRadioThemeData(
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      checkmarkColor: checkmarkColor ?? this.checkmarkColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  @override
  ThemeExtension<YaruRadioThemeData> lerp(
    ThemeExtension<YaruRadioThemeData>? other,
    double t,
  ) {
    final o = other as YaruRadioThemeData?;
    return YaruRadioThemeData(
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
    return other is YaruRadioThemeData &&
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

class YaruRadioTheme extends InheritedTheme {
  const YaruRadioTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruRadioThemeData data;

  static YaruRadioThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<YaruRadioTheme>();
    return theme?.data ??
        Theme.of(context).extension<YaruRadioThemeData>() ??
        const YaruRadioThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return YaruRadioTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(YaruRadioTheme oldWidget) {
    return data != oldWidget.data;
  }
}
