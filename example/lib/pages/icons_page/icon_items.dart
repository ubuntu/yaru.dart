import 'package:flutter/material.dart';
import 'package:yaru/icons.dart';

class IconItem {
  const IconItem({
    required this.name,
    required this.usage,
    required this.iconBuilder,
  });

  final String name;
  final String usage;
  final Widget Function(BuildContext context, double iconSize) iconBuilder;
}

final List<IconItem> _staticIconItems = [
  for (final iconName in YaruIcons.all.keys.toList())
    IconItem(
      name: iconName,
      usage: 'YaruIcons.$iconName',
      iconBuilder: (context, iconSize) {
        final data = YaruIcons.all[iconName];

        if (data == null) {
          return const Placeholder();
        }
        return Icon(
          data,
          size: iconSize,
        );
      },
    ),
];

final List<IconItem> _animatedIconItems = [
  for (final iconName in YaruAnimatedIcons.all.keys.toList())
    IconItem(
      name: iconName,
      usage: 'YaruAnimatedIcons.$iconName',
      iconBuilder: (context, iconSize) => YaruAnimatedVectorIcon(
        YaruAnimatedIcons.all[iconName]!,
        size: iconSize,
      ),
    ),
];

final List<IconItem> _widgetIconItems = [
  IconItem(
    name: 'Placeholder',
    usage: 'YaruPlaceholderIcon()',
    iconBuilder: (context, iconSize) => YaruPlaceholderIcon(
      size: Size.square(iconSize),
    ),
  ),
];

abstract class IconItems {
  static List<IconItem> static = _staticIconItems;
  static List<IconItem> animated = _animatedIconItems;
  static List<IconItem> widget = _widgetIconItems;
}
