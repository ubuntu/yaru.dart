import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'common/icon_grid.dart';
import 'common/icon_table.dart';
import 'icon_items.dart';
import 'provider/icon_view_model.dart';

class IconView extends StatelessWidget with WatchItMixin {
  const IconView({super.key, required this.iconItems});

  final List<IconItem> iconItems;

  @override
  Widget build(BuildContext context) {
    final searchActive = watchPropertyValue(
      (IconViewModel m) => m.searchActive,
    );
    final searchQuery = watchPropertyValue((IconViewModel m) => m.searchQuery);
    final gridView = watchPropertyValue((IconViewModel m) => m.gridView);
    final iconSize = watchPropertyValue((IconViewModel m) => m.iconSize);

    final localIconItems = searchActive
        ? iconItems.where((iconItem) {
            return iconItem.name.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
          }).toList()
        : iconItems;

    return gridView
        ? IconGrid(iconItems: localIconItems, iconSize: iconSize)
        : IconTable(iconItems: localIconItems, iconSize: iconSize);
  }
}
