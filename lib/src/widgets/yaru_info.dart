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
  });

  final String title;
  final EdgeInsets? padding;
  final YaruInfoType yaruInfoType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = yaruInfoType.getColor(context);

    return YaruTranslucentContainer(
      color: baseColor,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Text(title, style: theme.textTheme.bodySmall),
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
  }) : assert(
          (subtitle != null) ^ (child != null),
          'Either a subtitle or a child must be provided',
        );

  final String? title;
  final String? subtitle;
  final Widget? child;
  final bool isThreeLine;
  final YaruInfoType yaruInfoType;
  final BorderRadiusGeometry borderRadius;
  final Icon? icon;
  final Color? color;

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
                  size: 30,
                  color: baseColor,
                ),
                child: icon ?? Icon(yaruInfoType.iconData),
              ),
              iconColor: baseColor,
              title: title != null
                  ? Text(
                      title!,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        height: 1.8,
                      ),
                    )
                  : null,
              subtitle: child ??
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium,
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
