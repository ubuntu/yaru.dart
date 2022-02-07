import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/example_page_items.dart';

class MasterDetailHomePage extends StatefulWidget {
  const MasterDetailHomePage({Key? key}) : super(key: key);

  @override
  State<MasterDetailHomePage> createState() => _MasterDetailHomePageState();
}

class _MasterDetailHomePageState extends State<MasterDetailHomePage> {
  @override
  Widget build(BuildContext context) {
    return YaruMasterDetailPage(
      appBarHeight: 48,
      leftPaneWidth: 280,
      previousIconData: YaruIcons.go_previous,
      searchHint: 'Search...',
      searchIconData: YaruIcons.search,
      pageItems: examplePageItems,
    );
  }
}
