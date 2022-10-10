import 'package:flutter/material.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_page_item_list_view.dart';

class YaruLandscapeLayout extends StatefulWidget {
  /// Creates a landscape layout
  const YaruLandscapeLayout({
    super.key,
    required this.length,
    required this.selectedIndex,
    required this.tileBuilder,
    required this.titleBuilder,
    required this.pageBuilder,
    required this.onSelected,
    required this.leftPaneWidth,
    this.appBar,
  });

  /// The total number of pages.
  final int length;

  /// Current index of the selected page.
  final int selectedIndex;

  /// A builder that is called for each page to build its master tile.
  final YaruMasterDetailBuilder tileBuilder;

  /// A builder that is called for each page to build its title.
  final YaruMasterDetailBuilder titleBuilder;

  /// A builder that is called for each page to build its detail page.
  final IndexedWidgetBuilder pageBuilder;

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
    final theme = YaruMasterDetailTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: widget.leftPaneWidth,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          child: Scaffold(
            appBar: widget.appBar,
            body: YaruPageItemListView(
              length: widget.length,
              selectedIndex: _selectedIndex,
              onTap: _onTap,
              builder: widget.tileBuilder,
            ),
          ),
        ),
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
              pageTransitionsTheme: theme.landscapeTransitions,
            ),
            child: Navigator(
              pages: [
                MaterialPage(
                  key: ValueKey(_selectedIndex),
                  child: widget.length > _selectedIndex
                      ? widget.pageBuilder(context, _selectedIndex)
                      : widget.pageBuilder(context, 0),
                ),
              ],
              onPopPage: (route, result) => route.didPop(result),
              observers: [HeroController()],
            ),
          ),
        ),
      ],
    );
  }
}
