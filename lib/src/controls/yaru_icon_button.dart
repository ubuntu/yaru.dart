import 'package:flutter/material.dart';

/// An [IconButton] with a default fixed size of 40x40.
class YaruIconButton extends IconButton {
  YaruIconButton({
    super.key,
    super.iconSize,
    super.visualDensity,
    super.padding = const EdgeInsets.all(8.0),
    super.alignment = Alignment.center,
    super.splashRadius,
    required super.onPressed,
    super.mouseCursor,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback = true,
    super.constraints,
    ButtonStyle? style,
    super.isSelected,
    super.selectedIcon,
    required super.icon,
  }) : super(style: _kDefaultStyle.merge(style));

  static final _kDefaultStyle = IconButton.styleFrom(
    fixedSize: const Size.square(40),
  );
}
