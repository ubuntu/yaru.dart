import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_page_item_list_view.dart';

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
    required this.leftPaneMinWidth,
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

  /// Specifies the min-width of left pane.
  final double leftPaneMinWidth;

  final Function(double)? onLeftPaneWidthChange;

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
    _selectedIndex = widget.selectedIndex;
    _leftPaneWidth = widget.leftPaneWidth;
    super.initState();
  }

  void _onTap(int index) {
    widget.onSelected(index);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isHovering || _isDragging
          ? SystemMouseCursors.resizeColumn
          : MouseCursor.defer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLeftPane(),
          Expanded(
            child: Stack(
              children: [
                _buildPage(context),
                _buildLeftPaneResizer(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _separatorColor => Colors.black.withOpacity(0.1);

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
        body: YaruPageItemListView(
          length: widget.length,
          selectedIndex: _selectedIndex,
          onTap: _onTap,
          builder: widget.tileBuilder,
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        pageTransitionsTheme: YaruPageTransitionsTheme.vertical,
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

  Widget _buildLeftPaneResizer(BuildContext context) {
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

              final previousPaneWidth = _leftPaneWidth;
              _leftPaneWidth = width >= widget.leftPaneMinWidth
                  ? width
                  : widget.leftPaneMinWidth;

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
      height: MediaQuery.of(context).size.height,
      width: _kLeftPaneResizingRegionWidth,
      top: 0,
      left: 0,
    );
  }
}
