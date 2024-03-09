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

class YaruInfoBadge extends StatelessWidget {
  const YaruInfoBadge({
    required this.title,
    this.padding,
    super.key,
    required this.yaruInfoType,
    this.color,
    this.style,
  });

  final Widget title;
  final EdgeInsets? padding;
  final YaruInfoType yaruInfoType;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? yaruInfoType.getColor(context);

    return YaruTranslucentContainer(
      color: baseColor,
      borderRadius: BorderRadius.circular(20),
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

class YaruInfoBox extends StatelessWidget {
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

  final Widget? title;
  final Widget? subtitle;
  final Widget? child;
  final Widget? trailing;
  final bool isThreeLine;
  final YaruInfoType yaruInfoType;
  final BorderRadiusGeometry borderRadius;
  final Icon? icon;
  final Color? color;
  final TextStyle? titleTextStyle;
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
