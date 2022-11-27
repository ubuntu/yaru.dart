import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'yaru_toggle_button_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = YaruToggleButtonTheme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return MergeSemantics(
      child: Semantics(
        child: GestureDetector(
          onTap: onToggled,
          child: MouseRegion(
            cursor: onToggled != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
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
        ),
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
    return DefaultTextStyle(
      style: style.copyWith(color: color),
      overflow: overflow,
      softWrap: softWrap,
      child: child,
    );
  }
}
