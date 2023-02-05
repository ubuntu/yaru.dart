import 'package:flutter/material.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_master_tile.dart';

class YaruMasterListView extends StatefulWidget {
  const YaruMasterListView({
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
  State<YaruMasterListView> createState() => _YaruMasterListViewState();
}

class _YaruMasterListViewState extends State<YaruMasterListView> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);
    return ListView.separated(
      separatorBuilder: (_, __) => SizedBox(height: theme.tileSpacing ?? 0),
      padding: theme.listPadding,
      controller: _controller,
      itemCount: widget.length,
      itemBuilder: (context, index) => YaruMasterTileScope(
        index: index,
        selected: index == widget.selectedIndex,
        onTap: () => widget.onTap(index),
        child: Builder(
          builder: (context) =>
              widget.builder(context, index, index == widget.selectedIndex),
        ),
      ),
    );
  }
}
