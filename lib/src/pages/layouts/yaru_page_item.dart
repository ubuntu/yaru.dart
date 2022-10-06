import 'package:flutter/widgets.dart';

class YaruPageItem {
  const YaruPageItem({
    required this.titleBuilder,
    required this.builder,
    this.searchMatches,
    required this.iconBuilder,
    this.onTap,
  });

  /// We recommend to use [YaruPageItemTitle] here to avoid line wrap
  final WidgetBuilder titleBuilder;

  final WidgetBuilder builder;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
  final bool Function(String value, BuildContext context)? searchMatches;
  final void Function(BuildContext context)? onTap;
}
