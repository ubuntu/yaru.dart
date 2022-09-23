import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/controls/yaru_icon_button.dart';

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

  /// Optional size which defaults to 40.
  final double? size;

  const YaruRoundToggleButton({
    super.key,
    required this.selected,
    required this.iconData,
    this.onPressed,
    this.tooltip,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return YaruIconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(
        iconData,
        color: selected
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      ),
      style: ButtonStyle(
        fixedSize: ButtonStyleButton.allOrNull(
          size != null ? Size(size!, size!) : null,
        ),
        backgroundColor: ButtonStyleButton.allOrNull(
          selected
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
              : null,
        ),
      ),
    );
  }
}
