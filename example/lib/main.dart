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
  bool compact = true;

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
          value: compact,
          onChanged: (v) => setState(() => compact = v),
        )
      ]),
      iconData: YaruIcons.settings,
    );

    return MaterialApp(
      scrollBehavior: TouchMouseStylusScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: context.watch<LightTheme>().value,
      darkTheme: context.watch<DarkTheme>().value,
      home: compact
          ? YaruCompactLayout(pageItems: [configItem] + examplePageItems)
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
