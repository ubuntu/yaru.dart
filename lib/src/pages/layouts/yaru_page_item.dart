import 'package:flutter/widgets.dart';

class YaruPageItem {
  const YaruPageItem({
    required this.titleBuilder,
    required this.builder,
    required this.iconBuilder,
    this.onTap,
  });

  /// We recommend to use [YaruPageItemTitle] here to have correct styling
  final WidgetBuilder titleBuilder;

  final WidgetBuilder builder;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
  final void Function(BuildContext context)? onTap;
}
