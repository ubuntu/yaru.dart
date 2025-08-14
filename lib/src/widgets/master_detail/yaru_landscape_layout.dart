import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

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
    required this.paneLayoutDelegate,
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
  final YaruPanedViewLayoutDelegate paneLayoutDelegate;
  final Widget? appBar;
  final Widget? bottomBar;
  final YaruPageController controller;

  @override
  State<YaruLandscapeLayout> createState() => _YaruLandscapeLayoutState();
}

class _YaruLandscapeLayoutState extends State<YaruLandscapeLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    assert(widget.paneLayoutDelegate.paneSide.isHorizontal);
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

  @override
  Widget build(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);
    return YaruPanedView.builder(
      paneBuilder: _buildLeftPane,
      pageBuilder: _buildPage,
      layoutDelegate: widget.paneLayoutDelegate,
      includeSeparator: theme.includeSeparator ?? true,
    );
  }

  Widget _buildLeftPane(BuildContext context, double availableSpace) {
    final theme = YaruMasterDetailTheme.of(context);
    return Builder(
      builder: (context) {
        return YaruTitleBarTheme(
          data: const YaruTitleBarThemeData(
            style: YaruTitleBarStyle.undecorated,
          ),
          child: Column(
            children: [
              if (widget.appBar != null)
                SizedBox(height: kYaruTitleBarHeight, child: widget.appBar!),
              Expanded(
                child: Container(
                  color: theme.sideBarColor,
                  child: YaruMasterListView(
                    length: widget.controller.length,
                    selectedIndex: _selectedIndex,
                    onTap: _onTap,
                    builder: widget.tileBuilder,
                    availableWidth: availableSpace,
                    startUndershoot: widget.appBar != null,
                    endUndershoot: widget.bottomBar != null,
                  ),
                ),
              ),
              if (widget.bottomBar != null)
                Material(color: theme.sideBarColor, child: widget.bottomBar),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPage(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(pageTransitionsTheme: theme.landscapeTransitions),
      child: ScaffoldMessenger(
        child: Semantics(
          container: true,
          child: Navigator(
            key: widget.navigatorKey,
            initialRoute: widget.initialRoute,
            onGenerateRoute: widget.onGenerateRoute,
            onUnknownRoute: widget.onUnknownRoute,
            pages: [
              MaterialPage(
                key: ValueKey(_selectedIndex),
                child: Builder(
                  builder: (context) =>
                      widget.controller.length > _selectedIndex
                      ? widget.pageBuilder(context, _selectedIndex)
                      : widget.pageBuilder(context, 0),
                ),
              ),
            ],
            // TODO: implement replacement if we keep YaruMasterDetailPage
            // ignore: deprecated_member_use
            onPopPage: (route, result) => route.didPop(result),
            observers: [...widget.navigatorObservers, HeroController()],
          ),
        ),
      ),
    );
  }
}
