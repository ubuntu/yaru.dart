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

    final pageItems = examplePageItems;
    return model.compactMode
        ? const _CompactPage()
        : YaruMasterDetailPage(
            layoutDelegate: const YaruMasterResizablePaneDelegate(
              initialPaneWidth: 280,
              minPageWidth: kYaruMasterDetailBreakpoint / 2,
              minPaneWidth: 175,
            ),
            length: pageItems.length,
            tileBuilder: (context, index, selected) => YaruMasterTile(
              leading: pageItems[index].iconBuilder(context, selected),
              title: buildTitle(context, pageItems[index]),
            ),
            pageBuilder: (context, index) => YaruDetailPage(
              appBar: AppBar(
                leading: Navigator.of(context).canPop()
                    ? const YaruBackButton()
                    : null,
                title: buildTitle(context, pageItems[index]),
                actions: [CodeSnippedButton(pageItem: pageItems[index])],
              ),
              body: pageItems[index].pageBuilder(context),
            ),
            appBar: AppBar(
              title: const Text('Example'),
            ),
            bottomBar: BottomAppBar(
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: YaruMasterTile(
                      leading: const Icon(YaruIcons.gear),
                      title: const Text('Settings'),
                      onTap: () => showSettingsDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class _CompactPage extends StatelessWidget {
  const _CompactPage();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final style = width > 1000
        ? YaruNavigationRailStyle.labelledExtended
        : width > 500
            ? YaruNavigationRailStyle.labelled
            : YaruNavigationRailStyle.compact;

    final pageItems = examplePageItems;

    return YaruNavigationPage(
      length: pageItems.length,
      itemBuilder: (context, index, selected) => YaruNavigationRailItem(
        icon: pageItems[index].iconBuilder(context, selected),
        label: buildTitle(context, pageItems[index]),
        tooltip: pageItems[index].title,
        style: style,
      ),
      pageBuilder: (context, index) => pageItems[index].pageBuilder(context),
      trailing: YaruNavigationRailItem(
        icon: const Icon(YaruIcons.gear),
        label: const Text('Settings'),
        tooltip: 'Settings',
        style: style,
        onTap: () => showSettingsDialog(context),
      ),
    );
  }
}

Widget buildTitle(BuildContext context, PageItem item) {
  return item.titleBuilder?.call(context) ?? Text(item.title);
}

Future<void> showSettingsDialog(BuildContext context) {
  final model = context.read<ExampleModel>();

  return showDialog(
    context: context,
    builder: (context) {
      return AnimatedBuilder(
        animation: model,
        builder: (context, child) {
          return AlertDialog(
            title: const YaruDialogTitleBar(
              title: Text('Settings'),
            ),
            titlePadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.all(kYaruPagePadding),
            content: Column(
              mainAxisSize: MainAxisSize.min,
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
            actions: [
              OutlinedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              )
            ],
          );
        },
      );
    },
  );
}
