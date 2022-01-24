import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruNarrowLayout extends StatefulWidget {
  final List<YaruPageItem> pageItems;

  const YaruNarrowLayout({Key? key, required this.pageItems}) : super(key: key);

  @override
  _YaruNarrowLayoutState createState() => _YaruNarrowLayoutState();
}

class _YaruNarrowLayoutState extends State<YaruNarrowLayout> {
  late int _selectedIndex;
  @override
  void initState() {
    _selectedIndex = 0;
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
            items: widget.pageItems
                .map((pageItem) => BottomNavigationBarItem(
                    icon: Icon(pageItem.iconData),
                    activeIcon: Icon(pageItem.selectedIconData),
                    label: pageItem.title))
                .toList(),
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
          ),
        ],
      )),
    );
  }
}
