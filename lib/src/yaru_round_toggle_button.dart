import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_round_icon_button.dart';

/// A selectable [IconButton], wrapped in a [CircleAvatar]
class YaruRoundToggleButton extends StatelessWidget {
  /// The [IconData] for the [Icon]
  final IconData iconData;

  /// Defines if the button is selected
  final bool selected;

  /// Optional onPressed callback to select the button
  final Function()? onPressed;

  /// Tooltip
  final String? tooltip;

  const YaruRoundToggleButton({
    Key? key,
    required this.selected,
    required this.iconData,
    this.onPressed,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YaruRoundIconButton(
      onTap: onPressed,
      tooltip: tooltip,
      child: Icon(
        iconData,
        color: selected
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      ),
      backgroundColor: selected
          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
          : null,
    );
  }
}
