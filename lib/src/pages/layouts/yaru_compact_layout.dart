import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../../../yaru_widgets.dart';

typedef YaruCompactLayoutBuilder = Widget Function(
  BuildContext context,
  int index,
  bool selected,
);

/// A page layout which use a [YaruNavigationRail] on left for page navigation
class YaruCompactLayout extends StatefulWidget {
  const YaruCompactLayout({
    super.key,
    required this.length,
    required this.iconBuilder,
    required this.titleBuilder,
    required this.pageBuilder,
    this.style = YaruNavigationRailStyle.compact,
    this.initialIndex = 0,
    this.onSelected,
  });

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its icon.
  final YaruCompactLayoutBuilder iconBuilder;

  /// A builder that is called for each page to build its title.
  final YaruCompactLayoutBuilder titleBuilder;

  /// A builder that is called for each page to build its content.
  final IndexedWidgetBuilder pageBuilder;

  /// Define the navigation rail style, see [YaruNavigationRailStyle]
  final YaruNavigationRailStyle style;

  /// The index of the [YaruPageItem] that is selected from [pageItems]
  final int initialIndex;

  /// Called when the user selects a page.
  final ValueChanged<int>? onSelected;

  @override
  State<YaruCompactLayout> createState() => _YaruCompactLayoutState();
}

class _YaruCompactLayoutState extends State<YaruCompactLayout> {
  late int _index;

  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _index = widget.initialIndex;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Widget _buildNavigationRail(BuildContext context, BoxConstraints constraint) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        controller: _controller,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: YaruNavigationRail(
            style: widget.style,
            selectedIndex: _index,
            onDestinationSelected: (index) {
              setState(() {
                _index = index;
                widget.onSelected?.call(index);
              });
            },
            length: widget.length,
            iconBuilder: widget.iconBuilder,
            titleBuilder: widget.titleBuilder,
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalSeparator() {
    return const VerticalDivider(thickness: 1, width: 1);
  }

  Widget _buildPageView(BuildContext context) {
    return Expanded(
      child: Theme(
        data: Theme.of(context).copyWith(
          pageTransitionsTheme: YaruPageTransitionsTheme.vertical,
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
