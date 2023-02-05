import 'package:flutter/material.dart';

/// An [IconButton] with a default fixed size of 40x40.
class YaruIconButton extends StatelessWidget {
  const YaruIconButton({
    required this.icon,
    this.alignment = Alignment.center,
    this.autofocus = false,
    this.constraints,
    this.enableFeedback = true,
    this.focusNode,
    this.iconSize = 40.0,
    this.isSelected,
    this.mouseCursor,
    this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.selectedIcon,
    this.splashRadius,
    this.style,
    this.tooltip,
    this.visualDensity,
    super.key,
  });

  final AlignmentGeometry alignment;
  final bool autofocus;
  final BoxConstraints? constraints;
  final bool enableFeedback;
  final FocusNode? focusNode;
  final Widget icon;
  final double iconSize;
  final bool? isSelected;
  final MouseCursor? mouseCursor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final Widget? selectedIcon;
  final double? splashRadius;
  final ButtonStyle? style;
  final String? tooltip;
  final VisualDensity? visualDensity;

  ButtonStyle defaultStyleOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(Size(iconSize, iconSize)),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.disabled)) {
            return colors.primary.withOpacity(0.38);
          }
          return colors.primary;
        }
        if (states.contains(MaterialState.disabled)) {
          return colors.onSurface.withOpacity(0.38);
        }
        return colors.onSurface.withOpacity(0.8);
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return colors.onSurface.withOpacity(0.1);
        }
        return null;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.pressed)) {
            return colors.onSurface.withOpacity(0.12);
          }
          if (states.contains(MaterialState.hovered)) {
            return colors.onSurface.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return colors.onSurface.withOpacity(0.12);
          }
        }
        if (states.contains(MaterialState.pressed)) {
          return colors.onSurfaceVariant.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return colors.onSurfaceVariant.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return colors.onSurfaceVariant.withOpacity(0.08);
        }
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: alignment,
      autofocus: autofocus,
      constraints: constraints,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      icon: icon,
      isSelected: isSelected,
      mouseCursor: mouseCursor,
      onPressed: onPressed,
      padding: padding,
      selectedIcon: selectedIcon,
      splashRadius: splashRadius,
      style: defaultStyleOf(context).merge(style),
      tooltip: tooltip,
      visualDensity: visualDensity,
    );
  }
}
