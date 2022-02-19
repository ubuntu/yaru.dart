import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/widgets/row_list.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yaru Wide- / NarrowLayout Example',
      theme: yaruLight,
      darkTheme: yaruDark,
      home: const WideNarrowHomePage(),
    );
  }
}

class WideNarrowHomePage extends StatelessWidget {
  const WideNarrowHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: YaruSearchAppBar(
            appBarHeight:
                Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight,
            searchIconData: YaruIcons.search,
            searchController: TextEditingController(),
            onChanged: (value) {},
            onEscape: () {},
            automaticallyImplyLeading: true),
        body: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth > 600
                ? YaruWideLayout(
                    pageItems: pageItems,
                    initialIndex: 0,
                  )
                : YaruNarrowLayout(pageItems: pageItems, initialIndex: 0)),
      ),
    );
  }
}

final pageItems = [
  YaruPageItem(
      titleBuilder: (context) => Text('Home'),
      builder: (_) => const Text('Home'),
      iconData: YaruIcons.home,
      selectedIconData: YaruIcons.home_filled),
  YaruPageItem(
      titleBuilder: (context) => Text('View'),
      builder: (_) => YaruTabbedPage(tabIcons: [
            YaruIcons.lock_filled,
            YaruIcons.globe_filled,
            YaruIcons.power_filled
          ], tabTitles: [
            'Lock',
            'Globe',
            'Power'
          ], views: [
            YaruPage(children: [RowList()]),
            Center(child: Text('Globe')),
            Center(child: Text('Power'))
          ]),
      iconData: YaruIcons.view,
      selectedIconData: YaruIcons.view_filled),
  YaruPageItem(
      titleBuilder: (context) => Text('Time'),
      builder: (_) => const Text('Time'),
      iconData: YaruIcons.clock,
      selectedIconData: YaruIcons.clock_filled),
  YaruPageItem(
      titleBuilder: (context) => Text('Favorites'),
      builder: (_) => const Text('Favorites'),
      iconData: YaruIcons.star,
      selectedIconData: YaruIcons.star_filled),
  YaruPageItem(
      titleBuilder: (context) => Text('Electronics'),
      builder: (_) => const Text('Electronics'),
      iconData: YaruIcons.chip,
      selectedIconData: YaruIcons.chip_filled),
  YaruPageItem(
      titleBuilder: (context) => Text('Gallery'),
      builder: (_) => const Text('Gallery'),
      iconData: YaruIcons.image,
      selectedIconData: YaruIcons.image_filled),
];
