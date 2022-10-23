import 'package:example/src/animated_icons_grid.dart';
import 'package:example/src/icon_size_provider.dart';
import 'package:example/src/icon_table.dart';
import 'package:provider/provider.dart';
import 'package:yaru_colors/yaru_colors.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Yaru Icons Demo',
      debugShowCheckedModeBanner: false,
      home: YaruTheme(
        child: ChangeNotifierProvider(
          create: (context) => IconSizeProvider(),
          builder: (context, child) {
            final iconSizeProvider = Provider.of<IconSizeProvider>(context);

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  leading:
                      Icon(YaruIcons.ubuntu_logo, color: YaruColors.orange),
                  title: Consumer<IconSizeProvider>(
                    builder: (context, iconsSize, _) => Text(
                      'Flutter Yaru Icons Demo (${iconsSize.size.truncate()}px)',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: iconSizeProvider.isMinSize()
                          ? null
                          : iconSizeProvider.decreaseSize,
                      child: Icon(YaruIcons.minus),
                    ),
                    TextButton(
                      onPressed: iconSizeProvider.increaseSize,
                      child: Icon(YaruIcons.plus),
                    )
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(text: 'Static Icons'),
                      Tab(text: 'Animated Icons'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    YaruIconTable(),
                    YaruAnimatedIconsGrid(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
