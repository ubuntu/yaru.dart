import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

/// Creates a [BottomNavigationBar] wrapped inside [Column]
/// together with a [Widget] created by the [WidgetBuilder] of the selected [YaruPageItem].
///
class YaruNarrowLayout extends StatefulWidget {
  /// The list of [YaruPageItem] which is used to create the views.
  final List<YaruPageItem> pageItems;

  /// The index of the item that should be selected when the [State] of [YaruNarrowLayout] is initialized.
  final int initialIndex;

  /// Optional callback that returns an index when the page changes.
  final ValueChanged<int>? onSelected;

  /// Optional bool to hide selected labels in the [BottomNavigationBar]
  final bool? showSelectedLabels;

  /// Optional bool to hide unselected labels in the [BottomNavigationBar]
  final bool? showUnselectedLabels;

  /// Optionally control the click behavior of the [BottomNavigationBar]
  final BottomNavigationBarType bottomNavigationBarType;

  const YaruNarrowLayout({
    Key? key,
    required this.pageItems,
    required this.initialIndex,
    required this.onSelected,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.bottomNavigationBarType = BottomNavigationBarType.fixed,
  }) : super(key: key);

  @override
  _YaruNarrowLayoutState createState() => _YaruNarrowLayoutState();
}

class _YaruNarrowLayoutState extends State<YaruNarrowLayout> {
  late int _selectedIndex;
  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: widget.pageItems[_selectedIndex].builder(context),
          ),
          BottomNavigationBar(
            type: widget.bottomNavigationBarType,
            showSelectedLabels: widget.showSelectedLabels,
            showUnselectedLabels: widget.showUnselectedLabels,
            items: widget.pageItems
                .map(
                  (pageItem) => BottomNavigationBarItem(
                      icon: pageItem.itemWidget ?? Icon(pageItem.iconData),
                      activeIcon: pageItem.selectedItemWidget ??
                          pageItem.itemWidget ??
                          (pageItem.selectedIconData != null
                              ? Icon(pageItem.selectedIconData)
                              : Icon(pageItem.iconData)),
                      label: convertWidgetToString(
                          pageItem.titleBuilder(context))),
                )
                .toList(),
            currentIndex: _selectedIndex,
            onTap: (index) {
              widget.onSelected!(index);
              setState(() => _selectedIndex = index);
            },
          ),
        ],
      )),
    );
  }

  String convertWidgetToString(Widget widget) {
    return widget is Text && widget.data != null ? widget.data! : '';
  }
}
