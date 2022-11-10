import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:http/http.dart' as http;
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
      snippetUrl:
          'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/lib/src/layouts/yaru_landscape_layout.dart',
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
                  actions: [_buildSnippetButton(context, pageItems[index])],
                ),
                body: pageItems[index].pageBuilder(context),
              ),
              appBar: AppBar(
                title: const Text('Example'),
              ),
            ),
    );
  }

  Widget _buildSnippetButton(BuildContext context, PageItem pageItem) {
    if (pageItem.snippetUrl == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: YaruIconButton(
          onPressed: () => showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              var snippet = '';

              return AlertDialog(
                titlePadding: EdgeInsets.zero,
                title: YaruTitleBar(
                  title: Text(pageItem.tooltipMessage),
                  trailing: const YaruCloseButton(),
                  leading: IconButton(
                    icon: const Icon(YaruIcons.edit_copy),
                    tooltip: 'Copy',
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: snippet),
                      );
                    },
                  ),
                ),
                content: FutureBuilder<String>(
                  future: _getCodeSnippet(
                    pageItem.snippetUrl!,
                  ),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Center(
                          child: YaruCircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        );
                      case ConnectionState.done:
                        snippet = snapshot.data!;
                        return SingleChildScrollView(
                          child: HighlightView(
                            snippet,
                            language: 'dart',
                            theme:
                                Theme.of(context).brightness == Brightness.dark
                                    ? vs2015Theme
                                    : vsTheme,
                            padding: const EdgeInsets.all(12),
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                    }
                  },
                ),
              );
            },
          ),
          icon: const Icon(YaruIcons.desktop_panel_look),
          tooltip: 'Example snippet',
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

Future<String> _getCodeSnippet(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  return response.body;
}
