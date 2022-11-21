import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'code_snippet_button.dart';
import 'example_model.dart';
import 'example_page_items.dart';

class Example extends StatefulWidget {
  // ignore: unused_element
  const Example({super.key});

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<ExampleModel>(
      create: (_) => ExampleModel(getService<Connectivity>()),
      child: const Example(),
    );
  }

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  void initState() {
    super.initState();
    context.read<ExampleModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ExampleModel>();
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
              value: model.compactMode,
              onChanged: (v) => model.compactMode = v,
            ),
          ),
        ],
      ),
      iconBuilder: (context, selected) => const Icon(YaruIcons.settings),
    );

    final pageItems = [configItem] + examplePageItems;
    return model.compactMode
        ? _CompactPage(configItem: configItem)
        : YaruMasterDetailPage(
            layoutDelegate: const YaruMasterResizablePaneDelegate(
              initialPaneWidth: 280,
              minPageWidth: kYaruMasterDetailBreakpoint / 2,
              minPaneWidth: 175,
            ),
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
                actions: [CodeSnippedButton(pageItem: pageItems[index])],
              ),
              body: pageItems[index].pageBuilder(context),
            ),
            appBar: AppBar(
              title: const Text('Example'),
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
