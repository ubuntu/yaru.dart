import 'package:flutter/material.dart';
import '../../yaru_widgets.dart';

/// A colorable [Card] with a border which is tap-able via an [onTap] callback.
class YaruBanner extends StatelessWidget {
  const YaruBanner({
    super.key,
    this.onTap,
    this.surfaceTintColor,
    this.watermark = false,
    required this.name,
    required this.icon,
    this.nameTextOverflow,
    this.summaryTextOverflow,
    this.bannerWidth,
    this.subtitle,
  });

  /// The name of the card
  final Widget name;

  /// The subtitle shown in the second line.
  final Widget? subtitle;

  /// An optional callback
  final Function()? onTap;

  /// The color used for the soft background tint.
  /// If null [Theme]'s background color is used.
  final Color? surfaceTintColor;

  /// If true the [icon] will be displayed a second time, with small opacity.
  final bool watermark;

  /// The [Widget] used as the trailing icon.
  final Widget icon;

  final TextOverflow? nameTextOverflow;

  /// Optional [TextOverflow]
  final TextOverflow? summaryTextOverflow;

  /// Optional width for the banner - if null it defaults to 370.
  final double? bannerWidth;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    final light = Theme.of(context).brightness == Brightness.light;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        hoverColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        child: surfaceTintColor != null
            ? Stack(
                children: [
                  _Banner(
                    subtitleWidget: subtitle,
                    width: bannerWidth,
                    borderRadius: borderRadius,
                    color: surfaceTintColor!,
                    title: name,
                    elevation: light ? 4 : 6,
                    icon: icon,
                    titleTextOverflow:
                        nameTextOverflow ?? TextOverflow.ellipsis,
                    subTitleTextOverflow:
                        summaryTextOverflow ?? TextOverflow.fade,
                    mouseCursor:
                        onTap != null ? SystemMouseCursors.click : null,
                  ),
                  if (watermark == true)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Opacity(
                          opacity: 0.1,
                          child: SizedBox(
                            height: 130,
                            child: icon,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : _Banner(
                subtitleWidget: subtitle,
                width: bannerWidth,
                borderRadius: borderRadius,
                color: light
                    ? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.01),
                elevation: light ? 2 : 1,
                icon: icon,
                title: name,
                titleTextOverflow: nameTextOverflow ?? TextOverflow.ellipsis,
                subTitleTextOverflow:
                    summaryTextOverflow ?? TextOverflow.ellipsis,
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
    required this.subTitleTextOverflow,
    this.mouseCursor,
    required this.titleTextOverflow,
    this.width,
    this.subtitleWidget,
  });

  final Color color;
  final Widget title;
  final double elevation;
  final Widget icon;
  final BorderRadius borderRadius;
  final TextOverflow subTitleTextOverflow;
  final TextOverflow titleTextOverflow;
  final MouseCursor? mouseCursor;
  final double? width;
  final Widget? subtitleWidget;

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
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: width ?? 370,
          child: ListTile(
            mouseCursor: mouseCursor,
            subtitle: subtitleWidget != null
                ? DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          overflow: subTitleTextOverflow,
                        ),
                    child: subtitleWidget!,
                  )
                : null,
            title: DefaultTextStyle(
              child: title,
              style: TextStyle(fontSize: 20, overflow: titleTextOverflow),
            ),
            leading: SizedBox(
              width: 60,
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
