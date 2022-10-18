import 'package:flutter/material.dart';
import '../../yaru_widgets.dart';

/// A colorable [Card] with a border which is tap-able via an [onTap] callback.
class YaruBanner extends StatelessWidget {
  const YaruBanner({
    super.key,
    this.onTap,
    this.surfaceTintColor,
    this.copyIconAsWatermark = false,
    required this.title,
    required this.icon,
    this.bannerWidth,
    this.subtitle,
    this.thirdTitle,
    this.watermarkIcon,
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

  /// If true the [icon] will be displayed a second time, with small opacity.
  final bool copyIconAsWatermark;

  /// The [Widget] used as the leading icon.
  final Widget icon;

  /// Optional [Widget] placed as the watermark
  final Widget? watermarkIcon;

  /// The [Widget] used as the third line.
  final Widget? thirdTitle;

  /// Optional width for the banner - if null it defaults to 370.
  final double? bannerWidth;

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
        child: copyIconAsWatermark
            ? Stack(
                alignment: Alignment.center,
                children: [
                  _Banner(
                    icon: icon,
                    title: title,
                    subtitle: subtitle,
                    thirdTitle: thirdTitle,
                    borderRadius: borderRadius,
                    color: surfaceTintColor ?? defaultCardColor,
                    elevation: light ? 4 : 6,
                    mouseCursor:
                        onTap != null ? SystemMouseCursors.click : null,
                  ),
                  if (copyIconAsWatermark == true)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Opacity(
                          opacity: 0.1,
                          child: watermarkIcon != null ? watermarkIcon! : icon,
                        ),
                      ),
                    ),
                ],
              )
            : _Banner(
                icon: icon,
                title: title,
                subtitle: subtitle,
                thirdTitle: thirdTitle,
                borderRadius: borderRadius,
                color: defaultCardColor,
                elevation: light ? 2 : 1,
                mouseCursor: onTap != null ? SystemMouseCursors.click : null,
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
    this.thirdTitle,
  });

  final Color color;
  final Widget title;
  final double elevation;
  final Widget icon;
  final BorderRadius borderRadius;
  final MouseCursor? mouseCursor;
  final Widget? subtitle;
  final Widget? thirdTitle;

  @override
  Widget build(BuildContext context) {
    final sub = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitle != null) subtitle!,
        if (thirdTitle != null) thirdTitle!,
      ],
    );

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
          subTitlePadding: EdgeInsets.zero,
          subtitle: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
            child: sub,
          ),
          title: DefaultTextStyle(
            child: title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 20,
                ),
          ),
          leading: icon,
        ),
      ),
    );
  }
}
