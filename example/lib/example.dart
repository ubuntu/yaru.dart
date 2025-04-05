import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'example_dark_light_toggle_button.dart';
import 'example_high_contrast_button.dart';
import 'example_model.dart';
import 'example_page_items.dart';
import 'example_theme_button.dart';

class Example extends StatelessWidget with WatchItMixin {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final compactMode = watchPropertyValue((ExampleModel m) => m.compactMode);
    final rtl = watchPropertyValue((ExampleModel m) => m.rtl);

    return Directionality(
      textDirection: !rtl ? TextDirection.ltr : TextDirection.rtl,
      child: compactMode
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
        subtitle: index == 0 ? const Text('Subtitle') : null,
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
        style: getStyle(context),
        title: const Text('Yaru'),
        border: BorderSide.none,
        backgroundColor: YaruMasterDetailTheme.of(context).sideBarColor,
        actions: const [
          SizedBox(
            width: 5,
          ),
          ExampleDarkLightToggleButton(),
          SizedBox(
            width: 5,
          ),
          ExampleYaruVariantPicker(),
          SizedBox(
            width: 5,
          ),
          ExampleHighContrastButton(),
          SizedBox(
            width: 5,
          ),
        ],
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

  YaruTitleBarStyle getStyle(BuildContext context) {
    return YaruTheme.maybeOf(context)?.hasLeftWindowControls == true
        ? YaruTitleBarStyle.onlyLeftWindowControls
        : YaruTitleBarStyle.undecorated;
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
              style: getStyle(context),
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

YaruTitleBarStyle getStyle(BuildContext context) {
  return YaruTheme.maybeOf(context)?.hasLeftWindowControls == true
      ? YaruTitleBarStyle.onlyLeftWindowControls
      : YaruTitleBarStyle.normal;
}

void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const SettingsDialog(),
  );
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

class SettingsDialog extends StatelessWidget with WatchItMixin {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final model = di<ExampleModel>();

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
              value: watchPropertyValue((ExampleModel m) => m.compactMode),
              onChanged: (v) => model.compactMode = v,
            ),
          ),
          YaruTile(
            title: const Text('RTL mode'),
            trailing: YaruSwitch(
              value: watchPropertyValue((ExampleModel m) => m.rtl),
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
  }
}
