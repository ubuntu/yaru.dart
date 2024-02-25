import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yaru/src/widgets/yaru_progress_indicator.dart';

class YaruCircularProgressIndicatorThemeData
    extends YaruProgressIndicatorThemeData<
        YaruCircularProgressIndicatorThemeData> {
  YaruCircularProgressIndicatorThemeData(
    super.color,
    super.trackColor,
    super.strokeWidth,
    super.trackStrokeWidth,
  );

  @override
  ThemeExtension<YaruCircularProgressIndicatorThemeData> copyWith({
    Color? color,
    Color? trackColor,
    double? strokeWidth,
    double? trackStrokeWidth,
  }) {
    return YaruCircularProgressIndicatorThemeData(
      color ?? this.color,
      trackColor ?? this.trackColor,
      strokeWidth ?? this.strokeWidth,
      trackStrokeWidth ?? this.trackStrokeWidth,
    );
  }

  @override
  ThemeExtension<YaruCircularProgressIndicatorThemeData> lerp(
    covariant ThemeExtension<YaruCircularProgressIndicatorThemeData>? other,
    double t,
  ) {
    final o = other as YaruCircularProgressIndicatorThemeData?;
    return YaruCircularProgressIndicatorThemeData(
      Color.lerp(color, o?.color, t),
      Color.lerp(trackColor, o?.trackColor, t),
      lerpDouble(strokeWidth, o?.strokeWidth, t),
      lerpDouble(trackStrokeWidth, o?.trackStrokeWidth, t),
    );
  }
}

class YaruCircularProgressIndicatorTheme extends InheritedWidget {
  const YaruCircularProgressIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final YaruCircularProgressIndicatorThemeData data;

  static YaruCircularProgressIndicatorThemeData? of(BuildContext context) {
    final t = context.dependOnInheritedWidgetOfExactType<
        YaruCircularProgressIndicatorTheme>();
    return t?.data ??
        Theme.of(context).extension<YaruCircularProgressIndicatorThemeData>();
  }

  @override
  bool updateShouldNotify(YaruCircularProgressIndicatorTheme oldWidget) {
    return data != oldWidget.data;
  }
}
