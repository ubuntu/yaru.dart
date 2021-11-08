import 'package:flutter/material.dart';
import 'package:yaru_widgets/widgets/page_item_list_view.dart';
import 'package:yaru_widgets/widgets/search_app_bar.dart';

import 'page_item.dart';

class PortraitLayout extends StatefulWidget {
  const PortraitLayout(
      {Key? key,
      required this.selectedIndex,
      required this.pages,
      required this.onSelected,
      required this.previousIconData,
      required this.appBarHeight,
      required this.searchIconData,
      required this.searchHint})
      : super(key: key);

  final int selectedIndex;
  final List<PageItem> pages;
  final ValueChanged<int> onSelected;
  final IconData previousIconData;
  final double appBarHeight;
  final IconData searchIconData;
  final String searchHint;

  @override
  _PortraitLayoutState createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends State<PortraitLayout> {
  late int _selectedIndex;
  late TextEditingController _searchController;
  final _filteredItems = <PageItem>[];
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
    return MaterialPageRoute(
      builder: (context) {
        final page = widget.pages[_selectedIndex];
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: widget.appBarHeight,
            title: Text(page.title),
            leading: InkWell(
              child: Icon(widget.previousIconData),
              onTap: () {
                widget.onSelected(-1);
                _navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: page.builder(context),
              ),
            ),
          ),
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
                  body: PageItemListView(
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

  SearchAppBar addSearchBar() {
    return SearchAppBar(
      searchHint: widget.searchHint,
      searchController: _searchController,
      onChanged: (value) {
        setState(() {
          _filteredItems.clear();
          for (PageItem pageItem in widget.pages) {
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
      appBarHeight: widget.appBarHeight,
      searchIconData: widget.searchIconData,
    );
  }
}
