import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_page_item_list_view.dart';
import 'package:yaru_widgets/src/yaru_search_app_bar.dart';
import 'yaru_page_item.dart';

class YaruLandscapeLayout extends StatefulWidget {
  // Creates a landscape layout
  const YaruLandscapeLayout({
    Key? key,
    required this.selectedIndex,
    required this.pages,
    required this.onSelected,
    this.appBarHeight,
    required this.leftPaneWidth,
    this.searchIconData,
    this.searchHint,
  }) : super(key: key);

  // Current index of the selected page.
  final int selectedIndex;

  // Creates horizontal array of pages.
  // All the `children` will be of type [YaruPageItem]
  final List<YaruPageItem> pages;

  // Callback that returns an index when the page changes.
  final ValueChanged<int> onSelected;

  // Specifies the [AppBar] height.
  final double? appBarHeight;

  // Specifies the width of left pane.
  final double leftPaneWidth;

  // The icon that is given to the search widget.
  final IconData? searchIconData;

  // The hint text given to the search widget.
  final String? searchHint;

  @override
  State<YaruLandscapeLayout> createState() => _YaruLandscapeLayoutState();
}

class _YaruLandscapeLayoutState extends State<YaruLandscapeLayout> {
  late int _selectedIndex;
  late TextEditingController _searchController;
  final _filteredItems = <YaruPageItem>[];

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _searchController = TextEditingController();
    super.initState();
  }

  void onTap(int index) {
    if (_filteredItems.isNotEmpty) {
      index = widget.pages.indexOf(widget.pages.firstWhere(
          (pageItem) => pageItem.title == _filteredItems[index].title));
    }

    widget.onSelected(index);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: widget.appBarHeight,
            child: Row(
              children: [
                SizedBox(
                  width: widget.leftPaneWidth,
                  child: addSearchBar(),
                ),
                Expanded(
                  child: AppBar(
                    title: Text(widget.pages[_selectedIndex].title),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: widget.leftPaneWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 1,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: YaruPageItemListView(
                      selectedIndex: _selectedIndex,
                      onTap: onTap,
                      pages: _filteredItems.isEmpty
                          ? widget.pages
                          : _filteredItems,
                    ),
                  ),
                ),
                Expanded(child: widget.pages[_selectedIndex].builder(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  YaruSearchAppBar addSearchBar() {
    return YaruSearchAppBar(
      automaticallyImplyLeading: false,
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
      appBarHeight: widget.appBarHeight ?? kToolbarHeight,
      searchIconData: widget.searchIconData,
    );
  }
}
