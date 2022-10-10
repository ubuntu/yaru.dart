import 'package:flutter/material.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_master_tile.dart';

const double _kScrollbarThickness = 8.0;
const double _kScrollbarMargin = 2.0;

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
    final scrollbarThicknessWithTrack =
        _calcScrollbarThicknessWithTrack(context);

    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 6.0),
      padding: !materialTiles
          ? EdgeInsets.symmetric(
              horizontal: scrollbarThicknessWithTrack,
              vertical: 8.0,
            )
          : null,
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

  double _calcScrollbarThicknessWithTrack(final BuildContext context) {
    final scrollbarTheme = Theme.of(context).scrollbarTheme;

    final doubleMarginWidth = scrollbarTheme.crossAxisMargin != null
        ? scrollbarTheme.crossAxisMargin! * 2
        : _kScrollbarMargin * 2;

    final scrollBarThumbThikness =
        scrollbarTheme.thickness?.resolve({MaterialState.hovered}) ??
            _kScrollbarThickness;

    return doubleMarginWidth + scrollBarThumbThikness;
  }
}
