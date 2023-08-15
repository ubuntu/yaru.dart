import 'package:flutter/material.dart';
import 'package:yaru_widgets/constants.dart';

/// An [OutlinedButton] with a default size of 40x40.
///
/// For example, an option button with an arbitrary child widget:
/// ```dart
/// YaruOptionButton(
///   onPressed: () {},
///   child: Icon(YaruIcons.search),
/// ),
/// ```
///
/// Or with a pre-made color disk:
/// ```dart
/// YaruOptionButton.color(
///   onPressed: () {},
///   color: Theme.of(context).primaryColor,
/// ),
/// ```
class YaruOptionButton extends OutlinedButton {
  /// Creates a [YaruOptionButton].
  YaruOptionButton({
    super.key,
    required super.onPressed,
    super.focusNode,
    super.autofocus = false,
    ButtonStyle? style,
    required Widget child,
  }) : super(
          style: _styleFrom(padding: EdgeInsets.zero).merge(style),
          child: child,
        );

  /// Creates a [YaruOptionButton] with a color disk.
  YaruOptionButton.color({
    super.key,
    required super.onPressed,
    super.focusNode,
    super.autofocus = false,
    ButtonStyle? style,
    required Color color,
  }) : super(
          style: _styleFrom(padding: const EdgeInsets.all(10)).merge(style),
          child: SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        );

  static ButtonStyle _styleFrom({EdgeInsetsGeometry? padding}) {
    return OutlinedButton.styleFrom(
      minimumSize: const Size.square(kYaruTitleBarItemHeight),
      maximumSize: const Size.square(kYaruTitleBarItemHeight),
      fixedSize: const Size.square(kYaruTitleBarItemHeight),
      padding: padding,
    );
  }
}
