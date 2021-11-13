import 'package:flutter/material.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';
import 'package:yaru/yaru.dart' as yaru_theme;
import 'package:yaru_widgets/yaru_widgets.dart';

void main() {
  runApp(MaterialApp(
    theme: yaru_theme.lightTheme,
    darkTheme: yaru_theme.darkTheme,
    home: YaruMasterDetailPage(
      appBarHeight: 48,
      leftPaneWidth: 280,
      previousIconData: YaruIcons.go_previous,
      searchHint: 'Search...',
      searchIconData: YaruIcons.search,
      pageItems: pageItems,
    ),
  ));
}

final pageItems = <YaruPageItem>[
  YaruPageItem(
    title: 'Calendar',
    iconData: YaruIcons.calendar,
    builder: (_) => Column(
      children: const [
        YaruSection(headline: 'headline', children: [
          YaruRow(
            trailingWidget: Text('trailingWidget'),
            actionWidget: Text('actionWidget'),
            description: 'description',
          )
        ])
      ],
    ),
  ),
  YaruPageItem(
    title: 'Addons',
    iconData: YaruIcons.addon_filled,
    builder: (_) => const Text('Addons'),
  ),
  YaruPageItem(
    title: 'Address Book',
    iconData: YaruIcons.address_book,
    builder: (_) => const Text('Address Book'),
  ),
];
