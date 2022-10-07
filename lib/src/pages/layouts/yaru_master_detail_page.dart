import 'package:flutter/material.dart';
import 'yaru_landscape_layout.dart';
import 'yaru_portrait_layout.dart';

typedef YaruMasterDetailBuilder = Widget Function(
  BuildContext context,
  int index,
  bool selected,
);

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
    super.key,
    required this.length,
    required this.iconBuilder,
    required this.titleBuilder,
    required this.pageBuilder,
    this.previousIconData,
    required this.leftPaneWidth,
    this.appBar,
  });

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its icon.
  final YaruMasterDetailBuilder iconBuilder;

  /// A builder that is called for each page to build its title.
  final YaruMasterDetailBuilder titleBuilder;

  /// A builder that is called for each page to build its content.
  final IndexedWidgetBuilder pageBuilder;

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
            length: widget.length,
            selectedIndex: _index,
            iconBuilder: widget.iconBuilder,
            titleBuilder: widget.titleBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: _setIndex,
            previousIconData: widget.previousIconData,
            appBar: widget.appBar,
          );
        } else {
          return YaruLandscapeLayout(
            length: widget.length,
            selectedIndex: _index == -1 ? _previousIndex : _index,
            iconBuilder: widget.iconBuilder,
            titleBuilder: widget.titleBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: _setIndex,
            leftPaneWidth: widget.leftPaneWidth,
            appBar: widget.appBar,
          );
        }
      },
    );
  }
}
