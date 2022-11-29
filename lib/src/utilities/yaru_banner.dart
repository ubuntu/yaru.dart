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
    this.watermarkIcon,
    this.iconPadding = const EdgeInsets.only(left: 10),
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

  /// Padding for the leading icon. Defaults to `EdgeInsets.only(left: 10)`
  final EdgeInsets iconPadding;

  /// Optional [Widget] placed as the watermark
  final Widget? watermarkIcon;

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            _Banner(
              icon: icon,
              iconPadding: iconPadding,
              title: title,
              subtitle: subtitle,
              borderRadius: borderRadius,
              color: surfaceTintColor ?? defaultCardColor,
              elevation: light ? 4 : 6,
              mouseCursor: onTap != null ? SystemMouseCursors.click : null,
            ),
            if (watermarkIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Opacity(
                    opacity: 0.1,
                    child: watermarkIcon,
                  ),
                ),
              ),
          ],
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
    this.mouseCursor,
    this.subtitle,
    required this.iconPadding,
  });

  final Color color;
  final Widget title;
  final double elevation;
  final Widget icon;
  final BorderRadius borderRadius;
  final MouseCursor? mouseCursor;
  final Widget? subtitle;
  final EdgeInsets iconPadding;

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
          style: YaruTileStyle.banner,
          title: title,
          subtitle: subtitle,
          leading: Padding(
            padding: iconPadding,
            child: icon,
          ),
        ),
      ),
    );
  }
}
