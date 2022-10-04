import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../../../yaru_widgets.dart';

/// A responsive layout switching between [YaruWideLayout]
/// and [YaruNarrowLayout] depening on the screen width.
class YaruCompactLayout extends StatefulWidget {
  const YaruCompactLayout({
    super.key,
    required this.pageItems,
    this.showLabels = false,
    this.extended = false,
    this.initialIndex = 0,
    this.backgroundColor,
  });

  /// The list of [YaruPageItem] has to be provided.
  final List<YaruPageItem> pageItems;

  /// Optionally control the labels of the [NavigationRail]
  final bool showLabels;

  /// Defines if the labels are shown right to the icon
  /// of the [NavigationRail] in the wide layout
  final bool extended;

  /// The index of the [YaruPageItem] that is selected from [pageItems]
  final int initialIndex;

  final Color? backgroundColor;

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
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: YaruNavigationRail(
                        extended: widget.extended,
                        showLabels: widget.showLabels,
                        selectedIndex: _index,
                        onDestinationSelected: (index) {
                          if (widget.pageItems[index].onTap != null) {
                            widget.pageItems[index].onTap!.call(context);
                          }
                          setState(() {
                            _index = index;
                          });
                        },
                        destinations: widget.pageItems,
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
