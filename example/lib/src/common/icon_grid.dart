import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/icon_size_provider.dart';
import '../utils.dart';
import 'clickable_icon.dart';
import 'icon_item.dart';

class IconGrid extends StatelessWidget {
  const IconGrid({
    super.key,
    required this.iconItems,
  });

  final List<IconItem> iconItems;

  @override
  Widget build(BuildContext context) {
    final iconViewProvider = Provider.of<IconViewProvider>(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: iconViewProvider.iconSize * 1.5,
      ),
      padding: const EdgeInsets.all(8),
      itemCount: iconItems.length,
      itemBuilder: (context, index) => Tooltip(
        verticalOffset: iconViewProvider.iconSize / 2,
        waitDuration: const Duration(milliseconds: 250),
        message: beautifyIconName(iconItems[index].name),
        child: ClickableIcon(iconItem: iconItems[index]),
      ),
    );
  }
}
