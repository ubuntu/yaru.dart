import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

enum YaruInfoType {
  note,
  tip,
  important,
  warning,
  caution;

  Color getColor(BuildContext context) => switch (this) {
        note => YaruColors.of(context).link,
        tip => YaruColors.of(context).success,
        important => YaruColors.purple,
        warning => YaruColors.of(context).warning,
        caution => YaruColors.of(context).error,
      };

  IconData get iconData => switch (this) {
        note => YaruIcons.information,
        tip => YaruIcons.ok,
        important => YaruIcons.important,
        warning => YaruIcons.warning,
        caution => YaruIcons.error,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = yaruInfoType.getColor(context);

    return Row(
      children: [
        Expanded(
          child: YaruTranslucentContainer(
            color: baseColor,
            borderRadius: borderRadius,
            child: ListTile(
              leading: icon ??
                  Icon(
                    yaruInfoType.iconData,
                    size: 30,
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
