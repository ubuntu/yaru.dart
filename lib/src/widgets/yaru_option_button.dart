import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

enum YaruOptionButtonType { normal, color }

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
class YaruOptionButton extends StatelessWidget {
  YaruOptionButton({
    super.key,
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
    this.style,
    this.color,
    this.hasFocusBorder,
    required this.child,
  }) : _variant = YaruOptionButtonType.normal;

  YaruOptionButton.color({
    super.key,
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
    this.style,
    this.color,
    this.hasFocusBorder,
    this.child,
  }) : _variant = YaruOptionButtonType.color;

  final YaruOptionButtonType _variant;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool? autofocus;
  final ButtonStyle? style;
  final Color? color;
  final Widget? child;
  final bool? hasFocusBorder;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      style: switch (_variant) {
        YaruOptionButtonType.normal => _styleFrom(
          padding: EdgeInsets.zero,
        ).merge(style),
        YaruOptionButtonType.color => _styleFrom(
          padding: const EdgeInsets.all(10),
        ).merge(style),
      },
      onPressed: onPressed,
      child: switch (_variant) {
        YaruOptionButtonType.normal => child,
        YaruOptionButtonType.color => SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      },
    );

    return hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
        ? YaruFocusBorder.primary(child: button)
        : button;
  }

  static ButtonStyle _styleFrom({EdgeInsetsGeometry? padding}) {
    return OutlinedButton.styleFrom(
      minimumSize: const Size.square(kYaruTitleBarItemHeight),
      maximumSize: const Size.square(kYaruTitleBarItemHeight),
      fixedSize: const Size.square(kYaruTitleBarItemHeight),
      padding: padding,
    );
  }
}
