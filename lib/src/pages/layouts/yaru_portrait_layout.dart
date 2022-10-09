import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_page_item_list_view.dart';

class YaruPortraitLayout extends StatefulWidget {
  const YaruPortraitLayout({
    super.key,
    required this.length,
    required this.selectedIndex,
    required this.iconBuilder,
    required this.titleBuilder,
    required this.pageBuilder,
    required this.onSelected,
    this.previousIconData,
    this.appBar,
  });

  final int length;
  final int selectedIndex;
  final YaruMasterDetailBuilder iconBuilder;
  final YaruMasterDetailBuilder titleBuilder;
  final IndexedWidgetBuilder pageBuilder;
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
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: widget.appBar != null
              ? AppBar(
                  title: widget.titleBuilder(context, index, false),
                  leading: InkWell(
                    child:
                        Icon(widget.previousIconData ?? Icons.navigate_before),
                    onTap: _goBack,
                  ),
                )
              : null,
          body: SizedBox.expand(child: widget.pageBuilder(context, index)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigator.maybePop(),
      child: Theme(
        data: Theme.of(context).copyWith(
          pageTransitionsTheme: YaruPageTransitionsTheme.horizontal,
        ),
        child: Navigator(
          key: _navigatorKey,
          onGenerateInitialRoutes: (navigator, initialRoute) {
            return [
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: widget.appBar,
                    body: YaruPageItemListView(
                      length: widget.length,
                      selectedIndex: _selectedIndex,
                      onTap: _onTap,
                      iconBuilder: widget.iconBuilder,
                      titleBuilder: widget.titleBuilder,
                    ),
                  );
                },
              ),
              if (_selectedIndex != -1) pageRoute(_selectedIndex)
            ];
          },
        ),
      ),
    );
  }
}
