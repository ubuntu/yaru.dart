import 'package:flutter/widgets.dart';
import 'yaru_page_item_title.dart';

class YaruPageItem {
  const YaruPageItem({
    required this.titleBuilder,
    required this.label,
    required this.builder,
    required this.iconBuilder,
    this.onTap,
  });

  /// Shortcut to directly build [titleBuilder] with the [label] string into a [YaruPageItemTitle]
  YaruPageItem.titleFromLabel({
    required this.label,
    required this.builder,
    required this.iconBuilder,
    this.onTap,
  }) : titleBuilder = ((context) => YaruPageItemTitle.text(label));

  /// We recommend to use [YaruPageItemTitle] here to have correct styling
  final WidgetBuilder titleBuilder;

  final String label;

  final WidgetBuilder builder;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
  final void Function(BuildContext context)? onTap;
}
