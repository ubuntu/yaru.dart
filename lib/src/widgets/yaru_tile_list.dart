import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// A bordered, vertical list of widgets, separated by [Divider]s.
///
/// This widget is typically used to display [YaruListTile.square]s in a column.
class YaruTileList extends StatelessWidget {
  const YaruTileList({required this.children, super.key});

  /// See [Column.children].
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return YaruBorderContainer(
      borderStrokeAlign: BorderSide.strokeAlignOutside,
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children.separatedBy(const Divider()),
      ),
    );
  }
}
