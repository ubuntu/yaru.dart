import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_master_list_view.dart';

class YaruLandscapeLayout extends StatefulWidget {
  /// Creates a landscape layout
  const YaruLandscapeLayout({
    super.key,
    required this.length,
    required this.selectedIndex,
    required this.tileBuilder,
    required this.pageBuilder,
    required this.onSelected,
    required this.leftPaneWidth,
    required this.allowLeftPaneResize,
    required this.leftPaneMinWidth,
    required this.pageMinWidth,
    this.onLeftPaneWidthChange,
    this.appBar,
    this.controller,
  });

  /// The total number of pages.
  final int length;

  /// Current index of the selected page.
  final int selectedIndex;

  /// A builder that is called for each page to build its master tile.
  final YaruMasterDetailBuilder tileBuilder;

  /// A builder that is called for each page to build its detail page.
  final IndexedWidgetBuilder pageBuilder;

  /// Callback that returns an index when the page changes.
  final ValueChanged<int> onSelected;

  /// Specifies the initial width of left pane.
  final double leftPaneWidth;

  /// If true, allow the left pane to be resized.
  final bool allowLeftPaneResize;

  /// If [allowLeftPaneResize], specifies the min-width of the left pane.
  final double leftPaneMinWidth;

  /// If [allowLeftPaneResize], callback called when the left pane is resizing.
  final Function(double)? onLeftPaneWidthChange;

  /// If [allowLeftPaneResize], specifies the min-width of the page.
  final double pageMinWidth;

  /// An optional [PreferredSizeWidget] used as the left [AppBar]
  /// If provided, a second [AppBar] will be created right to it.
  final PreferredSizeWidget? appBar;

  /// An optional controller that can be used to navigate to a specific index.
  final ValueNotifier<int>? controller;

  @override
  State<YaruLandscapeLayout> createState() => _YaruLandscapeLayoutState();
}

const _kLeftPaneResizingRegionWidth = 4.0;
const _kLeftPaneResizingRegionAnimationDuration = Duration(milliseconds: 250);

class _YaruLandscapeLayoutState extends State<YaruLandscapeLayout> {
  late int _selectedIndex;
  late double _leftPaneWidth;

  double _initialPaneWidth = 0.0;
  double _paneWidthMove = 0.0;

  bool _isDragging = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _leftPaneWidth = widget.leftPaneWidth;
    widget.controller?.addListener(_controllerCallback);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_controllerCallback);
    super.dispose();
  }

  void _controllerCallback() {
    _onTap(widget.controller!.value);
  }

  void _onTap(int index) {
    widget.onSelected(index);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return _maybeBuildGlobalMouseRegion(
      LayoutBuilder(
        builder: (context, boxConstraints) {
          // Avoid left pane to overflow when resizing the window
          if (widget.allowLeftPaneResize &&
              _leftPaneWidth >= boxConstraints.maxWidth - widget.pageMinWidth) {
            _leftPaneWidth = boxConstraints.maxWidth - widget.pageMinWidth;
            widget.onLeftPaneWidthChange?.call(_leftPaneWidth);
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLeftPane(),
              _buildVerticalSeparator(),
              Expanded(
                child: widget.allowLeftPaneResize
                    ? Stack(
                        children: [
                          _buildPage(context),
                          _buildLeftPaneResizer(context, boxConstraints),
                        ],
                      )
                    : _buildPage(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _maybeBuildGlobalMouseRegion(Widget child) {
    if (widget.allowLeftPaneResize) {
      return MouseRegion(
        cursor: _isHovering || _isDragging
            ? SystemMouseCursors.resizeColumn
            : MouseCursor.defer,
        child: child,
      );
    }

    return child;
  }

  Widget _buildLeftPane() {
    return SizedBox(
      width: _leftPaneWidth,
      child: Scaffold(
        appBar: widget.appBar,
        body: YaruMasterListView(
          length: widget.length,
          selectedIndex: _selectedIndex,
          onTap: _onTap,
          builder: widget.tileBuilder,
        ),
      ),
    );
  }

  Widget _buildVerticalSeparator() {
    // Fix for the ultra white divider on flutter web
    final darkAndWeb =
        Theme.of(context).brightness == Brightness.dark && kIsWeb;
    if (darkAndWeb) {
      return const VerticalDivider(
        thickness: 0,
        width: 0.01,
      );
    }
    return const VerticalDivider(
      thickness: 1,
      width: 1,
    );
  }

  Widget _buildPage(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        pageTransitionsTheme: theme.landscapeTransitions,
      ),
      child: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey(_selectedIndex),
            child: widget.length > _selectedIndex
                ? widget.pageBuilder(context, _selectedIndex)
                : widget.pageBuilder(context, 0),
          ),
        ],
        onPopPage: (route, result) => route.didPop(result),
        observers: [HeroController()],
      ),
    );
  }

  Widget _buildLeftPaneResizer(
    BuildContext context,
    BoxConstraints boxConstraints,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Positioned(
      child: AnimatedContainer(
        duration: _kLeftPaneResizingRegionAnimationDuration,
        color: _isHovering || _isDragging
            ? Theme.of(context).dividerColor
            : Colors.transparent,
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          onEnter: (event) => setState(() {
            _isHovering = true;
          }),
          onExit: (event) => setState(() {
            _isHovering = false;
          }),
          child: GestureDetector(
            onPanStart: (details) => setState(() {
              _isDragging = true;
              _initialPaneWidth = _leftPaneWidth;
            }),
            onPanUpdate: (details) => setState(() {
              _paneWidthMove += isRtl ? -details.delta.dx : details.delta.dx;
              final width = _initialPaneWidth + _paneWidthMove;
              final maxWidth = boxConstraints.maxWidth - widget.pageMinWidth;

              final previousPaneWidth = _leftPaneWidth;

              if (width >= maxWidth) {
                _leftPaneWidth = maxWidth;
              } else if (width < widget.leftPaneMinWidth) {
                _leftPaneWidth = widget.leftPaneMinWidth;
              } else {
                _leftPaneWidth = width;
              }

              if (previousPaneWidth != _leftPaneWidth) {
                widget.onLeftPaneWidthChange?.call(width);
              }
            }),
            onPanEnd: (details) => setState(() {
              _isDragging = false;
              _paneWidthMove = 0.0;
            }),
          ),
        ),
      ),
      width: _kLeftPaneResizingRegionWidth,
      top: 0,
      bottom: 0,
      left: isRtl ? null : 0,
      right: isRtl ? 0 : null,
    );
  }
}
