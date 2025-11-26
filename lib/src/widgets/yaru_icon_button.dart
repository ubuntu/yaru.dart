import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// An [IconButton] with a default fixed size of 40x40.
class YaruIconButton extends StatelessWidget {
  const YaruIconButton({
    required this.icon,
    this.alignment = Alignment.center,
    this.autofocus = false,
    this.constraints,
    this.enableFeedback = true,
    this.focusNode,
    this.iconSize = kYaruIconSize,
    this.isSelected,
    this.mouseCursor,
    this.onPressed,
    this.padding,
    this.selectedIcon,
    this.splashRadius,
    this.style,
    this.tooltip,
    this.visualDensity,
    this.hasFocusBorder,
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
  final EdgeInsetsGeometry? padding;
  final Widget? selectedIcon;
  final double? splashRadius;
  final ButtonStyle? style;
  final String? tooltip;
  final VisualDensity? visualDensity;
  final bool? hasFocusBorder;

  ButtonStyle defaultStyleOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ButtonStyle(
      fixedSize: WidgetStateProperty.all(Size(iconSize, iconSize)),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          if (states.contains(WidgetState.disabled)) {
            return colors.primary.withValues(alpha: 0.38);
          }
          return colors.primary;
        }
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurface.withValues(alpha: 0.38);
        }
        return colors.onSurface.withValues(alpha: 0.8);
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.onSurface.withValues(alpha: 0.1);
        }
        return null;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          if (states.contains(WidgetState.pressed)) {
            return colors.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return colors.onSurface.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return colors.onSurface.withValues(alpha: 0.12);
          }
        }
        if (states.contains(WidgetState.pressed)) {
          return colors.onSurfaceVariant.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.onSurfaceVariant.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return colors.onSurfaceVariant.withValues(alpha: 0.08);
        }
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      alignment: alignment,
      autofocus: autofocus,
      constraints: constraints,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      icon: icon,
      isSelected: isSelected,
      mouseCursor: mouseCursor,
      onPressed: onPressed,
      padding: padding ?? EdgeInsets.zero,
      selectedIcon: selectedIcon,
      splashRadius: splashRadius,
      style: defaultStyleOf(context).merge(style),
      tooltip: tooltip,
      visualDensity: visualDensity,
    );
    return hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
        ? YaruFocusBorder.primary(
            borderRadius: BorderRadius.circular(100),
            child: button,
          )
        : button;
  }
}
