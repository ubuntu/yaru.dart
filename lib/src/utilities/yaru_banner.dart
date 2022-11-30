import 'package:flutter/material.dart';
import '../../yaru_widgets.dart';

/// A colorable [Card] with a border which is tap-able via an [onTap] callback.
class YaruBanner extends StatelessWidget {
  /// Creates a banner with an arbitrary child widget.
  const YaruBanner({
    super.key,
    this.onTap,
    this.surfaceTintColor,
    required this.child,
    this.padding = const EdgeInsets.all(kYaruPagePadding),
  });

  /// Creates a banner with a [YaruTile] child widget.
  YaruBanner.tile({
    Key? key,
    VoidCallback? onTap,
    Color? surfaceTintColor,
    required Widget title,
    Widget? icon,
    Widget? subtitle,
    EdgeInsetsGeometry padding = const EdgeInsets.all(kYaruPagePadding),
  }) : this(
          key: key,
          onTap: onTap,
          padding: EdgeInsets.zero,
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

  /// The color used for the soft background tint.
  /// If null [Theme]'s background color is used.
  final Color? surfaceTintColor;

  /// Padding for the banner content. Defaults to `EdgeInsets.all(kYaruPagePadding)`
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    final light = Theme.of(context).brightness == Brightness.light;
    final defaultCardColor = light
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.01);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        hoverColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        child: Card(
          shadowColor: Colors.transparent,
          surfaceTintColor: surfaceTintColor ?? defaultCardColor,
          elevation: light ? 4 : 6,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius
                .inner(const EdgeInsets.all(4.0)), // 4 is the default margin
            side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
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
