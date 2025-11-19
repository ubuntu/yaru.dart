import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

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
    this.hasFocusBorder,
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
    bool? hasFocusBorder,
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
         hasFocusBorder: hasFocusBorder,
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

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(kYaruContainerRadius);

    final defaultSurfaceTintColor = theme.scaffoldBackgroundColor.scale(
      lightness: theme.brightness == Brightness.light ? 0 : 0.03,
    );
    final content = InkWell(
      onTap: onTap,
      onHover: onHover,
      borderRadius: borderRadius,
      hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
      mouseCursor: mouseCursor,
      child: Card(
        color: color ?? defaultSurfaceTintColor,
        shadowColor: Colors.transparent,
        surfaceTintColor: surfaceTintColor ?? defaultSurfaceTintColor,
        elevation: elevation ?? 1,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius.inner(
            const EdgeInsets.all(4.0),
          ), // 4 is the default margin
          side: BorderSide(color: theme.dividerColor, width: 0),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: padding,
          child: child,
        ),
      ),
    );
    return Material(
      color: selected == true
          ? theme.primaryColor.withValues(alpha: 0.8)
          : Colors.transparent,
      borderRadius: borderRadius,
      child: hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
          ? YaruFocusBorder.primary(child: content)
          : content,
    );
  }
}
