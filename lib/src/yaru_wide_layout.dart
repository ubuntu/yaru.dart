import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

/// Creates a [NavigationRail] wrapped inside [Row]
/// together with a [Widget] created by the [WidgetBuilder] of the selected [YaruPageItem].
///
class YaruWideLayout extends StatefulWidget {
  /// The list of [YaruPageItem] which is used to create the views.
  final List<YaruPageItem> pageItems;

  /// The index of the item that should be selected when the [State] of [YaruNarrowLayout] is initialized.
  final int initialIndex;

  const YaruWideLayout(
      {Key? key, required this.pageItems, required this.initialIndex})
      : super(key: key);

  @override
  _YaruWideLayoutState createState() => _YaruWideLayoutState();
}

class _YaruWideLayoutState extends State<YaruWideLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
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
