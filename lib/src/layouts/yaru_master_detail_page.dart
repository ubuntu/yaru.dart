import 'package:flutter/material.dart';
import '../constants.dart';
import 'yaru_detail_page.dart';
import 'yaru_landscape_layout.dart';
import 'yaru_master_detail_layout_delegate.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_master_tile.dart';
import 'yaru_portrait_layout.dart';

const _kDefaultPaneWidth = 280.0;

typedef YaruMasterDetailBuilder = Widget Function(
  BuildContext context,
  int index,
  bool selected,
);

/// A responsive master-detail page.
///
/// [YaruMasterDetailPage] automatically switches between portrait and landscape
/// modes using [kYaruMasterDetailBreakpoint] by default as a breakpoint width.
///
/// ```dart
/// YaruMasterDetailPage(
///   leftPaneWidth: 280,
///   length: 8,
///   appBar: AppBar(title: const Text('Master')),
///   tileBuilder: (context, index, selected) => YaruMasterTile(
///     leading: const Icon(YaruIcons.menu),
///     title: Text('Master $index'),
///   ),
///   pageBuilder: (context, index) => YaruDetailPage(
///     appBar: AppBar(
///       title: Text('Detail $index'),
///     ),
///     body: Center(child: Text('Detail $index')),
///   ),
/// )
/// ```
///
/// | Portrait | Landscape |
/// |---|---|
/// | ![portrait](https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/doc/assets/yaru_master_detail_page-portrait.png) | ![landscape](https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/doc/assets/yaru_master_detail_page-landscape.png) |
///
/// See also:
///  * [YaruMasterTile] - provides the recommended layout for [tileBuilder].
///  * [YaruDetailPage] - provides the recommended layout for [pageBuilder].
///  * [YaruMasterDetailTheme] - allows customizing the looks of [YaruMasterDetailPage].
class YaruMasterDetailPage extends StatefulWidget {
  const YaruMasterDetailPage({
    super.key,
    required this.length,
    required this.tileBuilder,
    required this.pageBuilder,
    this.layoutDelegate =
        const YaruMasterFixedPaneDelegate(paneWidth: _kDefaultPaneWidth),
    this.appBar,
    this.initialIndex,
    this.onSelected,
    this.controller,
  });

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its master tile.
  ///
  /// See also:
  ///  * [YaruMasterTile]
  final YaruMasterDetailBuilder tileBuilder;

  /// A builder that is called for each page to build its detail page.
  ///
  /// See also:
  ///  * [YaruDetailPage]
  final IndexedWidgetBuilder pageBuilder;

  /// Specifies the initial width of left pane.
  final YaruMasterDetailPaneLayoutDelegate layoutDelegate;

  /// An optional custom AppBar for the left pane.
  final PreferredSizeWidget? appBar;

  /// An optional index of the initial page to show.
  final int? initialIndex;

  /// Called when the user selects a page.
  final ValueChanged<int?>? onSelected;

  /// An optional controller that can be used to navigate to a specific index.
  final ValueNotifier<int>? controller;

  @override
  _YaruMasterDetailPageState createState() => _YaruMasterDetailPageState();
}

class _YaruMasterDetailPageState extends State<YaruMasterDetailPage> {
  var _index = -1;
  var _previousIndex = 0;

  double? _previousPaneWidth;

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
    final breakpoint = YaruMasterDetailTheme.of(context).breakpoint ??
        YaruMasterDetailThemeData.fallback().breakpoint!;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return YaruPortraitLayout(
            length: widget.length,
            selectedIndex: _index,
            tileBuilder: widget.tileBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: _setIndex,
            appBar: widget.appBar,
            controller: widget.controller,
          );
        } else {
          return YaruLandscapeLayout(
            length: widget.length,
            selectedIndex: _index == -1 ? _previousIndex : _index,
            tileBuilder: widget.tileBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: _setIndex,
            layoutDelegate: widget.layoutDelegate,
            previousPaneWidth: _previousPaneWidth,
            onLeftPaneWidthChange: (panWidth) => _previousPaneWidth = panWidth,
            appBar: widget.appBar,
            controller: widget.controller,
          );
        }
      },
    );
  }
}
