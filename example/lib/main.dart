import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'example_page_items.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LightTheme(yaruLight)),
        ChangeNotifierProvider(create: (_) => DarkTheme(yaruDark)),
      ],
      child: const Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _filteredItems = <YaruPageItem>[];
  bool _compactMode = false;
  int _amount = 3;

  @override
  Widget build(BuildContext context) {
    final configItem = YaruPageItem(
      titleBuilder: (context) => YaruPageItemTitle.text('Layout'),
      builder: (_) => YaruPage(
        children: [
          YaruTile(
            title: const Text('Compact mode'),
            trailing: Switch(
              value: _compactMode,
              onChanged: (v) => setState(() => _compactMode = v),
            ),
          ),
          if (_compactMode)
            YaruTile(
              title: const Text('YaruPageItem amount'),
              trailing: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      if (_amount >= examplePageItems.length) return;
                      setState(() => _amount++);
                    },
                    child: const Icon(YaruIcons.plus),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_amount <= 2) return;
                      setState(() => _amount--);
                    },
                    child: const Icon(YaruIcons.minus),
                  ),
                ],
              ),
            )
        ],
      ),
      iconData: YaruIcons.settings,
    );

    return MaterialApp(
      title: 'Yaru Widgets Factory',
      scrollBehavior: TouchMouseStylusScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: context.watch<LightTheme>().value,
      darkTheme: context.watch<DarkTheme>().value,
      home: _compactMode
          ? _CompactPage(configItem: configItem, amount: _amount)
          : YaruMasterDetailPage(
              leftPaneWidth: 280,
              previousIconData: YaruIcons.go_previous,
              pageItems: _filteredItems.isNotEmpty
                  ? _filteredItems
                  : [configItem] + examplePageItems,
              appBar: AppBar(
                title: const Text('Example'),
              ),
            ),
    );
  }
}

class _CompactPage extends StatelessWidget {
  const _CompactPage({
    required this.configItem,
    required int amount,
  }) : _amount = amount;

  final YaruPageItem configItem;
  final int _amount;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return YaruCompactLayout(
      extendNavigationRail: width > 1000,
      pageItems: [configItem] + examplePageItems.take(_amount).toList(),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.03),
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
