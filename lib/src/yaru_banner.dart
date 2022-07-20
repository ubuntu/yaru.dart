import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

/// A colorable [Card] with a border which is tap-able via an [onTap] callback.
class YaruBanner extends StatelessWidget {
  const YaruBanner({
    Key? key,
    this.onTap,
    this.surfaceTintColor,
    this.watermark = false,
    required this.name,
    this.summary,
    this.url,
    this.icon,
    required this.fallbackIconData,
    this.nameTextOverflow,
    this.summaryTextOverflow,
  }) : super(key: key);

  /// The name of the card
  final String name;

  /// A summary string shown in the second line.
  final String? summary;

  /// The url to include a [YaruSafeImage].
  final String? url;

  /// An optional callback
  final Function()? onTap;

  /// The color used for the soft background tint.
  /// If null [Theme]'s background color is used.
  final Color? surfaceTintColor;

  /// If true the [icon] will be displayed a second time, with small opacity.
  final bool watermark;

  /// The [Widget] used as the trailing icon.
  final Widget? icon;

  /// If the icon is not loaded this fallback icon is displayed.
  final IconData fallbackIconData;

  final TextOverflow? nameTextOverflow;

  /// Optional [TextOverflow]
  final TextOverflow? summaryTextOverflow;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    bool light = Theme.of(context).brightness == Brightness.light;
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      hoverColor: Theme.of(context).primaryColor.withOpacity(0.3),
      child: surfaceTintColor != null
          ? Stack(
              children: [
                _Banner(
                  borderRadius: borderRadius,
                  color: surfaceTintColor!,
                  title: name,
                  summary: summary,
                  elevation: light ? 4 : 6,
                  icon: icon ??
                      YaruSafeImage(
                        url: url,
                        fallBackIconData: fallbackIconData,
                      ),
                  titleTextOverflow: nameTextOverflow ?? TextOverflow.ellipsis,
                  subTitleTextOverflow:
                      summaryTextOverflow ?? TextOverflow.fade,
                  mouseCursor: onTap != null ? SystemMouseCursors.click : null,
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
                          child: YaruSafeImage(
                            url: url,
                            fallBackIconData: fallbackIconData,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : _Banner(
              borderRadius: borderRadius,
              color: light
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.01),
              elevation: light ? 2 : 1,
              icon: icon ??
                  YaruSafeImage(
                    url: url,
                    fallBackIconData: fallbackIconData,
                    iconSize: 50,
                  ),
              title: name,
              summary: summary,
              titleTextOverflow: nameTextOverflow ?? TextOverflow.ellipsis,
              subTitleTextOverflow:
                  summaryTextOverflow ?? TextOverflow.ellipsis,
              mouseCursor: onTap != null ? SystemMouseCursors.click : null,
            ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    Key? key,
    required this.color,
    required this.title,
    this.summary,
    required this.elevation,
    required this.icon,
    required this.borderRadius,
    required this.subTitleTextOverflow,
    this.mouseCursor,
    required this.titleTextOverflow,
  }) : super(key: key);

  final Color color;
  final String title;
  final String? summary;
  final double elevation;
  final Widget icon;
  final BorderRadius borderRadius;
  final TextOverflow subTitleTextOverflow;
  final TextOverflow titleTextOverflow;
  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      surfaceTintColor: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 370,
          child: ListTile(
            mouseCursor: mouseCursor,
            subtitle: summary != null && summary!.isNotEmpty
                ? Text(summary!, overflow: subTitleTextOverflow)
                : null,
            title: Text(
              title,
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
