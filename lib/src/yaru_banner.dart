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
  }) : super(key: key);

  /// The name of the card
  final String name;

  /// A summary string shown in the second line.
  final String? summary;

  /// The url to include a [YaruSafeImage].
  final String? url;

  /// An optional callback
  final Function()? onTap;
  final Color? surfaceTintColor;
  final bool watermark;
  final Widget? icon;
  final IconData fallbackIconData;

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
                  textOverflow: TextOverflow.fade,
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
              textOverflow: TextOverflow.ellipsis,
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
    required this.textOverflow,
    this.mouseCursor,
  }) : super(key: key);

  final Color color;
  final String title;
  final String? summary;
  final double elevation;
  final Widget icon;
  final BorderRadius borderRadius;
  final TextOverflow textOverflow;
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
                ? Text(summary!, overflow: textOverflow)
                : null,
            title: Text(
              title,
              style: const TextStyle(fontSize: 20),
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
