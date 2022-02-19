import 'package:flutter/widgets.dart';

class YaruPageItem {
  const YaruPageItem({
    required this.titleBuilder,
    required this.builder,
    required this.iconData,
    this.selectedIconData,
    this.searchMatches,
  });
  final WidgetBuilder titleBuilder;
  final WidgetBuilder builder;
  final IconData iconData;
  final IconData? selectedIconData;
  final bool Function(String value, BuildContext context)? searchMatches;
}
