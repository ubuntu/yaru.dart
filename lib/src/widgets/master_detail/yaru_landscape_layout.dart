import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yaru_widgets/foundation.dart' show YaruPageController;
import 'package:yaru_widgets/widgets.dart'
    show YaruTitleBarTheme, YaruTitleBarThemeData, YaruTitleBarStyle;

import 'yaru_master_detail_layout_delegate.dart';
import 'yaru_master_detail_page.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_master_list_view.dart';

class YaruLandscapeLayout extends StatefulWidget {
  const YaruLandscapeLayout({
    super.key,
    required this.navigatorKey,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    required this.tileBuilder,
    required this.pageBuilder,
    this.onSelected,
    required this.layoutDelegate,
    this.previousPaneWidth,
    this.onLeftPaneWidthChange,
    this.appBar,
    this.bottomBar,
    required this.controller,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final List<NavigatorObserver> navigatorObservers;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final YaruMasterTileBuilder tileBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final ValueChanged<int>? onSelected;
  final YaruMasterDetailPaneLayoutDelegate layoutDelegate;
  final double? previousPaneWidth;
  final ValueChanged<double>? onLeftPaneWidthChange;
  final PreferredSizeWidget? appBar;
  final Widget? bottomBar;
  final YaruPageController controller;

  @override
  State<YaruLandscapeLayout> createState() => _YaruLandscapeLayoutState();
}

const _kLeftPaneResizingRegionWidth = 4.0;
const _kLeftPaneResizingRegionAnimationDuration = Duration(milliseconds: 250);

class _YaruLandscapeLayoutState extends State<YaruLandscapeLayout> {
  late int _selectedIndex;

  double? _paneWidth;
  double? _initialPaneWidth;
  double _paneWidthMove = 0.0;

  bool _isDragging = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _paneWidth = widget.previousPaneWidth;
    widget.controller.addListener(_controllerCallback);
    _selectedIndex = max(widget.controller.index, 0);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerCallback);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant YaruLandscapeLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_controllerCallback);
      widget.controller.addListener(_controllerCallback);
      _selectedIndex = max(widget.controller.index, 0);
    }
  }

  void _controllerCallback() {
    if (widget.controller.index != _selectedIndex) {
      setState(() => _selectedIndex = max(widget.controller.index, 0));
    }
  }

  void _onTap(int index) {
    widget.controller.index = index;
    widget.onSelected?.call(_selectedIndex);
    widget.navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  void updatePaneWidth({
    required double availableWidth,
    required double? candidatePaneWidth,
  }) {
    final oldPaneWidth = _paneWidth;

    _paneWidth = widget.layoutDelegate.calculatePaneWidth(
      availableWidth: availableWidth,
      candidatePaneWidth: candidatePaneWidth,
    );

    if (_paneWidth != oldPaneWidth) {
      widget.onLeftPaneWidthChange?.call(_paneWidth!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);
    return _maybeBuildGlobalMouseRegion(
      LayoutBuilder(
        builder: (context, boxConstraints) {
          // Avoid left pane to overflow when resizing the window
          updatePaneWidth(
            availableWidth: boxConstraints.maxWidth,
            candidatePaneWidth: _paneWidth,
          );

          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLeftPane(theme.sideBarColor),
              if (theme.includeSeparator != false) _buildVerticalSeparator(),
              Expanded(
                child: widget.layoutDelegate.allowPaneResizing
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
    if (widget.layoutDelegate.allowPaneResizing) {
      return MouseRegion(
        cursor: _isHovering || _isDragging
            ? SystemMouseCursors.resizeColumn
            : MouseCursor.defer,
        child: child,
      );
    }

    return child;
  }

  Widget _buildLeftPane(Color? color) {
    return SizedBox(
      width: _paneWidth,
      child: YaruTitleBarTheme(
        data: const YaruTitleBarThemeData(
          style: YaruTitleBarStyle.undecorated,
        ),
        child: Scaffold(
          backgroundColor: color,
          appBar: widget.appBar,
          body: YaruMasterListView(
            length: widget.controller.length,
            selectedIndex: _selectedIndex,
            onTap: _onTap,
            builder: widget.tileBuilder,
            availableWidth: _paneWidth!,
          ),
          bottomNavigationBar: widget.bottomBar == null
              ? null
              : Material(
                  color: color,
                  child: widget.bottomBar,
                ),
        ),
      ),
    );
  }

  Widget _buildVerticalSeparator() {
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
      child: ScaffoldMessenger(
        child: Navigator(
          key: widget.navigatorKey,
          initialRoute: widget.initialRoute,
          onGenerateRoute: widget.onGenerateRoute,
          onUnknownRoute: widget.onUnknownRoute,
          pages: [
            MaterialPage(
              key: ValueKey(_selectedIndex),
              child: Builder(
                builder: (context) => widget.controller.length > _selectedIndex
                    ? widget.pageBuilder(context, _selectedIndex)
                    : widget.pageBuilder(context, 0),
              ),
            ),
          ],
          onPopPage: (route, result) => route.didPop(result),
          observers: [...widget.navigatorObservers, HeroController()],
        ),
      ),
    );
  }

  Widget _buildLeftPaneResizer(
    BuildContext context,
    BoxConstraints boxConstraints,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Positioned(
      width: _kLeftPaneResizingRegionWidth,
      top: 0,
      bottom: 0,
      left: isRtl ? null : 0,
      right: isRtl ? 0 : null,
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
              _initialPaneWidth = _paneWidth;
            }),
            onPanUpdate: (details) => setState(() {
              _paneWidthMove += isRtl ? -details.delta.dx : details.delta.dx;
              updatePaneWidth(
                availableWidth: boxConstraints.maxWidth,
                candidatePaneWidth: _initialPaneWidth! + _paneWidthMove,
              );
            }),
            onPanEnd: (details) => setState(() {
              _isDragging = false;
              _paneWidthMove = 0.0;
            }),
          ),
        ),
      ),
    );
  }
}
