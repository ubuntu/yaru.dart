import 'dart:math';

import 'package:flutter/material.dart';

import 'yaru_compact_layout_theme.dart';
import 'yaru_navigation_rail.dart';
import 'yaru_page_controller.dart';

typedef YaruCompactLayoutBuilder = Widget Function(
  BuildContext context,
  int index,
  bool selected,
);

const _kScrollbarThickness = 4.0;

/// A page layout which use a [YaruNavigationRail] on left for page navigation
class YaruCompactLayout extends StatefulWidget {
  const YaruCompactLayout({
    super.key,
    required this.length,
    required this.itemBuilder,
    required this.pageBuilder,
    this.onSelected,
    this.controller,
  });

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its navigation rail item.
  ///
  /// See also:
  ///  * [YaruNavigationRailItem]
  final YaruCompactLayoutBuilder itemBuilder;

  /// A builder that is called for each page to build its content.
  final IndexedWidgetBuilder pageBuilder;

  /// Called when the user selects a page.
  final ValueChanged<int>? onSelected;

  /// An optional controller that can be used to navigate to a specific index.
  final YaruPageController? controller;

  @override
  State<YaruCompactLayout> createState() => _YaruCompactLayoutState();
}

class _YaruCompactLayoutState extends State<YaruCompactLayout> {
  late int _index;

  late final ScrollController _scrollController;
  late final YaruPageController _pageController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _updatePageController();
    _index = max(_pageController.initialIndex, 0);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.removeListener(_pageControllerCallback);
    if (widget.controller == null) _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant YaruCompactLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) _updatePageController();
  }

  void _updatePageController() {
    _pageController =
        widget.controller ?? YaruPageController(length: widget.length);
    _pageController.addListener(_pageControllerCallback);
  }

  void _pageControllerCallback() {
    if (_pageController.index != _index) {
      setState(() => _index = _pageController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SafeArea(
          child: Scaffold(
            body: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNavigationRail(context, constraint),
                _buildVerticalSeparator(),
                _buildPageView(context),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTap(int index) {
    _pageController.index = index;
    widget.onSelected?.call(index);
  }

  Widget _buildNavigationRail(BuildContext context, BoxConstraints constraint) {
    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarTheme.of(context).copyWith(
          thickness: MaterialStateProperty.all(_kScrollbarThickness),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: YaruNavigationRail(
            selectedIndex: _index,
            onDestinationSelected: _onTap,
            length: widget.length,
            itemBuilder: widget.itemBuilder,
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalSeparator() {
    return const VerticalDivider(thickness: 1, width: 1);
  }

  Widget _buildPageView(BuildContext context) {
    final theme = YaruCompactLayoutTheme.of(context);
    return Expanded(
      child: Theme(
        data: Theme.of(context).copyWith(
          pageTransitionsTheme: theme.pageTransitions,
        ),
        child: Navigator(
          pages: [
            MaterialPage(
              key: ValueKey(_index),
              child: widget.length > _index
                  ? widget.pageBuilder(context, _index)
                  : widget.pageBuilder(context, 0),
            ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        ),
      ),
    );
  }
}
