import 'package:flutter/material.dart';
import 'package:yaru_widgets/constants.dart';
import 'package:yaru_widgets/foundation.dart' show YaruBorderRadiusExtension;

import 'yaru_tile.dart';

/// A colorable [Card] with a border which is tap-able via an [onTap] callback.
class YaruBanner extends StatelessWidget {
  /// Creates a banner with an arbitrary child widget.
  const YaruBanner({
    super.key,
    this.onTap,
    this.color,
    this.elevation,
    this.surfaceTintColor,
    required this.child,
    this.padding = const EdgeInsets.all(kYaruPagePadding),
    this.onHover,
    this.selected,
    this.mouseCursor,
  });

  /// Creates a banner with a [YaruTile] child widget.
  YaruBanner.tile({
    Key? key,
    VoidCallback? onTap,
    ValueChanged<bool>? onHover,
    Color? color,
    double? elevation,
    Color? surfaceTintColor,
    required Widget title,
    Widget? icon,
    Widget? subtitle,
    EdgeInsetsGeometry padding = const EdgeInsets.all(kYaruPagePadding),
    bool? selected,
    MouseCursor? mouseCursor,
  }) : this(
          key: key,
          onTap: onTap,
          onHover: onHover,
          padding: EdgeInsets.zero,
          color: color,
          elevation: elevation,
          surfaceTintColor: surfaceTintColor,
          selected: selected,
          mouseCursor: mouseCursor,
          child: YaruTile(
            leading: icon,
            title: title,
            subtitle: subtitle,
            padding: padding,
          ),
        );

  /// The widget to display inside the banner.
  final Widget child;

  /// An optional callback
  final VoidCallback? onTap;

  /// An optional callback used when hovering the [YaruBanner]
  final ValueChanged<bool>? onHover;

  /// The banner's background color.
  /// If null, [Theme]'s card color is used.
  final Color? color;

  /// The elevation of the banner determines the strength of [surfaceTintColor].
  /// A higher elevation means a stronger tint.
  final double? elevation;

  /// The color used for the soft background tint.
  /// If null, [Theme]'s background color is used.
  final Color? surfaceTintColor;

  /// Padding for the banner content. Defaults to `EdgeInsets.all(kYaruPagePadding)`
  final EdgeInsetsGeometry padding;

  /// Whether the banner is selected. A selected banner is highlighted with the
  /// theme's primary color.
  final bool? selected;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(kYaruBannerRadius);

    final light = theme.brightness == Brightness.light;

    final defaultSurfaceTintColor =
        light ? theme.cardColor : const Color.fromARGB(255, 126, 126, 126);
    return Material(
      color: selected == true
          ? theme.primaryColor.withOpacity(0.8)
          : Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        onHover: onHover,
        borderRadius: borderRadius,
        hoverColor: theme.colorScheme.onSurface.withOpacity(0.1),
        mouseCursor: mouseCursor,
        child: Card(
          color: color,
          shadowColor: Colors.transparent,
          surfaceTintColor: surfaceTintColor ?? defaultSurfaceTintColor,
          elevation: elevation ?? 1,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius
                .inner(const EdgeInsets.all(4.0)), // 4 is the default margin
            side: BorderSide(color: theme.dividerColor, width: 1),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
