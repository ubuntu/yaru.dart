import 'package:flutter/material.dart';

import '../icon_items.dart';
// import '../utils.dart';
// import 'clickable_icon.dart';

class IconGrid extends StatelessWidget {
  const IconGrid({
    super.key,
    required this.iconItems,
    required this.iconSize,
  });

  final List<IconItem> iconItems;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: iconSize * 1.5,
      ),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      itemCount: iconItems.length,
      itemBuilder: (context, index) {
        //TODO: change this back, testing
        return iconItems[index].iconBuilder(context, 30);
      },
    );
  }
}
