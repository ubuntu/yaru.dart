import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

const _horizontalGap = 12.0;
const _verticalGap = 8.0;

/// A tile widget similar to a [ListTile], with more flexible styling.
///
/// Using a [YaruListTile.square] is preferable when displaying the tiles inside
/// a [YaruTileList].
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
    this.mouseCursor,
    this.focusNode,
    this.hoverColor,
    this.customBorder,
    this.centerTitle = false,
    this.enabled = true,
    this.contentPadding,
    this.horizontalGap = _horizontalGap,
    this.verticalGap = _verticalGap,
    this.autofocus = false,
    this.enableFeedback = true,
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
    this.mouseCursor,
    this.focusNode,
    this.hoverColor,
    this.customBorder,
    this.borderRadius = BorderRadius.zero,
    this.centerTitle = false,
    this.enabled = true,
    this.contentPadding,
    this.horizontalGap = _horizontalGap,
    this.verticalGap = _verticalGap,
    this.autofocus = false,
    this.enableFeedback = true,
    super.key,
  }) : assert((title != null) ^ (titleText != null));

  /// The primary content of the list tile, displayed with [TextTheme.labelLarge].
  final Widget? title;

  /// The text content of the title, mutually exclusive with [title].
  final String? titleText;

  /// Optional secondary content displayed below the title.
  final Widget? subtitle;

  /// The text content of the subtitle, mutually exclusive with [subtitle].
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

  /// The tile's internal padding between content and the outer edge.
  final EdgeInsetsGeometry? contentPadding;

  /// Horizontal gap between widgets.
  final double horizontalGap;

  /// Vertical gap between widgets.
  final double verticalGap;

  /// See [InkWell.mouseCursor].
  final MouseCursor? mouseCursor;

  /// See [InkWell.focusNode].
  final FocusNode? focusNode;

  /// See [InkWell.enableFeedback].
  final bool enableFeedback;

  /// See [InkWell.autofocus].
  final bool autofocus;

  /// See [InkWell.hoverColor].
  final Color? hoverColor;

  /// See [InkWell.customBorder].
  final ShapeBorder? customBorder;

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
          mouseCursor: mouseCursor,
          focusNode: focusNode,
          enableFeedback: enableFeedback,
          hoverColor: hoverColor,
          autofocus: autofocus,
          customBorder: customBorder,
          child: Padding(
            padding:
                contentPadding ??
                EdgeInsets.symmetric(
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
