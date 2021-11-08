import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_landscape_layout.dart';
import 'package:yaru_widgets/src/yaru_page_item.dart';
import 'package:yaru_widgets/src/yaru_portrait_layout.dart';

class YaruMasterDetailPage extends StatefulWidget {
  const YaruMasterDetailPage({
    Key? key,
    required this.appBarHeight,
    required this.pageItems,
    required this.previousIconData,
    required this.searchIconData,
    required this.leftPaneWidth,
    required this.searchHint,
  }) : super(key: key);

  final List<YaruPageItem> pageItems;
  final double appBarHeight;
  final double leftPaneWidth;
  final IconData previousIconData;
  final IconData searchIconData;
  final String searchHint;

  @override
  _YaruMasterDetailPageState createState() => _YaruMasterDetailPageState();
}

class _YaruMasterDetailPageState extends State<YaruMasterDetailPage> {
  var _index = -1;
  var _previousIndex = 0;

  void _setIndex(int index) {
    _previousIndex = _index;
    _index = index;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 620) {
          return YaruPortraitLayout(
            selectedIndex: _index,
            pages: widget.pageItems,
            onSelected: _setIndex,
            appBarHeight: widget.appBarHeight,
            previousIconData: widget.previousIconData,
            searchIconData: widget.searchIconData,
            searchHint: widget.searchHint,
          );
        } else {
          return YaruLandscapeLayout(
            selectedIndex: _index == -1 ? _previousIndex : _index,
            pages: widget.pageItems,
            onSelected: _setIndex,
            appBarHeight: widget.appBarHeight,
            leftPaneWidth: widget.leftPaneWidth,
            searchIconData: widget.searchIconData,
            searchHint: widget.searchHint,
          );
        }
      },
    );
  }
}
