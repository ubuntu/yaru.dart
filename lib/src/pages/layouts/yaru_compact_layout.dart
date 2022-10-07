import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../../../yaru_widgets.dart';

/// A page layout which use a [YaruNavigationRail] on left for page navigation
class YaruCompactLayout extends StatefulWidget {
  const YaruCompactLayout({
    super.key,
    required this.pageItems,
    this.style = YaruNavigationRailStyle.compact,
    this.initialIndex = 0,
    this.onSelected,
  });

  /// A list of page destinations
  final List<YaruPageItem> pageItems;

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
              if (widget.pageItems[index].onTap != null) {
                widget.pageItems[index].onTap!.call(context);
              }
              setState(() {
                _index = index;
                widget.onSelected?.call(index);
              });
            },
            destinations: widget.pageItems,
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
              child: widget.pageItems.length > _index
                  ? widget.pageItems[_index].builder(context)
                  : widget.pageItems[0].builder(context),
            ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        ),
      ),
    );
  }
}
