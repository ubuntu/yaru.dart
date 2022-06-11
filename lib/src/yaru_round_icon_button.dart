import 'package:flutter/material.dart';

class YaruRoundIconButton extends StatelessWidget {
  const YaruRoundIconButton({
    super.key,
    this.backgroundColor,
    this.onTap,
    required this.iconData,
    this.iconColor,
    required this.tooltip,
  });

  /// The [Color] used for the round background.
  final Color? backgroundColor;

  /// Optional onTap callback to select the button
  final Function()? onTap;

  /// The [IconData] for the [Icon]
  final IconData iconData;

  /// The [Color] of the [Icon]
  final Color? iconColor;

  /// String shown in the [Tooltip]
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: SizedBox(
        height: 40,
        width: 40,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
