import 'package:flutter/material.dart';

import 'yaru_master_detail_page.dart';
import 'yaru_master_detail_theme.dart';
import 'yaru_master_list_view.dart';

class YaruPortraitLayout extends StatefulWidget {
  const YaruPortraitLayout({
    super.key,
    required this.length,
    required this.selectedIndex,
    required this.tileBuilder,
    required this.pageBuilder,
    required this.onSelected,
    this.appBar,
  });

  final int length;
  final int selectedIndex;
  final YaruMasterDetailBuilder tileBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final ValueChanged<int> onSelected;

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

  MaterialPageRoute pageRoute(int index) {
    return MaterialPageRoute(
      builder: (context) => widget.pageBuilder(context, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = YaruMasterDetailTheme.of(context);
    return WillPopScope(
      onWillPop: () async => !await _navigator.maybePop(),
      child: Theme(
        data: Theme.of(context).copyWith(
          pageTransitionsTheme: theme.portraitTransitions,
        ),
        child: Navigator(
          key: _navigatorKey,
          onGenerateInitialRoutes: (navigator, initialRoute) {
            return [
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: widget.appBar,
                    body: YaruMasterListView(
                      length: widget.length,
                      selectedIndex: _selectedIndex,
                      onTap: _onTap,
                      builder: widget.tileBuilder,
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
