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

  final ValueChanged<int> onSelected;

  final bool? showSelectedLabels;

  const YaruNarrowLayout({
    Key? key,
    required this.pageItems,
    required this.initialIndex,
    required this.onSelected,
    this.showSelectedLabels = true,
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
        children: <Widget>[
          Expanded(
            child: Center(
              child: widget.pageItems[_selectedIndex].builder(context),
            ),
          ),
          BottomNavigationBar(
            showSelectedLabels: widget.showSelectedLabels,
            items: widget.pageItems
                .map((pageItem) => BottomNavigationBarItem(
                    icon: Icon(pageItem.iconData),
                    activeIcon: pageItem.selectedIconData != null
                        ? Icon(pageItem.selectedIconData)
                        : Icon(pageItem.iconData),
                    label:
                        convertWidgetToString(pageItem.titleBuilder(context))))
                .toList(),
            currentIndex: _selectedIndex,
            onTap: (index) {
              widget.onSelected(index);
              setState(() => _selectedIndex = index);
            },
          ),
        ],
      )),
    );
  }

  String convertWidgetToString(Widget widget) {
    return widget is Text
        ? widget
            .toString()
            .replaceAll('Text(', '')
            .replaceAll(')', '')
            .replaceAll('"', '')
            .replaceAll("'", '')
        : '';
  }
}
