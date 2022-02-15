import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_page_item_list_view.dart';
import 'package:yaru_widgets/src/yaru_search_app_bar.dart';

import 'yaru_page_item.dart';

class YaruPortraitLayout extends StatefulWidget {
  const YaruPortraitLayout({
    Key? key,
    required this.selectedIndex,
    required this.pageItems,
    required this.onSelected,
    this.previousIconData,
    this.appBar,
  }) : super(key: key);

  final int selectedIndex;
  final List<YaruPageItem> pageItems;
  final ValueChanged<int> onSelected;
  final IconData? previousIconData;

  final PreferredSizeWidget? appBar;

  @override
  _YaruPortraitLayoutState createState() => _YaruPortraitLayoutState();
}

class _YaruPortraitLayoutState extends State<YaruPortraitLayout> {
  late int _selectedIndex;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void onTap(int index) {
    widget.onSelected(index);
    _navigator.push(pageRoute(index));
    setState(() => _selectedIndex = index);
  }

  MaterialPageRoute pageRoute(int index) {
    final width = MediaQuery.of(context).size.width;
    return MaterialPageRoute(
      builder: (context) {
        final page = widget.pageItems[_selectedIndex];
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight,
            title: Text(page.title),
            leading: InkWell(
              child: Icon(widget.previousIconData ?? Icons.navigate_before),
              onTap: () {
                widget.onSelected(-1);
                _navigator.pop(context);
              },
            ),
          ),
          body: SizedBox(width: width, child: page.builder(context)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigator.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: widget.appBar ?? AppBar(),
                  body: YaruPageItemListView(
                      selectedIndex: _selectedIndex,
                      onTap: onTap,
                      pages: widget.pageItems),
                );
              },
            ),
            if (_selectedIndex != -1) pageRoute(_selectedIndex)
          ];
        },
      ),
    );
  }
}
