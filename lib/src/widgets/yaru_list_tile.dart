import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class YaruListTile extends StatelessWidget {
  const YaruListTile({
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.leading,
    this.trailing,
    this.onTap,
    this.borderRadius,
    this.hasFocusBorder,
    this.centerTitle = false,
    this.enabled = true,
    this.horizontalGap = 12.0,
    this.verticalGap = 8.0,
    super.key,
  }) : assert((title != null) ^ (titleText != null));

  const YaruListTile.square({
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.leading,
    this.trailing,
    this.onTap,
    this.hasFocusBorder,
    this.borderRadius = BorderRadius.zero,
    this.centerTitle = false,
    this.enabled = true,
    this.horizontalGap = 12.0,
    this.verticalGap = 8.0,
    super.key,
  }) : assert((title != null) ^ (titleText != null));

  /// The primary content of the list tile, displayed with [TextTheme.labelLarge].
  final Widget? title;

  final String? titleText;

  /// Optional secondary content displayed below the title.
  final Widget? subtitle;

  final String? subtitleText;

  /// A widget to display before the title.
  final Widget? leading;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  /// [BorderRadius] of the underlying [InkWell]
  final BorderRadius? borderRadius;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  /// Whether to center the title text. Defaults to false.
  final bool centerTitle;

  /// Whether the list tile is enabled. Defaults to true.
  final bool enabled;

  /// Horizontal gap between widgets.
  final double horizontalGap;

  /// Vertical gap between widgets.
  final double verticalGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleWidget = DefaultTextStyle.merge(
      style: theme.textTheme.labelLarge?.copyWith(
        color: enabled ? null : theme.disabledColor,
      ),
      child: title ?? Text(titleText!),
    );
    final subtitleWidget = subtitle != null || subtitleText != null
        ? DefaultTextStyle.merge(
            style: theme.textTheme.labelMedium?.copyWith(
              color: enabled ? null : theme.disabledColor,
            ),
            child: subtitle ?? Text(subtitleText!),
          )
        : null;

    final tile = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 54),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              borderRadius ?? BorderRadius.circular(kYaruButtonRadius),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalGap,
              vertical: verticalGap,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: horizontalGap),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: centerTitle
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      titleWidget,
                      if (subtitleWidget != null) ...[
                        subtitleWidget,
                        const SizedBox(height: 1),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: horizontalGap),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
        ? YaruFocusBorder.primary(
            borderStrokeAlign: BorderSide.strokeAlignInside,
            child: tile,
          )
        : tile;
  }
}
