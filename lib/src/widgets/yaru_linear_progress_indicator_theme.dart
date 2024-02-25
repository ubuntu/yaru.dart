import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yaru/src/widgets/yaru_progress_indicator.dart';

class YaruLinearProgressIndicatorThemeData
    extends YaruProgressIndicatorThemeData<
        YaruLinearProgressIndicatorThemeData> {
  YaruLinearProgressIndicatorThemeData(
    super.color,
    super.trackColor,
    super.strokeWidth,
    super.trackStrokeWidth,
  );

  @override
  ThemeExtension<YaruLinearProgressIndicatorThemeData> copyWith({
    Color? color,
    Color? trackColor,
    double? strokeWidth,
    double? trackStrokeWidth,
  }) {
    return YaruLinearProgressIndicatorThemeData(
      color ?? this.color,
      trackColor ?? this.trackColor,
      strokeWidth ?? this.strokeWidth,
      trackStrokeWidth ?? this.trackStrokeWidth,
    );
  }

  @override
  ThemeExtension<YaruLinearProgressIndicatorThemeData> lerp(
    covariant ThemeExtension<YaruLinearProgressIndicatorThemeData>? other,
    double t,
  ) {
    final o = other as YaruLinearProgressIndicatorThemeData?;
    return YaruLinearProgressIndicatorThemeData(
      Color.lerp(color, o?.color, t),
      Color.lerp(trackColor, o?.trackColor, t),
      lerpDouble(strokeWidth, o?.strokeWidth, t),
      lerpDouble(trackStrokeWidth, o?.trackStrokeWidth, t),
    );
  }
}

class YaruLinearProgressIndicatorTheme extends InheritedWidget {
  const YaruLinearProgressIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruLinearProgressIndicatorThemeData data;

  static YaruLinearProgressIndicatorThemeData? of(BuildContext context) {
    final t = context
        .dependOnInheritedWidgetOfExactType<YaruLinearProgressIndicatorTheme>();
    return t?.data ??
        Theme.of(context).extension<YaruLinearProgressIndicatorThemeData>();
  }

  @override
  bool updateShouldNotify(YaruLinearProgressIndicatorTheme oldWidget) {
    return data != oldWidget.data;
  }
}
