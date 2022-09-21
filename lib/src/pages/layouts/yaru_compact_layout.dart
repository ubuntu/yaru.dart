import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

/// A responsive layout switching between [YaruWideLayout]
/// and [YaruNarrowLayout] depening on the screen width.
class YaruCompactLayout extends StatefulWidget {
  const YaruCompactLayout({
    Key? key,
    required this.pageItems,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.labelType = NavigationRailLabelType.none,
    this.extendNavigationRail = false,
    this.initialIndex = 0,
    this.backgroundColor,
  }) : super(key: key);

  /// The list of [YaruPageItem] has to be provided.
  final List<YaruPageItem> pageItems;

  /// Optional bool to hide selected labels in the [BottomNavigationBar]
  final bool showSelectedLabels;

  /// Optional bool to hide unselected labels in the [BottomNavigationBar]
  final bool showUnselectedLabels;

  /// Optionally control the labels of the [NavigationRail]
  final NavigationRailLabelType labelType;

  /// Defines if the labels are shown right to the icon
  /// of the [NavigationRail] in the wide layout
  final bool extendNavigationRail;

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
    final unselectedTextColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.8);
    final selectedTextColor = Theme.of(context).colorScheme.onSurface;
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
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          extended:
                              widget.labelType == NavigationRailLabelType.none
                                  ? widget.extendNavigationRail
                                  : false,
                          unselectedIconTheme: IconThemeData(
                            color: unselectedTextColor,
                          ),
                          indicatorColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                          selectedIconTheme: IconThemeData(
                            color: selectedTextColor,
                          ),
                          selectedLabelTextStyle: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: selectedTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelTextStyle: TextStyle(
                            color: unselectedTextColor,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          backgroundColor: widget.backgroundColor ??
                              Theme.of(context).colorScheme.background,
                          selectedIndex: _index,
                          onDestinationSelected: (index) {
                            setState(() => _index = index);
                          },
                          labelType: widget.labelType,
                          destinations: widget.pageItems
                              .map(
                                (pageItem) => NavigationRailDestination(
                                  icon: pageItem.itemWidget ??
                                      Icon(pageItem.iconData),
                                  selectedIcon: pageItem.selectedItemWidget ??
                                      pageItem.itemWidget ??
                                      (pageItem.selectedIconData != null
                                          ? Icon(pageItem.selectedIconData)
                                          : Icon(pageItem.iconData)),
                                  label: pageItem.titleBuilder(context),
                                ),
                              )
                              .toList(),
                        ),
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
