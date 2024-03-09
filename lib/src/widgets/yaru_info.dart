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
        padding: padding ??
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: DefaultTextStyle(
          style: style ??
              theme.textTheme.bodySmall ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
          child: title,
        ),
      ),
    );
  }
}

/// A [YaruTranslucentContainer] wrapper around [ListTile]

class YaruInfoBox extends StatelessWidget {
  /// Creates [YaruTranslucentContainer]
  const YaruInfoBox({
    this.title,
    this.subtitle,
    this.child,
    this.isThreeLine = false,
    super.key,
    required this.yaruInfoType,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(kYaruContainerRadius)),
    this.icon,
    this.color,
    this.titleTextStyle,
    this.subTitleTextStyle,
    this.trailing,
  }) : assert(
          (subtitle != null) ^ (child != null),
          'Either a subtitle or a child must be provided',
        );

  /// The [YaruInfoType] which is used to use predefined its predefined color and [Icon] for the leading widget
  /// of the internal [ListTile]
  final YaruInfoType yaruInfoType;

  /// An optional title [Widget] inserted into the internal [ListTile].
  final Widget? title;

  /// A subtitle [Widget] inserted into the internal [ListTile]. Either [subtitle] or [child] mus be provided.
  final Widget? subtitle;

  /// A child [Widget] inserted into the internal [ListTile]. Either [subtitle] or [child] mus be provided.
  final Widget? child;

  /// An optional trailing [Widget] inserted into the internal [ListTile].
  final Widget? trailing;

  ///  Whether the internal [ListTile] is intended to display three lines of text.
  /// If true, then [subtitle] must be non-null (since it is expected to give the second and third lines of text).
  /// If false, the list tile is treated as having one line if the subtitle is null and treated as having two lines if the subtitle is non-null.
  /// When using a [Text] widget for [title] and [subtitle], you can enforce line limits using [Text.maxLines].
  final bool isThreeLine;

  final BorderRadiusGeometry borderRadius;

  /// Optional [Icon] to overwrite the icon received from [YaruInfoType]
  final Icon? icon;

  /// Optional [Color] to overwrite the color received from [YaruInfoType]
  final Color? color;

  /// The optional style used for the [DefaultTextStyle] around the [title], defaults to
  /// `Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0, height: 1.8)`
  final TextStyle? titleTextStyle;

  /// The optional style used for the [DefaultTextStyle] around the [title], defaults to
  /// `Theme.of(context).textTheme.bodyMedium`
  final TextStyle? subTitleTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? yaruInfoType.getColor(context);

    return Row(
      children: [
        Expanded(
          child: YaruTranslucentContainer(
            color: baseColor,
            borderRadius: borderRadius,
            child: ListTile(
              leading: IconTheme(
                data: IconTheme.of(context).copyWith(
                  size: icon?.size ?? 30,
                  color: icon?.color ?? baseColor,
                ),
                child: icon ?? Icon(yaruInfoType.iconData),
              ),
              trailing: trailing,
              iconColor: baseColor,
              title: title != null
                  ? DefaultTextStyle(
                      style: titleTextStyle ??
                          theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.8,
                          ) ??
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.8,
                            color: theme.colorScheme.onSurface,
                          ),
                      child: title!,
                    )
                  : null,
              subtitle: child ??
                  DefaultTextStyle(
                    style: subTitleTextStyle ??
                        theme.textTheme.bodyMedium ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: theme.colorScheme.onSurface,
                        ),
                    child: subtitle!,
                  ),
              // contentPadding: kWizardTilePadding,
              isThreeLine: isThreeLine,
            ),
          ),
        ),
      ],
    );
  }
}
