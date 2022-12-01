import 'package:flutter/widgets.dart';

class IconItem {
  IconItem({
    required this.name,
    required this.usage,
    required this.iconBuilder,
  });

  final String name;
  final String usage;
  final Widget Function(BuildContext context, double iconSize) iconBuilder;
}
