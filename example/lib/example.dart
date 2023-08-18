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

    return model.compactMode
        ? _CompactPage(pageItems: examplePageItems)
        : _MasterDetailPage(pageItems: examplePageItems);
  }
}

class _MasterDetailPage extends StatelessWidget {
  _MasterDetailPage({required List<PageItem> pageItems})
      : pageItems = pageItems.where(isSupported).toList();

  final List<PageItem> pageItems;

  static bool isSupported(PageItem pageItem) {
    return pageItem.supportedLayouts.contains(YaruMasterDetailPage);
  }

  @override
  Widget build(BuildContext context) {
    return YaruMasterDetailPage(
      initialIndex: 1,
      layoutDelegate: const YaruMasterResizablePaneDelegate(
        initialPaneWidth: 280,
        minPageWidth: kYaruMasterDetailBreakpoint / 2,
        minPaneWidth: 175,
      ),
      length: pageItems.length,
      tileBuilder: (context, index, selected, availableWidth) => YaruMasterTile(
        leading: pageItems[index].iconBuilder(context, selected),
        title: buildTitle(context, pageItems[index]),
      ),
      pageBuilder: (context, index) => YaruDetailPage(
        appBar: YaruWindowTitleBar(
          leading:
              Navigator.of(context).canPop() ? const YaruBackButton() : null,
          title: buildTitle(context, pageItems[index]),
        ),
        body: pageItems[index].pageBuilder(context),
        floatingActionButton: CodeSnippedButton(
          pageItem: pageItems[index],
        ),
      ),
      appBar: const YaruWindowTitleBar(
        title: Text('Yaru Widgets'),
      ),
      bottomBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: YaruMasterTile(
          leading: const Icon(YaruIcons.gear),
          title: const Text('Settings'),
          onTap: () => showSettingsDialog(context),
        ),
      ),
    );
  }
}

class _CompactPage extends StatefulWidget {
  _CompactPage({required List<PageItem> pageItems})
      : pageItems = pageItems.where(_CompactPage.isSupported).toList();

  final List<PageItem> pageItems;

  static bool isSupported(PageItem pageItem) {
    return pageItem.supportedLayouts.contains(YaruNavigationPage);
  }

  @override
  State<_CompactPage> createState() => _CompactPageState();
}

class _CompactPageState extends State<_CompactPage> {
  final _selectedPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final style = width > 1000
        ? YaruNavigationRailStyle.labelledExtended
        : width > 500
            ? YaruNavigationRailStyle.labelled
            : YaruNavigationRailStyle.compact;

    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: ValueListenableBuilder<int>(
          valueListenable: _selectedPage,
          builder: (context, value, child) {
            return buildTitle(context, widget.pageItems[value]);
          },
        ),
      ),
      body: YaruNavigationPage(
        initialIndex: 1,
        length: widget.pageItems.length,
        itemBuilder: (context, index, selected) => YaruNavigationRailItem(
          icon: widget.pageItems[index].iconBuilder(context, selected),
          label: buildTitle(context, widget.pageItems[index]),
          tooltip: widget.pageItems[index].title,
          style: style,
        ),
        pageBuilder: (context, index) => Scaffold(
          body: widget.pageItems[index].pageBuilder(context),
          floatingActionButton: CodeSnippedButton(
            pageItem: widget.pageItems[index],
          ),
        ),
        trailing: YaruNavigationRailItem(
          icon: const Icon(YaruIcons.gear),
          label: const Text('Settings'),
          tooltip: 'Settings',
          style: style,
          onTap: () => showSettingsDialog(context),
        ),
        onSelected: (value) => _selectedPage.value = value,
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
              ),
            ],
          );
        },
      );
    },
  );
}
