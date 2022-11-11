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
        for (var interactive in [true, false]) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              YaruWindowControl(
                type: YaruWindowControlType.minimize,
                onTap: interactive ? () {} : null,
              ),
              const SizedBox(width: 10),
              YaruWindowControl(
                type: _maximized
                    ? YaruWindowControlType.maximize
                    : YaruWindowControlType.restore,
                onTap: interactive
                    ? () => setState(() => _maximized = !_maximized)
                    : null,
              ),
              const SizedBox(width: 10),
              YaruWindowControl(
                type: YaruWindowControlType.close,
                onTap: interactive ? () {} : null,
              ),
            ],
          ),
          const SizedBox(height: 10)
        ],
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
