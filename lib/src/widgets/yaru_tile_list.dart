import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class YaruTileList extends StatelessWidget {
  const YaruTileList({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return YaruBorderContainer(
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children.separatedBy(const Divider()),
      ),
    );
  }
}
