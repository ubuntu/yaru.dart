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

  /// The child [Widget]
  final Widget child;

  /// Optional size which defaults to 40.
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: SizedBox(
        height: size,
        width: size,
        child: Material(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
