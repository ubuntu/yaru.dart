import 'package:flutter/widgets.dart';

class PageItem {
  const PageItem(
      {required this.title, required this.builder, required this.iconData});
  final String title;
  final WidgetBuilder builder;
  final IconData iconData;
}
