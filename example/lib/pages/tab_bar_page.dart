import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;

    return Center(
      child: SimpleDialog(
        shadowColor: light ? Colors.black : null,
        titlePadding: EdgeInsets.zero,
        title: YaruDialogTitleBar(
          leading: Center(
            child: YaruOptionButton(
              onPressed: () {},
              child: const Icon(YaruIcons.plus),
            ),
          ),
          title: SizedBox(
            width: 500,
            child: YaruTabBar(
              tabController: tabController,
              icons: const [
                Icon(YaruIcons.game_controller),
                Icon(YaruIcons.keyboard),
                Icon(YaruIcons.address_book),
              ],
              labels: const ['Gaming', 'Keyboard', 'Contacts'],
            ),
          ),
        ),
        children: [
          SizedBox(
            width: 600,
            height: 400,
            child: TabBarView(
              controller: tabController,
              children: const [
                Icon(YaruIcons.game_controller),
                Icon(YaruIcons.keyboard),
                Icon(YaruIcons.address_book),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
