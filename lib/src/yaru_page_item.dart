import 'package:flutter/widgets.dart';

class YaruPageItem {
  const YaruPageItem({
    required this.title,
    required this.builder,
    required this.iconData,
    this.selectedIconData,
  });
  final String title;
  final WidgetBuilder builder;
  final IconData iconData;
  final IconData? selectedIconData;
}
