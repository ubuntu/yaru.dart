import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/icon_grid.dart';
import 'common/icon_table.dart';
import 'icon_items.dart';
import 'provider/icon_view_model.dart';

class IconView extends StatelessWidget {
  const IconView({
    super.key,
    required this.iconItems,
  });

  final List<IconItem> iconItems;

  @override
  Widget build(BuildContext context) {
    final searchActive =
        context.select<IconViewModel, bool>((m) => m.searchActive);
    final searchQuery =
        context.select<IconViewModel, String>((m) => m.searchQuery);
    final gridView = context.select<IconViewModel, bool>((m) => m.gridView);
    final iconSize = context.select<IconViewModel, double>((m) => m.iconSize);

    final localIconItems = searchActive
        ? iconItems.where((iconItem) {
            return iconItem.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList()
        : iconItems;

    return gridView
        ? IconGrid(
            iconItems: localIconItems,
            iconSize: iconSize,
          )
        : IconTable(
            iconItems: localIconItems,
            iconSize: iconSize,
          );
  }
}
