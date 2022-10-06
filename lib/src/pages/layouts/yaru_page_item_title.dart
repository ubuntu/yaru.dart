import 'package:flutter/widgets.dart';
import '../../../yaru_widgets.dart';

/// This is an optional widget, which do nothing by itself.
/// Is used to notify the layout builder to use some default text style.
/// For example, [YaruMasterDetailPage] will have maxLines: 1 and textOverflow: ellipsis
class YaruPageItemTitle extends StatelessWidget {
  const YaruPageItemTitle(this.child, {super.key});

  /// Shortcut to directly wrap a string into a [Text] widget
  YaruPageItemTitle.text(String text, {super.key}) : child = Text(text);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
