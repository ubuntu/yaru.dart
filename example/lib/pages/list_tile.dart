import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class ListTilePage extends StatefulWidget {
  const ListTilePage({super.key});

  @override
  State<ListTilePage> createState() => _ListTilePageState();
}

class _ListTilePageState extends State<ListTilePage> {
  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          children: [
            YaruListTile(titleText: 'YaruListTile', onTap: () {}),
            YaruListTile(
              titleText: 'YaruListTile',
              subtitleText: 'YaruListTile subtitle',
              onTap: () {},
            ),
            YaruListTile(
              titleText: 'YaruListTile',
              subtitleText: 'YaruListTile subtitle',
              leading: const Icon(YaruIcons.ubuntu_logo_simple),
              onTap: () {},
            ),
            YaruListTile(
              titleText: 'YaruListTile',
              subtitleText: 'YaruListTile subtitle',
              trailing: const Icon(YaruIcons.ubuntu_logo_simple),
              onTap: () {},
            ),
            YaruTileList(
              children: [
                for (final canTap in [true, false]) ...[
                  YaruListTile.square(
                    enabled: canTap,
                    titleText: 'YaruListTile',
                    onTap: canTap ? () {} : null,
                  ),
                  YaruListTile.square(
                    enabled: canTap,
                    titleText: 'YaruListTile',
                    subtitleText: 'YaruListTile subtitle',
                    onTap: canTap ? () {} : null,
                  ),
                  YaruListTile.square(
                    enabled: canTap,
                    titleText: 'YaruListTile',
                    subtitleText: 'YaruListTile subtitle',
                    leading: const Icon(YaruIcons.ubuntu_logo_simple),
                    onTap: canTap ? () {} : null,
                  ),
                  YaruListTile.square(
                    enabled: canTap,
                    titleText: 'YaruListTile',
                    subtitleText: 'YaruListTile subtitle',
                    trailing: const Icon(YaruIcons.ubuntu_logo_simple),
                    onTap: canTap ? () {} : null,
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}
