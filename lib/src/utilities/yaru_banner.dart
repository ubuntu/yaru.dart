import 'package:flutter/material.dart';
import '../../yaru_widgets.dart';

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
  });

  /// Creates a banner with a [YaruTile] child widget.
  YaruBanner.tile({
    Key? key,
    VoidCallback? onTap,
    Function(bool)? onHover,
    Color? color,
    double? elevation,
    Color? surfaceTintColor,
    required Widget title,
    Widget? icon,
    Widget? subtitle,
    EdgeInsetsGeometry padding = const EdgeInsets.all(kYaruPagePadding),
  }) : this(
          key: key,
          onTap: onTap,
          onHover: onHover,
          padding: EdgeInsets.zero,
          color: color,
          elevation: elevation,
          surfaceTintColor: surfaceTintColor,
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
  final Function()? onTap;

  /// An optional callback used when hovering the [YaruBanner]
  final Function(bool)? onHover;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(10);

    final light = theme.brightness == Brightness.light;

    final defaultSurfaceTintColor =
        light ? theme.cardColor : const Color.fromARGB(255, 126, 126, 126);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onHover: onHover,
        borderRadius: borderRadius,
        hoverColor: theme.colorScheme.onSurface.withOpacity(0.1),
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
