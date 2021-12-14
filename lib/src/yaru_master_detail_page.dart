import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_landscape_layout.dart';
import 'package:yaru_widgets/src/yaru_page_item.dart';
import 'package:yaru_widgets/src/yaru_portrait_layout.dart';

class YaruMasterDetailPage extends StatefulWidget {
  /// Creates a basic responsive layout with yaru theme,
  /// renders layout based on [width] constrain.
  ///
  /// * if [constraints.maxWidth] < 620 the widget will render [YaruPotraitLayout]
  /// * if [constraints.maxWidth] > 620 widget will render [YaruLandscapeLayout]
  ///
  /// for example:
  /// ```dart
  /// YaruMasterDetailPage(
  ///       appBarHeight: 48,
  ///       leftPaneWidth: 280,
  ///       previousIconData: YaruIcons.go_previous,
  ///       searchHint: 'Search...',
  ///       searchIconData: YaruIcons.search,
  ///      pageItems: pageItems,
  ///     );
  /// ```
  const   YaruMasterDetailPage({
    Key? key,
    required this.appBarHeight,
    required this.pageItems,
    required this.previousIconData,
    required this.searchIconData,
    required this.leftPaneWidth,
    required this.searchHint,
  }) : super(key: key);


  /// Creates horizontal array of pages.
  /// All the `children` will be of type [YaruPageItem].
  ///
  /// These List of items are passed to [YaruLandscapeLayout] and [YaruPortraitLayout].
  final List<YaruPageItem> pageItems;

  /// Specifies the [AppBar] height.
  final double appBarHeight;

  /// Specifies the width of left pane.
  final double leftPaneWidth;

  /// Property to specify the previous icon data
  final IconData previousIconData;

  /// The icon that is given to the search widget.
  final IconData searchIconData;

  /// The hint text given to the search widget.
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
