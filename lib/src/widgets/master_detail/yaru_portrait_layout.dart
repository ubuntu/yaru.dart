import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/foundation.dart' show YaruPageController;
import 'package:yaru/widgets.dart'
    show YaruTitleBarTheme, YaruTitleBarThemeData, YaruTitleBarStyle;

import 'yaru_master_detail_page.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_master_list_view.dart';

class YaruPortraitLayout extends StatefulWidget {
  const YaruPortraitLayout({
    super.key,
    required this.navigatorKey,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    required this.tileBuilder,
    required this.pageBuilder,
    this.onSelected,
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

  final PreferredSizeWidget? appBar;
  final Widget? bottomBar;

  final YaruPageController controller;

  @override
  State<YaruPortraitLayout> createState() => _YaruPortraitLayoutState();
}

class _YaruPortraitLayoutState extends State<YaruPortraitLayout> {
  late int _selectedIndex;

  NavigatorState get _navigator => widget.navigatorKey.currentState!;

  @override
  void initState() {
    widget.controller.addListener(_controllerCallback);
    _selectedIndex = widget.controller.index;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerCallback);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant YaruPortraitLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_controllerCallback);
      widget.controller.addListener(_controllerCallback);
      _selectedIndex = widget.controller.index;
    }
  }

  void _controllerCallback() {
    if (widget.controller.index != _selectedIndex) {
      setState(() => _selectedIndex = widget.controller.index);
    }
  }

  void _onTap(int index) {
    widget.controller.index = index;
    widget.onSelected?.call(_selectedIndex);
  }

  MaterialPage page(int index) {
    return MaterialPage(
      key: ValueKey(index),
      child: Builder(
        builder: (context) => widget.pageBuilder(context, _selectedIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);
    return PopScope(
      // TODO: implement replacement if we keep YaruMasterDetailPage
      // ignore: deprecated_member_use
      onPopInvoked: (v) async => await _navigator.maybePop(),
      child: Theme(
        data: Theme.of(context).copyWith(
          pageTransitionsTheme: theme.portraitTransitions,
        ),
        child: Navigator(
          key: widget.navigatorKey,
          initialRoute: widget.initialRoute,
          onGenerateRoute: widget.onGenerateRoute,
          onUnknownRoute: widget.onUnknownRoute,
          // TODO: implement replacement if we keep YaruMasterDetailPage
          // ignore: deprecated_member_use
          onPopPage: (route, result) {
            _selectedIndex = -1;
            return route.didPop(result);
          },
          pages: [
            MaterialPage(
              key: const ValueKey(-1),
              child: YaruTitleBarTheme(
                data: const YaruTitleBarThemeData(
                  style: kIsWeb
                      ? YaruTitleBarStyle.undecorated
                      : YaruTitleBarStyle.normal,
                ),
                child: Scaffold(
                  backgroundColor: theme.sideBarColor,
                  appBar: widget.appBar,
                  body: LayoutBuilder(
                    builder: (context, constraints) => YaruMasterListView(
                      length: widget.controller.length,
                      selectedIndex: _selectedIndex,
                      onTap: _onTap,
                      builder: widget.tileBuilder,
                      availableWidth: constraints.maxWidth,
                      startUndershoot: widget.appBar != null,
                      endUndershoot: widget.bottomBar != null,
                    ),
                  ),
                  bottomNavigationBar: widget.bottomBar == null
                      ? null
                      : Material(
                          color: theme.sideBarColor,
                          child: widget.bottomBar,
                        ),
                ),
              ),
            ),
            if (_selectedIndex != -1) page(_selectedIndex),
          ],
          observers: [...widget.navigatorObservers, HeroController()],
        ),
      ),
    );
  }
}
