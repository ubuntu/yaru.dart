import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru/yaru.dart';

import 'example_model.dart';
import 'example_page_items.dart';
import 'pages/icons_page/provider/icon_view_model.dart';

class Example extends StatefulWidget {
  // ignore: unused_element
  const Example({super.key});

  static Widget create(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExampleModel>(
          create: (_) => ExampleModel(getService<Connectivity>()),
        ),
        ChangeNotifierProvider(
          create: (_) => IconViewModel(),
        ),
      ],
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

    return Directionality(
      textDirection: !model.rtl ? TextDirection.ltr : TextDirection.rtl,
      child: model.compactMode
          ? _CompactPage(pageItems: examplePageItems)
          : _MasterDetailPage(pageItems: examplePageItems),
    );
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
      paneLayoutDelegate: const YaruResizablePaneDelegate(
        initialPaneSize: 280,
        minPageSize: kYaruMasterDetailBreakpoint / 2,
        minPaneSize: 175,
      ),
      length: pageItems.length,
      tileBuilder: (context, index, selected, availableWidth) => YaruMasterTile(
        leading: pageItems[index].iconBuilder(context, selected),
        title: Text(pageItems[index].title),
      ),
      pageBuilder: (context, index) => YaruDetailPage(
        appBar: YaruWindowTitleBar(
          backgroundColor: Colors.transparent,
          border: BorderSide.none,
          leading:
              Navigator.of(context).canPop() ? const YaruBackButton() : null,
          title: buildTitle(context, pageItems[index]),
          actions: buildActions(context, pageItems[index]),
        ),
        body: pageItems[index].pageBuilder(context),
        floatingActionButton:
            buildFloatingActionButton(context, pageItems[index]),
      ),
      appBar: YaruWindowTitleBar(
        title: const Text('Yaru'),
        border: BorderSide.none,
        backgroundColor: YaruMasterDetailTheme.of(context).sideBarColor,
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kYaruTitleBarHeight),
        child: ValueListenableBuilder<int>(
          valueListenable: _selectedPage,
          builder: (context, value, child) {
            return YaruWindowTitleBar(
              leading: buildLeading(context, widget.pageItems[value]),
              title: buildTitle(context, widget.pageItems[value]),
              actions: buildActions(context, widget.pageItems[value]),
            );
          },
        ),
      ),
      body: YaruNavigationPage(
        initialIndex: 1,
        length: widget.pageItems.length,
        itemBuilder: (context, index, selected) => YaruNavigationRailItem(
          icon: widget.pageItems[index].iconBuilder(context, selected),
          label: Text(widget.pageItems[index].title),
          tooltip: widget.pageItems[index].title,
          style: style,
        ),
        pageBuilder: (context, index) => Scaffold(
          body: widget.pageItems[index].pageBuilder(context),
          floatingActionButton:
              buildFloatingActionButton(context, widget.pageItems[index]),
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

Widget? buildLeading(BuildContext context, PageItem item) {
  return item.leadingBuilder?.call(context);
}

Widget buildTitle(BuildContext context, PageItem item) {
  return item.titleBuilder?.call(context) ?? Text(item.title);
}

List<Widget>? buildActions(BuildContext context, PageItem item) {
  return item.actionsBuilder?.call(context);
}

Widget? buildFloatingActionButton(BuildContext context, PageItem item) {
  return item.floatingActionButtonBuilder?.call(context);
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
                YaruTile(
                  title: const Text('RTL mode'),
                  trailing: YaruSwitch(
                    value: model.rtl,
                    onChanged: (v) => model.rtl = v,
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
