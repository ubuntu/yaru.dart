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
    required this.tileBuilder,
    required this.titleBuilder,
    required this.pageBuilder,
    required this.leftPaneWidth,
    this.leftPaneMinWidth = 175.0,
    this.appBar,
    this.initialIndex,
    this.onSelected,
  });

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its master tile.
  ///
  /// See also:
  ///  * [YaruMasterTile]
  final YaruMasterDetailBuilder tileBuilder;

  /// A builder that is called for each page to build its title.
  final YaruMasterDetailBuilder titleBuilder;

  /// A builder that is called for each page to build its detail page.
  ///
  /// See also:
  ///  * [YaruDetailPage]
  final IndexedWidgetBuilder pageBuilder;

  /// Specifies the initial width of left pane.
  final double leftPaneWidth;

  /// Specifies the min-width of left pane.
  /// Defaults to 175
  final double leftPaneMinWidth;

  /// An optional custom AppBar for the left pane.
  final PreferredSizeWidget? appBar;

  /// An optional index of the initial page to show.
  final int? initialIndex;

  /// Called when the user selects a page.
  final ValueChanged<int?>? onSelected;

  @override
  _YaruMasterDetailPageState createState() => _YaruMasterDetailPageState();
}

class _YaruMasterDetailPageState extends State<YaruMasterDetailPage> {
  var _index = -1;
  var _previousIndex = 0;

  late double _leftPaneWidth;

  void _setIndex(int index) {
    _previousIndex = _index;
    _index = index;
    widget.onSelected?.call(index == -1 ? null : index);
  }

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex ?? -1;
    _leftPaneWidth = widget.leftPaneWidth;
  }

  @override
  void didUpdateWidget(covariant YaruMasterDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _index = widget.initialIndex ?? -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 620) {
          return YaruPortraitLayout(
            length: widget.length,
            selectedIndex: _index,
            tileBuilder: widget.tileBuilder,
            titleBuilder: widget.titleBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: _setIndex,
            appBar: widget.appBar,
          );
        } else {
          return YaruLandscapeLayout(
            length: widget.length,
            selectedIndex: _index == -1 ? _previousIndex : _index,
            tileBuilder: widget.tileBuilder,
            titleBuilder: widget.titleBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: _setIndex,
            leftPaneWidth: _leftPaneWidth,
            leftPaneMinWidth: widget.leftPaneMinWidth,
            onLeftPaneWidthChange: (panWidth) => _leftPaneWidth = panWidth,
            appBar: widget.appBar,
          );
        }
      },
    );
  }
}
