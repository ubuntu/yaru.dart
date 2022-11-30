import 'package:flutter/material.dart';
import '../../yaru_widgets.dart';

/// A colorable [Card] with a border which is tap-able via an [onTap] callback.
class YaruBanner extends StatelessWidget {
  const YaruBanner({
    super.key,
    this.onTap,
    this.surfaceTintColor,
    required this.title,
    required this.icon,
    this.subtitle,
    this.padding = const EdgeInsets.all(kYaruPagePadding),
  });

  /// The name of the card
  final Widget title;

  /// The subtitle shown in the second line.
  final Widget? subtitle;

  /// An optional callback
  final Function()? onTap;

  /// The color used for the soft background tint.
  /// If null [Theme]'s background color is used.
  final Color? surfaceTintColor;

  /// The [Widget] used as the leading icon.
  final Widget icon;

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
        child: _Banner(
          icon: icon,
          padding: padding,
          title: title,
          subtitle: subtitle,
          borderRadius: borderRadius,
          color: surfaceTintColor ?? defaultCardColor,
          elevation: light ? 4 : 6,
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.color,
    required this.title,
    required this.elevation,
    required this.icon,
    required this.borderRadius,
    this.subtitle,
    required this.padding,
  });

  final Color color;
  final Widget title;
  final double elevation;
  final Widget icon;
  final BorderRadius borderRadius;
  final Widget? subtitle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      surfaceTintColor: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
            .inner(const EdgeInsets.all(4.0)), // 4 is the default margin
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: YaruTile(
          padding: padding,
          style: YaruTileStyle.banner,
          title: title,
          subtitle: subtitle,
          leading: icon,
        ),
      ),
    );
  }
}
