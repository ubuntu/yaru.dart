import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_page_item_list_view.dart';

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

  void _onTap(int index) {
    widget.onSelected(index);
    _navigator.push(pageRoute(index));
    setState(() => _selectedIndex = index);
  }

  void _goBack() {
    widget.onSelected(-1);
    _navigator.pop(context);
  }

  MaterialPageRoute pageRoute(int index) {
    final width = MediaQuery.of(context).size.width;
    return MaterialPageRoute(
      builder: (context) {
        final page = widget.pageItems[_selectedIndex];
        return Scaffold(
          appBar: widget.appBar != null
              ? AppBar(
                  title: page.titleBuilder(context),
                  leading: InkWell(
                    child:
                        Icon(widget.previousIconData ?? Icons.navigate_before),
                    onTap: _goBack,
                  ),
                )
              : null,
          body: SizedBox(width: width, child: page.builder(context)),
          floatingActionButton: widget.appBar == null
              ? FloatingActionButton(
                  child: Icon(widget.previousIconData),
                  onPressed: _goBack,
                )
              : null,
          floatingActionButtonLocation: widget.appBar == null
              ? FloatingActionButtonLocation.miniStartFloat
              : null,
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
                  appBar: widget.appBar,
                  body: YaruPageItemListView(
                      selectedIndex: _selectedIndex,
                      onTap: _onTap,
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
