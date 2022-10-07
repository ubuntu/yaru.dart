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
    this.previousIconData,
    required this.leftPaneWidth,
    this.appBar,
    this.initialIndex,
    this.onSelected,
  });

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its master tile.
  final YaruMasterDetailBuilder tileBuilder;

  /// A builder that is called for each page to build its title.
  final YaruMasterDetailBuilder titleBuilder;

  /// A builder that is called for each page to build its detail page.
  final IndexedWidgetBuilder pageBuilder;

  /// Specifies the width of left pane.
  final double leftPaneWidth;

  /// Property to specify the previous icon data
  final IconData? previousIconData;

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

  void _setIndex(int index) {
    _previousIndex = _index;
    _index = index;
    widget.onSelected?.call(index == -1 ? null : index);
  }

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex ?? -1;
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
            previousIconData: widget.previousIconData,
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
            leftPaneWidth: widget.leftPaneWidth,
            appBar: widget.appBar,
          );
        }
      },
    );
  }
}
