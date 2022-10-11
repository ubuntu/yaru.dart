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
    required this.titleBuilder,
    required this.pageBuilder,
    required this.onSelected,
    required this.leftPaneWidth,
    required this.allowLeftPaneResize,
    required this.leftPaneMinWidth,
    required this.pageMinWidth,
    this.onLeftPaneWidthChange,
    this.appBar,
  });

  /// The total number of pages.
  final int length;

  /// Current index of the selected page.
  final int selectedIndex;

  /// A builder that is called for each page to build its master tile.
  final YaruMasterDetailBuilder tileBuilder;

  /// A builder that is called for each page to build its title.
  final YaruMasterDetailBuilder titleBuilder;

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
  }

  @override
  void didUpdateWidget(covariant YaruLandscapeLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    final width = MediaQuery.of(context).size.width;

    // Avoid left pane to overflow when resizing the window
    if (widget.allowLeftPaneResize &&
        _leftPaneWidth >= width - widget.pageMinWidth) {
      _leftPaneWidth = width - widget.pageMinWidth;
      widget.onLeftPaneWidthChange?.call(_leftPaneWidth);
    }
  }

  void _onTap(int index) {
    widget.onSelected(index);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return _maybeBuildGlobalMouseRegion(
      LayoutBuilder(
        builder: (context, boxConstraints) => Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLeftPane(),
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
        ),
      ),
    );
  }

  Color get _separatorColor => Colors.black.withOpacity(0.1);

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
    return Container(
      width: _leftPaneWidth,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 1,
            color: _separatorColor,
          ),
        ),
      ),
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
    return Positioned(
      child: AnimatedContainer(
        duration: _kLeftPaneResizingRegionAnimationDuration,
        color:
            _isHovering || _isDragging ? _separatorColor : Colors.transparent,
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
              _paneWidthMove += details.delta.dx;
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
      left: 0,
    );
  }
}
