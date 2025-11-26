import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yaru/yaru.dart';

part 'yaru_toggle_button_layout.dart';

/// A desktop style toggle button with an indicator and an interactive label.
///
/// See [YaruCheckButton] and [YaruRadioButton] for concrete implementations.
class YaruToggleButton extends StatelessWidget {
  /// Creates a toggle button.
  const YaruToggleButton({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.contentPadding,
    this.onToggled,
    this.mouseCursor,
    this.statesController,
    this.hasFocusBorder,
  });

  /// The toggle indicator.
  final Widget leading;

  /// The button label.
  final Widget title;

  /// An optional secondary label.
  final Widget? subtitle;

  /// Padding around the content.
  final EdgeInsetsGeometry? contentPadding;

  /// Called when the button is toggled.
  final VoidCallback? onToggled;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  final WidgetStatesController? statesController;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  @override
  Widget build(BuildContext context) {
    final theme = YaruToggleButtonTheme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final states =
        statesController?.value ??
        {if (onToggled == null) WidgetState.disabled};
    final enabled = !states.contains(WidgetState.disabled);
    final mouseCursor =
        WidgetStateProperty.resolveAs(this.mouseCursor, states) ??
        WidgetStateMouseCursor.clickable.resolve(states);

    final button = GestureDetector(
      onTap: onToggled,
      onTapDown: (_) => statesController?.update(WidgetState.pressed, enabled),
      onTapUp: (_) => statesController?.update(WidgetState.pressed, false),
      onTapCancel: () => statesController?.update(WidgetState.pressed, false),
      child: MouseRegion(
        cursor: mouseCursor,
        onEnter: (_) => statesController?.update(WidgetState.hovered, true),
        onHover: (_) => statesController?.update(WidgetState.hovered, true),
        onExit: (_) => statesController?.update(WidgetState.hovered, false),
        child: Padding(
          padding: contentPadding ?? EdgeInsets.zero,
          child: _YaruToggleButtonLayout(
            horizontalSpacing: theme?.horizontalSpacing ?? 8,
            verticalSpacing: theme?.verticalSpacing ?? 4,
            textDirection: Directionality.of(context),
            leading: leading,
            title: _wrapTextStyle(
              context,
              overflow: TextOverflow.ellipsis,
              style: theme?.titleStyle ?? textTheme.titleMedium!,
              child: title,
            ),
            subtitle: subtitle != null
                ? _wrapTextStyle(
                    context,
                    softWrap: true,
                    style: theme?.subtitleStyle ?? textTheme.bodySmall!,
                    child: subtitle!,
                  )
                : null,
          ),
        ),
      ),
    );

    return MergeSemantics(
      child: Semantics(
        child:
            hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
            ? YaruFocusBorder.primary(child: button)
            : button,
      ),
    );
  }

  Widget _wrapTextStyle(
    BuildContext context, {
    required Widget child,
    required TextStyle style,
    TextOverflow overflow = TextOverflow.clip,
    bool softWrap = false,
  }) {
    final color = onToggled == null ? Theme.of(context).disabledColor : null;
    return DefaultTextStyle.merge(
      style: style.copyWith(color: color),
      overflow: overflow,
      softWrap: softWrap,
      child: child,
    );
  }
}
