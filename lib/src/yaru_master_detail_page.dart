import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_landscape_layout.dart';
import 'package:yaru_widgets/src/yaru_page_item.dart';
import 'package:yaru_widgets/src/yaru_portrait_layout.dart';
import 'package:yaru_widgets/src/yaru_search_app_bar.dart';

class YaruMasterDetailPage extends StatefulWidget {
  /// Creates a basic responsive layout with yaru theme,
  /// renders layout based on [width] constrain.
  ///
  /// * if [constraints.maxWidth] < 620 the widget will render [YaruPotraitLayout]
  /// * if [constraints.maxWidth] > 620 widget will render [YaruLandscapeLayout]
  ///
  /// for example:
  /// ```dart
  /// YaruMasterDetailPage(
  ///       appBarHeight: 48,
  ///       leftPaneWidth: 280,
  ///       previousIconData: YaruIcons.go_previous,
  ///      pageItems: pageItems,
  ///     );
  /// ```
  const YaruMasterDetailPage({
    Key? key,
    required this.pageItems,
    this.previousIconData,
    this.searchIconData,
    required this.leftPaneWidth,
    this.searchHint,
    this.clearSearchIconData,
  }) : super(key: key);

  /// Creates horizontal array of pages.
  /// All the `children` will be of type [YaruPageItem].
  ///
  /// These List of items are passed to [YaruLandscapeLayout] and [YaruPortraitLayout].
  final List<YaruPageItem> pageItems;

  /// Specifies the width of left pane.
  final double leftPaneWidth;

  /// Property to specify the previous icon data
  final IconData? previousIconData;

  /// The icon that is given to the search widget.
  final IconData? searchIconData;

  /// Search icon for search bar.
  final IconData? clearSearchIconData;

  /// The hint text given to the search widget.
  final String? searchHint;

  @override
  _YaruMasterDetailPageState createState() => _YaruMasterDetailPageState();
}

class _YaruMasterDetailPageState extends State<YaruMasterDetailPage> {
  var _index = -1;
  var _previousIndex = 0;
  late List<YaruPageItem> _filteredItems;
  late TextEditingController _searchController;

  @override
  void initState() {
    _filteredItems = <YaruPageItem>[];
    _searchController = TextEditingController();
    super.initState();
  }

  void _setIndex(int index) {
    _previousIndex = _index;
    _index = index;
  }

  void _onEscape() => setState(() {
        _filteredItems.clear();
        _searchController.clear();
      });

  void _onSearchChanged(String value) {
    setState(() {
      _filteredItems.clear();
      _filteredItems.addAll(widget.pageItems.where((element) =>
          element.title.toLowerCase().contains(value.toLowerCase())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 620) {
          return YaruPortraitLayout(
            selectedIndex: _index,
            pageItems:
                _filteredItems.isEmpty ? widget.pageItems : _filteredItems,
            onSelected: _setIndex,
            previousIconData: widget.previousIconData,
            appBar: YaruSearchAppBar(
              searchHint: widget.searchHint,
              clearSearchIconData: widget.clearSearchIconData,
              searchController: _searchController,
              onChanged: _onSearchChanged,
              onEscape: _onEscape,
              appBarHeight:
                  Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight,
              searchIconData: widget.searchIconData,
              automaticallyImplyLeading: false,
            ),
          );
        } else {
          return YaruLandscapeLayout(
            selectedIndex: _index == -1 ? _previousIndex : _index,
            pageItems:
                _filteredItems.isEmpty ? widget.pageItems : _filteredItems,
            onSelected: _setIndex,
            leftPaneWidth: widget.leftPaneWidth,
            appBar: YaruSearchAppBar(
              searchHint: widget.searchHint,
              clearSearchIconData: widget.clearSearchIconData,
              searchController: _searchController,
              onChanged: _onSearchChanged,
              onEscape: _onEscape,
              appBarHeight:
                  Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight,
              searchIconData: widget.searchIconData,
              automaticallyImplyLeading: false,
            ),
          );
        }
      },
    );
  }
}
