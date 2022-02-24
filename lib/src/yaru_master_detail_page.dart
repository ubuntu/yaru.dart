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
  ///      pageItems: pageItems,
  ///     );
  /// ```
  const YaruMasterDetailPage({
    Key? key,
    required this.pageItems,
    this.previousIconData,
    required this.leftPaneWidth,
    this.appBar,
  }) : super(key: key);

  /// Creates horizontal array of pages.
  /// All the `children` will be of type [YaruPageItem].
  ///
  /// These List of items are passed to [YaruLandscapeLayout] and [YaruPortraitLayout].
  final List<YaruPageItem> pageItems;

  /// Specifies the width of left pane.
  final double leftPaneWidth;

  /// Property to specify the previous icon data
  final IconData? previousIconData;

  /// An optional custom AppBar for the left pane.
  final PreferredSizeWidget? appBar;

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
            pageItems: widget.pageItems,
            onSelected: _setIndex,
            previousIconData: widget.previousIconData,
            appBar: widget.appBar,
          );
        } else {
          return YaruLandscapeLayout(
            selectedIndex: _index == -1 ? _previousIndex : _index,
            pageItems: widget.pageItems,
            onSelected: _setIndex,
            leftPaneWidth: widget.leftPaneWidth,
            appBar: widget.appBar,
          );
        }
      },
    );
  }
}
