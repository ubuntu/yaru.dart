import 'package:flutter/material.dart';

enum YaruTileStyle { normal, banner }

class YaruTile extends StatelessWidget {
  /// Creates a Yaru style [ListTile] similar widget.
  ///
  /// for example:
  /// ```dart
  /// YaruTile(
  ///   title: Text('title'),
  ///   subtitle: Text('subtitle'),
  ///   trailing: Text('trailing'),
  /// )
  /// ```
  const YaruTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    this.padding = const EdgeInsets.all(8.0),
    this.style = YaruTileStyle.normal,
  });

  /// The [Widget] placed at the leading position.
  /// A widget to display before the [title].
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// The [Widget] placed at title position.
  final Widget? title;

  /// The [Widget] placed below [title].
  final Widget? subtitle;

  /// The [Widget] placed after the [title].
  final Widget? trailing;

  /// Whether or not we can interact with the widget
  final bool enabled;

  /// The padding [EdgeInsetsGeometry] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsetsGeometry padding;

  /// The style of the tile. Defaults to `YaruTileStyle.normal`.
  final YaruTileStyle style;

  @override
  Widget build(BuildContext context) {
    return _maybeBuildDisabledTextStyle(
      context: context,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                      style: _titleTextStyle(context),
                      child: title!,
                    ),
                  if (subtitle != null)
                    Padding(
                      padding: title != null && style != YaruTileStyle.banner
                          ? const EdgeInsets.only(top: 4.0)
                          : EdgeInsets.zero,
                      child: DefaultTextStyle(
                        style: _subtitleTextStyle(context),
                        child: subtitle!,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }

  Widget _maybeBuildDisabledTextStyle({
    required BuildContext context,
    required Widget child,
  }) {
    if (enabled) {
      return child;
    }

    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).disabledColor,
      ),
      child: child,
    );
  }

  TextStyle _titleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!;
  }

  TextStyle _subtitleTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    switch (style) {
      case YaruTileStyle.normal:
        return theme.textTheme.bodySmall!;
      case YaruTileStyle.banner:
        return theme.textTheme.bodyMedium!
            .copyWith(color: enabled ? theme.textTheme.bodySmall!.color : null);
    }
  }
}
