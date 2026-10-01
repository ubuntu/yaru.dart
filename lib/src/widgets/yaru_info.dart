import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

enum YaruInfoType {
  information,
  success,
  important,
  warning,
  danger;

  Color getColor(BuildContext context) => switch (this) {
    information => YaruColors.of(context).link,
    success => YaruColors.of(context).success,
    important => YaruColors.purple,
    warning => YaruColors.of(context).warning,
    danger => YaruColors.of(context).error,
  };

  IconData get iconData => switch (this) {
    information => YaruIcons.information,
    success => YaruIcons.ok,
    important => YaruIcons.important,
    warning => YaruIcons.warning,
    danger => YaruIcons.error,
  };
}

/// A [YaruTranslucentContainer] which wraps a title [Widget] in a [DefaultTextStyle]
class YaruInfoBadge extends StatelessWidget {
  /// Creates [YaruInfoBadge]
  const YaruInfoBadge({
    required this.title,
    this.padding,
    super.key,
    required this.yaruInfoType,
    this.color,
    this.style,
    this.borderRadius,
  });

  /// The [YaruInfoType] which is used to use predefined its predefined color.
  final YaruInfoType yaruInfoType;

  /// The title [Widget] must be provided.
  final Widget title;

  /// Optional [EdgeInsetsGeometry], defaults to `EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0)`
  final EdgeInsetsGeometry? padding;

  /// Optional [Color] to overwrite the color received from [YaruInfoType]
  final Color? color;

  /// Optional [TextStyle], defaults to `EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0)`
  final TextStyle? style;

  /// Optional [BorderRadiusGeometry], defaults to `BorderRadius.circular(20)`
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? yaruInfoType.getColor(context);

    return YaruTranslucentContainer(
      color: baseColor,
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: Padding(
        padding:
            padding ??
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: DefaultTextStyle.merge(
          style:
              style ??
              theme.textTheme.bodySmall ??
              const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          child: title,
        ),
      ),
    );
  }
}

/// A [YaruTranslucentContainer] wrapper similar to a [ListTile]

class YaruInfoBox extends StatelessWidget {
  /// Creates [YaruTranslucentContainer]
  const YaruInfoBox({
    this.title,
    this.subtitle,
    this.child,
    super.key,
    required this.yaruInfoType,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(kYaruContainerRadius),
    ),
    this.icon,
    this.color,
    this.titleTextStyle,
    this.subTitleTextStyle,
    this.trailing,
  }) : assert(
         (subtitle != null) ^ (child != null),
         'Either a subtitle or a child must be provided',
       );

  /// The [YaruInfoType] which is used to use predefined its predefined color and [Icon] for the leading widget.
  final YaruInfoType yaruInfoType;

  /// An optional title [Widget].
  final Widget? title;

  /// A subtitle [Widget]. Either [subtitle] or [child] must be provided.
  final Widget? subtitle;

  /// A child [Widget]. Either [subtitle] or [child] must be provided.
  final Widget? child;

  /// An optional trailing [Widget] inserted to the right of the title.
  final Widget? trailing;

  final BorderRadiusGeometry borderRadius;

  /// Optional [Icon] to overwrite the icon received from [YaruInfoType]
  final Icon? icon;

  /// Optional [Color] to overwrite the color received from [YaruInfoType]
  final Color? color;

  /// The optional style used for the [DefaultTextStyle] around the [title], defaults to
  /// `Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0, height: 1.3)`
  final TextStyle? titleTextStyle;

  /// The optional style used for the [DefaultTextStyle] around the [title], defaults to
  /// `Theme.of(context).textTheme.bodyMedium`
  final TextStyle? subTitleTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? yaruInfoType.getColor(context);

    return YaruTranslucentContainer(
      color: baseColor,
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconTheme(
                  data: IconTheme.of(context).copyWith(
                    size: icon?.size ?? 24,
                    color: icon?.color ?? baseColor,
                  ),
                  child: icon ?? Icon(yaruInfoType.iconData),
                ),
              ],
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    DefaultTextStyle.merge(
                      style:
                          titleTextStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ) ??
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                      child: title!,
                    ),
                  if (child != null || subtitle != null)
                    child ??
                        DefaultTextStyle.merge(
                          style:
                              subTitleTextStyle ??
                              theme.textTheme.bodyMedium ??
                              TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: theme.colorScheme.onSurface,
                              ),
                          child: subtitle!,
                        ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8.0), trailing!],
          ],
        ),
      ),
    );
  }
}
