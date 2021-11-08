import 'package:flutter/material.dart';
import 'package:yaru_widgets/widgets/page_item_list_view.dart';
import 'package:yaru_widgets/widgets/search_app_bar.dart';
import 'page_item.dart';

class LandscapeLayout extends StatefulWidget {
  const LandscapeLayout({
    Key? key,
    required this.selectedIndex,
    required this.pages,
    required this.onSelected,
    required this.appBarHeight,
    required this.leftPaneWidth,
    required this.searchIconData,
    required this.searchHint,
  }) : super(key: key);

  final int selectedIndex;
  final List<PageItem> pages;
  final ValueChanged<int> onSelected;
  final double appBarHeight;
  final double leftPaneWidth;
  final IconData searchIconData;
  final String searchHint;

  @override
  State<LandscapeLayout> createState() => _LandscapeLayoutState();
}

class _LandscapeLayoutState extends State<LandscapeLayout> {
  late int _selectedIndex;
  late ScrollController _contentScrollController;
  late TextEditingController _searchController;
  final _filteredItems = <PageItem>[];

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _contentScrollController = ScrollController();
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
                    title: Text(widget.pages[_selectedIndex].title,
                        style: const TextStyle(fontWeight: FontWeight.normal)),
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
                    child: PageItemListView(
                      selectedIndex: _selectedIndex,
                      onTap: onTap,
                      pages: _filteredItems.isEmpty
                          ? widget.pages
                          : _filteredItems,
                    ),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  controller: _contentScrollController,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: widget.pages[_selectedIndex].builder(context),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
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
