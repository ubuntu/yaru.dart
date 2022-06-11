import 'package:flutter/material.dart';

class YaruRoundIconButton extends StatelessWidget {
  const YaruRoundIconButton({
    super.key,
    this.backgroundColor,
    this.onTap,
    this.tooltip,
    required this.child,
    this.size = 40,
  });

  /// The [Color] used for the round background.
  final Color? backgroundColor;

  /// Optional onTap callback to select the button
  final Function()? onTap;

  /// String shown in the [Tooltip]
  final String? tooltip;

  ///
  final Widget child;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: SizedBox(
        height: size,
        width: size,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(size / 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(size / 2),
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
