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
  });

  final MaterialStateProperty<Color?>? color;
  final MaterialStateProperty<Color?>? borderColor;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? indicatorColor;

  @override
  YaruSwitchThemeData copyWith({
    MaterialStateProperty<Color?>? color,
    MaterialStateProperty<Color?>? borderColor,
    MaterialStateProperty<Color?>? thumbColor,
    MaterialStateProperty<Color?>? indicatorColor,
  }) {
    return YaruSwitchThemeData(
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      thumbColor: thumbColor ?? this.thumbColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
    );
  }

  @override
  ThemeExtension<YaruSwitchThemeData> lerp(
    ThemeExtension<YaruSwitchThemeData>? other,
    double t,
  ) {
    final o = other as YaruSwitchThemeData?;
    return YaruSwitchThemeData(
      color: MaterialStateProperty.lerp<Color?>(
        color,
        o?.color,
        t,
        Color.lerp,
      ),
      borderColor: MaterialStateProperty.lerp<Color?>(
        borderColor,
        o?.borderColor,
        t,
        Color.lerp,
      ),
      thumbColor: MaterialStateProperty.lerp<Color?>(
        thumbColor,
        o?.thumbColor,
        t,
        Color.lerp,
      ),
      indicatorColor: MaterialStateProperty.lerp<Color?>(
        indicatorColor,
        o?.indicatorColor,
        t,
        Color.lerp,
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
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaruSwitchThemeData &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.thumbColor == thumbColor &&
        other.indicatorColor == indicatorColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      borderColor,
      thumbColor,
      indicatorColor,
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
