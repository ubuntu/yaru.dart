import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_page_item_list_view.dart';
import 'package:yaru_widgets/src/yaru_search_app_bar.dart';

import 'yaru_page_item.dart';

class YaruPortraitLayout extends StatefulWidget {
  const YaruPortraitLayout(
      {Key? key,
      required this.selectedIndex,
      required this.pages,
      required this.onSelected,
      this.previousIconData,
      this.appBarHeight,
      this.searchIconData,
      this.searchHint})
      : super(key: key);

  final int selectedIndex;
  final List<YaruPageItem> pages;
  final ValueChanged<int> onSelected;
  final IconData? previousIconData;
  final double? appBarHeight;
  final IconData? searchIconData;
  final String? searchHint;

  @override
  _YaruPortraitLayoutState createState() => _YaruPortraitLayoutState();
}

class _YaruPortraitLayoutState extends State<YaruPortraitLayout> {
  late int _selectedIndex;
  late TextEditingController _searchController;
  final _filteredItems = <YaruPageItem>[];
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    _searchController = TextEditingController();
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void onTap(int index) {
    if (_filteredItems.isNotEmpty) {
      index = widget.pages.indexOf(widget.pages.firstWhere(
          (pageItem) => pageItem.title == _filteredItems[index].title));
    }

    _navigator.push(pageRoute(index));
    widget.onSelected(index);
    setState(() => _selectedIndex = index);
    _searchController.clear();
    _filteredItems.clear();
  }

  MaterialPageRoute pageRoute(int index) {
    final width = MediaQuery.of(context).size.width;
    return MaterialPageRoute(
      builder: (context) {
        final page = widget.pages[_selectedIndex];
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
                  appBar: addSearchBar(),
                  body: YaruPageItemListView(
                    selectedIndex: _selectedIndex,
                    onTap: onTap,
                    pages:
                        _filteredItems.isEmpty ? widget.pages : _filteredItems,
                  ),
                );
              },
            ),
            if (_selectedIndex != -1) pageRoute(_selectedIndex)
          ];
        },
      ),
    );
  }

  YaruSearchAppBar addSearchBar() {
    return YaruSearchAppBar(
      searchHint: widget.searchHint,
      searchController: _searchController,
      onChanged: (value) {
        setState(() {
          _filteredItems.clear();
          for (YaruPageItem pageItem in widget.pages) {
            if (pageItem.title
                .toLowerCase()
                .contains(_searchController.value.text.toLowerCase())) {
              _filteredItems.add(pageItem);
            }
          }
        });
      },
      onEscape: () => setState(() {
        _searchController.clear();
        _filteredItems.clear();
      }),
      appBarHeight:
          Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight,
      searchIconData: widget.searchIconData,
      automaticallyImplyLeading: false,
    );
  }
}
