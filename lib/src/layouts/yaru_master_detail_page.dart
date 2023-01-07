import 'package:flutter/material.dart';

import '../constants.dart';
import 'yaru_detail_page.dart';
import 'yaru_landscape_layout.dart';
import 'yaru_master_detail_layout_delegate.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_master_tile.dart';
import 'yaru_page_controller.dart';
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
    this.length,
    required this.tileBuilder,
    required this.pageBuilder,
    this.layoutDelegate =
        const YaruMasterFixedPaneDelegate(paneWidth: _kDefaultPaneWidth),
    this.appBar,
    this.bottomBar,
    this.initialIndex,
    this.onSelected,
    this.controller,
  })  : assert(initialIndex == null || controller == null),
        assert((length == null) != (controller == null));

  /// The total number of pages.
  final int? length;

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

  /// An optional bottom bar for the left pane.
  final Widget? bottomBar;

  /// An optional index of the initial page to show.
  final int? initialIndex;

  /// Called when the user selects a page.
  final ValueChanged<int?>? onSelected;

  /// An optional controller that can be used to navigate to a specific index.
  final YaruPageController? controller;

  @override
  _YaruMasterDetailPageState createState() => _YaruMasterDetailPageState();
}

class _YaruMasterDetailPageState extends State<YaruMasterDetailPage> {
  double? _previousPaneWidth;
  late YaruPageController _controller;

  void _updateController() => _controller = widget.controller ??
      YaruPageController(
        length: widget.length ?? widget.controller!.length,
        initialIndex: widget.initialIndex ?? -1,
      );

  @override
  void initState() {
    super.initState();
    _updateController();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant YaruMasterDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.length != oldWidget.length ||
        widget.initialIndex != oldWidget.initialIndex) {
      _updateController();
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
            tileBuilder: widget.tileBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: widget.onSelected,
            appBar: widget.appBar,
            bottomBar: widget.bottomBar,
            controller: _controller,
          );
        } else {
          return YaruLandscapeLayout(
            tileBuilder: widget.tileBuilder,
            pageBuilder: widget.pageBuilder,
            onSelected: widget.onSelected,
            layoutDelegate: widget.layoutDelegate,
            previousPaneWidth: _previousPaneWidth,
            onLeftPaneWidthChange: (width) => _previousPaneWidth = width,
            appBar: widget.appBar,
            bottomBar: widget.bottomBar,
            controller: _controller,
          );
        }
      },
    );
  }
}
