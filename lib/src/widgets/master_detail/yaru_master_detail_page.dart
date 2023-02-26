import 'package:flutter/material.dart';
import 'package:yaru_widgets/foundation.dart' show YaruPageController;

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

typedef YaruAppBarBuilder = PreferredSizeWidget? Function(BuildContext context);

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
    this.appBarBuilder,
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
  ///
  /// See also:
  ///  * [YaruMasterDetailPage.appBarBuilder]
  final PreferredSizeWidget? appBar;

  /// An optional custom AppBar builder for the master pane.
  ///
  /// The builder is called whenever the master-detail layout changes between
  /// landscape and portrait modes.
  ///
  /// See also:
  ///  * [YaruMasterDetailPage.appBar]
  final YaruAppBarBuilder? appBarBuilder;

  /// An optional bottom bar for the left pane.
  final Widget? bottomBar;

  /// An optional index of the initial page to show.
  final int? initialIndex;

  /// Called when the user selects a page.
  final ValueChanged<int?>? onSelected;

  /// An optional controller that can be used to navigate to a specific index.
  final YaruPageController? controller;

  /// Returns the orientation of the [YaruMasterDetailPage] that most tightly
  /// encloses the given context.
  static Orientation orientationOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_YaruMasterDetailLayoutScope>()!
        .orientation;
  }

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
    return Scaffold(
      body: _YaruMasterDetailLayoutBuilder(
        builder: (context, orientation) {
          switch (orientation) {
            case Orientation.portrait:
              return YaruPortraitLayout(
                tileBuilder: widget.tileBuilder,
                pageBuilder: widget.pageBuilder,
                onSelected: widget.onSelected,
                appBar: widget.appBar ?? widget.appBarBuilder?.call(context),
                bottomBar: widget.bottomBar,
                controller: _controller,
              );
            case Orientation.landscape:
              return YaruLandscapeLayout(
                tileBuilder: widget.tileBuilder,
                pageBuilder: widget.pageBuilder,
                onSelected: widget.onSelected,
                layoutDelegate: widget.layoutDelegate,
                previousPaneWidth: _previousPaneWidth,
                onLeftPaneWidthChange: (width) => _previousPaneWidth = width,
                appBar: widget.appBar ?? widget.appBarBuilder?.call(context),
                bottomBar: widget.bottomBar,
                controller: _controller,
              );
          }
        },
      ),
    );
  }
}

class _YaruMasterDetailLayoutBuilder extends StatelessWidget {
  const _YaruMasterDetailLayoutBuilder({
    required this.builder,
  });

  final OrientationWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final breakpoint = YaruMasterDetailTheme.of(context).breakpoint ??
        YaruMasterDetailThemeData.fallback().breakpoint!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final orientation = constraints.maxWidth < breakpoint
            ? Orientation.portrait
            : Orientation.landscape;
        return _YaruMasterDetailLayoutScope(
          orientation: orientation,
          builder: builder,
        );
      },
    );
  }
}

class _YaruMasterDetailLayoutScope extends InheritedWidget {
  _YaruMasterDetailLayoutScope({
    required this.orientation,
    required OrientationWidgetBuilder builder,
  }) : super(
          child: Builder(builder: (context) => builder(context, orientation)),
        );

  final Orientation orientation;

  @override
  bool updateShouldNotify(_YaruMasterDetailLayoutScope oldWidget) {
    return orientation != oldWidget.orientation;
  }
}
