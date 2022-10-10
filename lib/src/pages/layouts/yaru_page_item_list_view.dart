import 'package:flutter/material.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_master_tile.dart';

class YaruPageItemListView extends StatelessWidget {
  const YaruPageItemListView({
    super.key,
    required this.length,
    required this.selectedIndex,
    required this.builder,
    required this.onTap,
    this.materialTiles = false,
  });

  final int length;
  final YaruMasterDetailBuilder builder;
  final int selectedIndex;
  final Function(int index) onTap;
  final bool materialTiles;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 6.0),
      padding:
          !materialTiles ? const EdgeInsets.symmetric(vertical: 8.0) : null,
      controller: ScrollController(),
      itemCount: length,
      itemBuilder: (context, index) => YaruMasterTileScope(
        index: index,
        selected: index == selectedIndex,
        onTap: () => onTap(index),
        child: Builder(
          builder: (context) => builder(context, index, index == selectedIndex),
        ),
      ),
    );
  }
}
