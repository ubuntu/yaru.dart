import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class IconButtonPage extends StatefulWidget {
  const IconButtonPage({super.key});

  @override
  State<IconButtonPage> createState() => _IconButtonPageState();
}

class _IconButtonPageState extends State<IconButtonPage> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        Row(
          children: [
            YaruIconButton(
              onPressed: () {},
              icon: const Icon(YaruIcons.ubuntu_logo),
            ),
            const SizedBox(width: 10),
            YaruIconButton(
              onPressed: () => setState(
                () => _selected = !_selected,
              ),
              isSelected: _selected,
              icon: const Icon(YaruIcons.eye),
              tooltip: 'View',
            ),
          ],
        ),
      ],
    );
  }
}
