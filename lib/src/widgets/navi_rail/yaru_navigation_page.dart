import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yaru/foundation.dart' show YaruPageController;

import 'yaru_navigation_page_theme.dart';
import 'yaru_navigation_rail.dart';

typedef YaruNavigationPageBuilder = Widget Function(
  BuildContext context,
  int index,
  bool selected,
);

const _kScrollbarThickness = 4.0;

/// A page layout which use a [YaruNavigationRail] on left for page navigation
class YaruNavigationPage extends StatefulWidget {
  const YaruNavigationPage({
    super.key,
    this.length,
    required this.itemBuilder,
    required this.pageBuilder,
    this.emptyBuilder,
    this.initialIndex,
    this.onSelected,
    this.controller,
    this.leading,
    this.trailing,
    this.navigatorKey,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
  })  : assert(initialIndex == null || controller == null),
        assert((length == null) != (controller == null));

  /// The total number of pages.
  final int? length;

  /// A builder that is called for each page to build its navigation rail item.
  ///
  /// See also:
  ///  * [YaruNavigationRailItem]
  final YaruNavigationPageBuilder itemBuilder;

  /// A builder that is called for each page to build its content.
  final IndexedWidgetBuilder pageBuilder;

  /// A builder that is called if there are no pages to display.
  final WidgetBuilder? emptyBuilder;

  /// The index of the initial page to show.
  final int? initialIndex;

  /// Called when the user selects a page.
  final ValueChanged<int>? onSelected;

  /// An optional controller that can be used to navigate to a specific index.
  final YaruPageController? controller;

  /// The leading widget in the rail that is placed above the destinations.
  final Widget? leading;

  /// The trailing widget in the rail that is placed below the destinations.
  final Widget? trailing;

  /// A key to use when building the [Navigator] widget.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// A list of observers for the [Navigator] widget.
  ///
  /// See also:
  ///  * [Navigator.observers]
  final List<NavigatorObserver> navigatorObservers;

  /// The route name for the initial route.
  ///
  /// See also:
  ///  * [Navigator.initialRoute]
  final String? initialRoute;

  /// Called to generate a route for a given [RouteSettings].
  ///
  /// See also:
  ///  * [Navigator.onGenerateRoute]
  final RouteFactory? onGenerateRoute;

  /// Called when [onGenerateRoute] fails to generate a route.
  ///
  /// See also:
  ///  * [Navigator.onUnknownRoute]
  final RouteFactory? onUnknownRoute;

  @override
  State<YaruNavigationPage> createState() => _YaruNavigationPageState();
}

class _YaruNavigationPageState extends State<YaruNavigationPage> {
  late final ScrollController _scrollController;
  late YaruPageController _pageController;
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _navigatorKey = widget.navigatorKey ?? GlobalKey<NavigatorState>();
    _updatePageController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.removeListener(_pageControllerCallback);
    if (widget.controller == null) _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant YaruNavigationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.length != oldWidget.length ||
        widget.initialIndex != oldWidget.initialIndex) {
      oldWidget.controller?.removeListener(_pageControllerCallback);
      _updatePageController();
    }
  }

  void _updatePageController() {
    _pageController = widget.controller ??
        YaruPageController(
          length: widget.length!,
          initialIndex: widget.initialIndex ?? -1,
        );
    _pageController.addListener(_pageControllerCallback);
  }

  void _pageControllerCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = YaruNavigationPageTheme.of(context);
    return Scaffold(
      backgroundColor: theme.sideBarColor,
      body: widget.length == 0 || widget.controller?.length == 0
          ? widget.emptyBuilder?.call(context) ?? const SizedBox.shrink()
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNavigationRail(context),
                if (theme.includeSeparator != false) _buildVerticalSeparator(),
                _buildPageView(context),
              ],
            ),
    );
  }

  void _onTap(int index) {
    _pageController.index = index;
    widget.onSelected?.call(index);
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  Widget _buildNavigationRail(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarTheme.of(context).copyWith(
          thickness: WidgetStateProperty.all(_kScrollbarThickness),
        ),
      ),
      child: YaruNavigationRail(
        selectedIndex: max(_pageController.index, 0),
        onDestinationSelected: _onTap,
        length: _pageController.length,
        itemBuilder: widget.itemBuilder,
        leading: widget.leading,
        trailing: widget.trailing,
      ),
    );
  }

  Widget _buildVerticalSeparator() {
    return const VerticalDivider(thickness: 1, width: 1);
  }

  Widget _buildPageView(BuildContext context) {
    final theme = YaruNavigationPageTheme.of(context);
    final index = max(_pageController.index, 0);

    return Expanded(
      child: Theme(
        data: Theme.of(context).copyWith(
          pageTransitionsTheme: theme.pageTransitions,
        ),
        child: Navigator(
          key: _navigatorKey,
          pages: [
            MaterialPage(
              key: ValueKey(index),
              child: _pageController.length > index
                  ? widget.pageBuilder(context, index)
                  : widget.pageBuilder(context, 0),
            ),
          ],
          initialRoute: widget.initialRoute,
          onGenerateRoute: widget.onGenerateRoute,
          onUnknownRoute: widget.onUnknownRoute,
          // TODO: implement replacement if we keep YaruMasterDetailPage
          // ignore: deprecated_member_use
          onPopPage: (route, result) => route.didPop(result),
          observers: [...widget.navigatorObservers, HeroController()],
        ),
      ),
    );
  }
}
