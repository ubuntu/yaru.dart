import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class WindowControlsPage extends StatefulWidget {
  const WindowControlsPage({super.key});

  @override
  State<WindowControlsPage> createState() => _WindowControlsPageState();
}

class _WindowControlsPageState extends State<WindowControlsPage> {
  bool _maximized = false;

  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          children: [
            for (final platform in YaruWindowControlPlatform.values) ...[
              Text(
                '${platform.name.capitalize()}:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              for (final interactive in [true, false]) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    YaruWindowControl(
                      type: YaruWindowControlType.minimize,
                      platform: platform,
                      onTap: interactive ? () {} : null,
                    ),
                    if (platform == YaruWindowControlPlatform.yaru)
                      const SizedBox(width: 10),
                    YaruWindowControl(
                      type: _maximized
                          ? YaruWindowControlType.restore
                          : YaruWindowControlType.maximize,
                      platform: platform,
                      onTap: interactive
                          ? () => setState(() => _maximized = !_maximized)
                          : null,
                    ),
                    if (platform == YaruWindowControlPlatform.yaru)
                      const SizedBox(width: 10),
                    YaruWindowControl(
                      type: YaruWindowControlType.close,
                      platform: platform,
                      onTap: interactive ? () {} : null,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 25),
            ],
            Center(
              child: YaruSwitchButton(
                title: const Text('Maximized'),
                value: _maximized,
                onChanged: (v) => setState(() => _maximized = v),
              ),
            ),
          ],
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
