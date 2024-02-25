import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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

class _IconsPageState extends State<IconsPage> {
  @override
  Widget build(BuildContext context) {
    final iconSize = context.select<IconViewModel, double>((m) => m.iconSize);
    final isMinIconSize =
        context.select<IconViewModel, bool>((m) => m.isMinIconSize);
    final isMaxIconSize =
        context.select<IconViewModel, bool>((m) => m.isMaxIconSize);
    final gridView = context.select<IconViewModel, bool>((m) => m.gridView);
    final searchActive =
        context.select<IconViewModel, bool>((m) => m.searchActive);

    return Scaffold(
      appBar: AppBar(
        title: YaruSearchTitleField(
          searchActive: searchActive,
          width: 250,
          title: const Text(
            'Flutter Yaru Icons Demo',
          ),
          onSearchActive: context.read<IconViewModel>().toggleSearch,
          onClear: context.read<IconViewModel>().toggleSearch,
          onChanged: context.read<IconViewModel>().onSearchChanged,
        ),
        actions: [
          Tooltip(
            message: gridView ? 'Toggle list view' : 'Toggle grid view',
            child: IconButton(
              onPressed: context.read<IconViewModel>().toggleGridView,
              icon: gridView
                  ? const Icon(YaruIcons.unordered_list)
                  : const Icon(YaruIcons.app_grid),
            ),
          ),
          Tooltip(
            message: 'Decrease icon size',
            child: IconButton(
              onPressed: isMinIconSize
                  ? null
                  : context.read<IconViewModel>().decreaseIconSize,
              icon: const Icon(YaruIcons.minus),
            ),
          ),
          Text('${iconSize.truncate()}px'),
          Tooltip(
            message: 'Increase icon size',
            child: IconButton(
              onPressed: isMaxIconSize
                  ? null
                  : context.read<IconViewModel>().increaseIconSize,
              icon: const Icon(YaruIcons.plus),
            ),
          ),
        ],
      ),
      body: YaruNavigationPage(
        length: 3,
        itemBuilder: (context, index, selected) {
          const style = YaruNavigationRailStyle.labelled;

          switch (index) {
            case 0:
              return const YaruNavigationRailItem(
                icon: Icon(YaruIcons.image),
                label: Text('Static icons'),
                tooltip: 'Static icons',
                style: style,
              );
            case 1:
              return const YaruNavigationRailItem(
                icon: Icon(YaruIcons.video),
                label: Text('Animated icons'),
                tooltip: 'Animated icons',
                style: style,
              );
            case 2:
              return const YaruNavigationRailItem(
                icon: Icon(YaruIcons.rule_and_pen),
                label: Text('Widget icons'),
                tooltip: 'Widget icons',
                style: style,
              );
            default:
              throw 'Invalid index';
          }
        },
        pageBuilder: (context, index) {
          List<IconItem> iconItems;

          switch (index) {
            case 0:
              iconItems = IconItems.static;
              break;
            case 1:
              iconItems = IconItems.animated;
              break;
            case 2:
              iconItems = IconItems.widget;
              break;
            default:
              throw 'Invalid index';
          }

          return IconView(iconItems: iconItems);
        },
      ),
    );
  }
}
