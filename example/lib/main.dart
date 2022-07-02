import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/example_page_items.dart';
import 'package:yaru_widgets_example/theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LightTheme(yaruLight)),
      ChangeNotifierProvider(create: (_) => DarkTheme(yaruDark)),
    ],
    child: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _filteredItems = <YaruPageItem>[];
  final _searchController = TextEditingController();
  bool _compactMode = false;
  int _amount = 3;

  void _onEscape() => setState(() {
        _filteredItems.clear();
        _searchController.clear();
      });

  void _onSearchChanged(String value, BuildContext context) {
    setState(() {
      _filteredItems.clear();
      _filteredItems.addAll(examplePageItems.where((pageItem) =>
          pageItem.searchMatches != null &&
          pageItem.searchMatches!(value, context)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final configItem = YaruPageItem(
      titleBuilder: (context) => Text('Layout'),
      builder: (_) => YaruPage(children: [
        YaruSwitchRow(
          trailingWidget: Text('Compact mode'),
          value: _compactMode,
          onChanged: (v) => setState(() => _compactMode = v),
        ),
        if (_compactMode)
          YaruRow(
            trailingWidget: Text('YaruPageItem amount'),
            actionWidget: Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (_amount >= examplePageItems.length) return;
                    setState(() => _amount++);
                  },
                  child: Icon(YaruIcons.plus),
                ),
                TextButton(
                  onPressed: () {
                    if (_amount <= 2) return;
                    setState(() => _amount--);
                  },
                  child: Icon(YaruIcons.minus),
                ),
              ],
            ),
            enabled: true,
          )
      ]),
      iconData: YaruIcons.settings,
    );

    return MaterialApp(
      title: 'Yaru Widgets Factory',
      scrollBehavior: TouchMouseStylusScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: context.watch<LightTheme>().value,
      darkTheme: context.watch<DarkTheme>().value,
      home: _compactMode
          ? YaruCompactLayout(
              pageItems: [configItem] + examplePageItems.take(_amount).toList(),
            )
          : YaruMasterDetailPage(
              leftPaneWidth: 280,
              previousIconData: YaruIcons.go_previous,
              pageItems: _filteredItems.isNotEmpty
                  ? _filteredItems
                  : [configItem] + examplePageItems,
              appBar: YaruSearchAppBar(
                searchHint: 'Search...',
                clearSearchIconData: YaruIcons.window_close,
                searchController: _searchController,
                onChanged: (v) => _onSearchChanged(v, context),
                onEscape: _onEscape,
                appBarHeight: 48,
                searchIconData: YaruIcons.search,
              ),
            ),
    );
  }
}

class TouchMouseStylusScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus
      };
}
