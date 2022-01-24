import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruWideLayout extends StatefulWidget {
  final List<YaruPageItem> pageItems;

  const YaruWideLayout({Key? key, required this.pageItems}) : super(key: key);

  @override
  _YaruWideLayoutState createState() => _YaruWideLayoutState();
}

class _YaruWideLayoutState extends State<YaruWideLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SafeArea(
        child: Scaffold(
          body: Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          selectedIndex: _selectedIndex,
                          onDestinationSelected: (index) =>
                              setState(() => _selectedIndex = index),
                          labelType: NavigationRailLabelType.selected,
                          destinations: widget.pageItems
                              .map((pageItem) => NavigationRailDestination(
                                  icon: Icon(pageItem.iconData),
                                  selectedIcon: Icon(pageItem.selectedIconData),
                                  label: Text(pageItem.title)))
                              .toList(),
                        ),
                      )),
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Center(
                  child: widget.pageItems[_selectedIndex].builder(context),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
