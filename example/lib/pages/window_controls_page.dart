import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class WindowControlsPage extends StatefulWidget {
  const WindowControlsPage({super.key});

  @override
  State<WindowControlsPage> createState() => _WindowControlsPageState();
}

class _WindowControlsPageState extends State<WindowControlsPage> {
  bool _maximized = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const YaruWindowControl(type: YaruWindowControlType.minimize),
            const SizedBox(width: 10),
            YaruWindowControl(
              type: _maximized
                  ? YaruWindowControlType.maximize
                  : YaruWindowControlType.restore,
            ),
            const SizedBox(width: 10),
            const YaruWindowControl(type: YaruWindowControlType.close),
          ],
        ),
        YaruTile(
          title: const Text('Maximized'),
          trailing: YaruSwitch(
            value: _maximized,
            onChanged: (v) => setState(() => _maximized = v),
          ),
        ),
      ],
    );
  }
}
