import 'package:flutter/material.dart';

/// A selectable [IconButton], wrapped in a [CircleAvatar]
class YaruRoundToggleButton extends StatelessWidget {
  /// The [IconData] for the [Icon]
  final IconData iconData;

  /// Defines if the button is selected
  final bool selected;

  /// Optional onPressed callback to select the button
  final Function()? onPressed;

  /// Optional tooltip
  final String? tooltip;

  const YaruRoundToggleButton({
    Key? key,
    required this.selected,
    required this.iconData,
    this.onPressed,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: selected
          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.05)
          : Colors.transparent,
      child: IconButton(
        tooltip: tooltip,
        color: selected ? Colors.grey : null,
        splashRadius: 20,
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: selected
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
}
