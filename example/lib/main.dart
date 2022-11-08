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
  final _filteredItems = <PageItem>[];
  bool _compactMode = false;

  @override
  Widget build(BuildContext context) {
    final configItem = PageItem(
      titleBuilder: (context) => const Text('Layout'),
      tooltipMessage: 'Layout',
      pageBuilder: (_) => ListView(
        padding: const EdgeInsets.all(kYaruPagePadding),
        children: [
          YaruTile(
            title: const Text('Compact mode'),
            trailing: YaruSwitch(
              value: _compactMode,
              onChanged: (v) => setState(() => _compactMode = v),
            ),
          ),
        ],
      ),
      iconBuilder: (context, selected) => const Icon(YaruIcons.settings),
    );

    final pageItems = _filteredItems.isNotEmpty
        ? _filteredItems
        : [configItem] + examplePageItems;

    return MaterialApp(
      title: 'Yaru Widgets Factory',
      debugShowCheckedModeBanner: false,
      theme: context.watch<LightTheme>().value,
      darkTheme: context.watch<DarkTheme>().value,
      home: _compactMode
          ? _CompactPage(configItem: configItem)
          : YaruMasterDetailPage(
              leftPaneWidth: 280,
              length: pageItems.length,
              tileBuilder: (context, index, selected) => YaruMasterTile(
                leading: pageItems[index].iconBuilder(context, selected),
                title: pageItems[index].titleBuilder(context),
              ),
              pageBuilder: (context, index) => YaruDetailPage(
                appBar: AppBar(
                  leading: Navigator.of(context).canPop()
                      ? const YaruBackButton()
                      : null,
                  title: pageItems[index].titleBuilder(context),
                ),
                body: pageItems[index].pageBuilder(context),
              ),
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

  final PageItem configItem;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final pageItems = [configItem] + examplePageItems;

    return YaruCompactLayout(
      length: pageItems.length,
      itemBuilder: (context, index, selected) => YaruNavigationRailItem(
        icon: pageItems[index].iconBuilder(context, selected),
        label: pageItems[index].titleBuilder(context),
        tooltip: pageItems[index].tooltipMessage,
        style: width > 1000
            ? YaruNavigationRailStyle.labelledExtended
            : width > 500
                ? YaruNavigationRailStyle.labelled
                : YaruNavigationRailStyle.compact,
      ),
      pageBuilder: (context, index) => pageItems[index].pageBuilder(context),
    );
  }
}
