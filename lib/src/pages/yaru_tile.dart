import 'package:flutter/material.dart';

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
    required this.title,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    this.padding = const EdgeInsets.all(8.0),
  });

  /// The [Widget] placed at the leading position.
  /// A widget to display before the [title].
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// The [Widget] placed at title position.
  final Widget title;

  /// The [Widget] placed below [title].
  final Widget? subtitle;

  /// The [Widget] placed after the [title].
  final Widget? trailing;

  /// Whether or not we can interact with the widget
  final bool enabled;

  /// The padding [EdgeInsets] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: enabled
            ? Theme.of(context).textTheme.bodyLarge!.color
            : Theme.of(context).disabledColor,
      ),
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
                  title,
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: DefaultTextStyle(
                        style: enabled
                            ? Theme.of(context).textTheme.bodySmall!
                            : Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
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
}
