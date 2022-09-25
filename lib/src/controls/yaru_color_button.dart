import 'package:flutter/material.dart';

/// An [OutlinedButton] with a color indicator and a default size of 40x40.
class YaruColorButton extends OutlinedButton {
  YaruColorButton({
    super.key,
    required this.color,
    required super.onPressed,
    ButtonStyle? style,
    super.focusNode,
    super.autofocus = false,
  }) : super(
          style: _kDefaultStyle.merge(style),
          child: SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        );

  static final _kDefaultStyle = OutlinedButton.styleFrom(
    minimumSize: const Size.square(40),
    maximumSize: const Size.square(40),
    padding: const EdgeInsets.all(8),
  );

  /// The color of the indicator.
  final Color color;
}
