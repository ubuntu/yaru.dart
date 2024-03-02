import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

import 'icon_items.dart';
import 'icon_view.dart';
import 'provider/icon_view_model.dart';

class IconsPage extends StatefulWidget {
  const IconsPage({super.key});

  static Widget create({
    required BuildContext context,
  }) {
    return ChangeNotifierProvider(
      create: (_) => IconViewModel(),
      child: const IconsPage(),
    );
  }

  @override
  State<IconsPage> createState() => _IconsPageState();
}

class _IconsPageState extends State<IconsPage>
    with SingleTickerProviderStateMixin {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: kYaruPagePadding,
              right: kYaruPagePadding,
              top: 10,
            ),
            child: YaruTabBar(
              onTap: (value) => setState(() => index = value),
              tabs: const [
                Tab(
                  text: 'Static',
                ),
                Tab(
                  text: 'Animated',
                ),
                Tab(
                  text: 'Widgets',
                ),
              ],
            ),
          ),
          Expanded(
            child: IconView(
              iconItems: switch (index) {
                0 => IconItems.static,
                1 => IconItems.animated,
                2 => IconItems.widget,
                _ => throw 'Invalid index'
              },
            ),
          ),
        ],
      ),
    );
  }
}

YaruWindowTitleBar createIconsPageAppBar(BuildContext context) {
  final model = context.read<IconViewModel>();
  final iconSize = context.select<IconViewModel, double>((m) => m.iconSize);
  final isMinIconSize =
      context.select<IconViewModel, bool>((m) => m.isMinIconSize);
  final isMaxIconSize =
      context.select<IconViewModel, bool>((m) => m.isMaxIconSize);
  final gridView = context.select<IconViewModel, bool>((m) => m.gridView);
  final searchActive =
      context.select<IconViewModel, bool>((m) => m.searchActive);

  return YaruWindowTitleBar(
    backgroundColor: Colors.transparent,
    border: BorderSide.none,
    leading: YaruSearchButton(
      searchActive: searchActive,
      onPressed: model.toggleSearch,
    ),
    title: searchActive
        ? YaruSearchField(
            onClear: model.toggleSearch,
            onChanged: model.onSearchChanged,
          )
        : const Text('YaruIcons'),
    actions: [
      Tooltip(
        message: gridView ? 'Toggle list view' : 'Toggle grid view',
        child: IconButton(
          onPressed: model.toggleGridView,
          icon: gridView
              ? const Icon(YaruIcons.unordered_list)
              : const Icon(YaruIcons.app_grid),
        ),
      ),
      Tooltip(
        message: 'Decrease icon size',
        child: IconButton(
          onPressed: isMinIconSize ? null : model.decreaseIconSize,
          icon: const Icon(YaruIcons.minus),
        ),
      ),
      Text('${iconSize.truncate()}px'),
      Tooltip(
        message: 'Increase icon size',
        child: IconButton(
          onPressed: isMaxIconSize ? null : model.increaseIconSize,
          icon: const Icon(YaruIcons.plus),
        ),
      ),
    ],
  );
}
