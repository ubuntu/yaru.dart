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
        ],
      ),
      iconBuilder: (context, selected) => const Icon(YaruIcons.settings),
    );

    return MaterialApp(
      title: 'Yaru Widgets Factory',
      scrollBehavior: TouchMouseStylusScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: context.watch<LightTheme>().value,
      darkTheme: context.watch<DarkTheme>().value,
      home: _compactMode
          ? _CompactPage(configItem: configItem)
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
  });

  final YaruPageItem configItem;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return YaruCompactLayout(
      style: width > 1000
          ? YaruNavigationRailStyle.labelledExtended
          : width > 500
              ? YaruNavigationRailStyle.labelled
              : YaruNavigationRailStyle.compact,
      pageItems: [configItem] + examplePageItems,
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
