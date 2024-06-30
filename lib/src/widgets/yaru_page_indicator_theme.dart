import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'yaru_page_indicator.dart';
import 'yaru_page_indicator_layout_delegate.dart';

/// Defines default property values for descendant [YaruPageIndicator] widgets.
///
/// Descendant widgets obtain the current [YaruPageIndicatorThemeData] object
/// using `YaruPageIndicatorTheme.of(context)`. Instances of [YaruPageIndicatorThemeData]
/// can be customized with [YaruPageIndicatorThemeData.copyWith].
@immutable
class YaruPageIndicatorThemeData
    extends ThemeExtension<YaruPageIndicatorThemeData> with Diagnosticable {
  /// Creates a theme that can be used for [YaruPageIndicatorTheme.data].
  const YaruPageIndicatorThemeData({
    this.itemSizeBuilder,
    this.itemBuilder,
    this.mouseCursor,
    this.textBuilder,
    this.textStyle,
    this.layoutDelegate,
  });

  /// Returns the [Size] of a given item.
  /// These values are used to compute the layout using [layoutDelegate].
  final YaruPageIndicatorItemBuilder<Size>? itemSizeBuilder;

  /// Returns the [Widget] of a given item.
  final YaruPageIndicatorItemBuilder<Widget>? itemBuilder;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// Returns the [Widget] of the text based indicator.
  /// Be careful to use something small enough to fit in a small vertical constraints.
  ///
  /// Defaults to a basic [Text] like "2/12".
  /// You can custimize the text style with [textStyle].
  final YaruPageIndicatorTextBuilder? textBuilder;

  /// Text style used to customize the default text based indicator.
  ///
  /// Defaults to [TextTheme.bodySmall].
  final TextStyle? textStyle;

  /// Controls the items spacing, depending on the vertical constraints.
  final YaruPageIndicatorLayoutDelegate? layoutDelegate;

  /// Creates a copy with the given fields replaced with new values.
  @override
  YaruPageIndicatorThemeData copyWith({
    YaruPageIndicatorItemBuilder<Size>? itemSizeBuilder,
    YaruPageIndicatorItemBuilder<Widget>? itemBuilder,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    YaruPageIndicatorTextBuilder? textBuilder,
    TextStyle? textStyle,
    YaruPageIndicatorLayoutDelegate? layoutDelegate,
  }) {
    return YaruPageIndicatorThemeData(
      itemSizeBuilder: itemSizeBuilder ?? this.itemSizeBuilder,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      textBuilder: textBuilder ?? this.textBuilder,
      textStyle: textStyle ?? this.textStyle,
      layoutDelegate: layoutDelegate ?? this.layoutDelegate,
    );
  }

  @override
  ThemeExtension<YaruPageIndicatorThemeData> lerp(
    ThemeExtension<YaruPageIndicatorThemeData>? other,
    double t,
  ) {
    final o = other as YaruPageIndicatorThemeData?;
    return YaruPageIndicatorThemeData(
      itemSizeBuilder: t < 0.5 ? itemSizeBuilder : o?.itemSizeBuilder,
      itemBuilder: t < 0.5 ? itemBuilder : o?.itemBuilder,
      mouseCursor: t < 0.5 ? mouseCursor : o?.mouseCursor,
      textBuilder: t < 0.5 ? textBuilder : o?.textBuilder,
      textStyle: TextStyle.lerp(textStyle, o?.textStyle, t),
      layoutDelegate: t < 0.5 ? layoutDelegate : o?.layoutDelegate,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      itemSizeBuilder,
      itemBuilder,
      mouseCursor,
      textBuilder,
      textStyle,
      layoutDelegate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is YaruPageIndicatorThemeData &&
        other.itemSizeBuilder == itemSizeBuilder &&
        other.itemBuilder == itemBuilder &&
        other.mouseCursor == mouseCursor &&
        other.textBuilder == textBuilder &&
        other.textStyle == textStyle &&
        other.layoutDelegate == layoutDelegate;
  }
}

/// Applies a theme to descendant [YaruPageIndicator] widgets.
///
/// Descendant widgets obtain the current [YaruPageIndicatorTheme] object using
/// [YaruPageIndicatorTheme.of]. When a widget uses [YaruPageIndicatorTheme.of],
/// it is automatically rebuilt if the theme later changes.
///
/// See also:
///
///  * [YaruPageIndicatorThemeData], which describes the actual configuration of
///    a toggle button theme.
class YaruPageIndicatorTheme extends InheritedWidget {
  /// Constructs a theme that configures all descendant [YaruPageIndicator] widgets.
  const YaruPageIndicatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [PageIndicator] widgets.
  final YaruPageIndicatorThemeData data;

  /// Returns the configuration [data] from the closest [YaruPageIndicatorTheme]
  /// ancestor. If there is no ancestor, it returns `null`.
  static YaruPageIndicatorThemeData? of(BuildContext context) {
    final t =
        context.dependOnInheritedWidgetOfExactType<YaruPageIndicatorTheme>();
    return t?.data ?? Theme.of(context).extension<YaruPageIndicatorThemeData>();
  }

  @override
  bool updateShouldNotify(YaruPageIndicatorTheme oldWidget) {
    return data != oldWidget.data;
  }
}
