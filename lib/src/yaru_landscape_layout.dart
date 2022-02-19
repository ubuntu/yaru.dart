import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_page_item_list_view.dart';

import 'yaru_page_item.dart';

class YaruLandscapeLayout extends StatefulWidget {
  /// Creates a landscape layout
  const YaruLandscapeLayout({
    Key? key,
    required this.selectedIndex,
    required this.pageItems,
    required this.onSelected,
    required this.leftPaneWidth,
    this.appBar,
  }) : super(key: key);

  /// Current index of the selected page.
  final int selectedIndex;

  /// Creates horizontal array of pages.
  /// All the `children` will be of type [YaruPageItem]
  final List<YaruPageItem> pageItems;

  /// Callback that returns an index when the page changes.
  final ValueChanged<int> onSelected;

  /// Specifies the width of left pane.
  final double leftPaneWidth;

  /// An optional [PreferredSizeWidget] used as the left [AppBar]
  /// If provided, a second [AppBar] will be created right to it.
  final PreferredSizeWidget? appBar;

  @override
  State<YaruLandscapeLayout> createState() => _YaruLandscapeLayoutState();
}

class _YaruLandscapeLayoutState extends State<YaruLandscapeLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void _onTap(int index) {
    widget.onSelected(index);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: widget.appBar != null
                ? Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight
                : 0,
            child: Row(
              children: [
                SizedBox(
                  width: widget.leftPaneWidth,
                  child: widget.appBar,
                ),
                if (widget.appBar != null)
                  Expanded(
                    child: AppBar(
                      title: widget.pageItems[
                              widget.pageItems.length > _selectedIndex
                                  ? _selectedIndex
                                  : 0]
                          .titleBuilder(context),
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
                        onTap: _onTap,
                        pages: widget.pageItems),
                  ),
                ),
                Expanded(
                    child: widget.pageItems.length > _selectedIndex
                        ? widget.pageItems[_selectedIndex].builder(context)
                        : widget.pageItems[0].builder(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
