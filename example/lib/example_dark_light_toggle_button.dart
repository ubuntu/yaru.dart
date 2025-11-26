import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'example_model.dart';

class ExampleDarkLightToggleButton extends StatelessWidget with WatchItMixin {
  const ExampleDarkLightToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = watchPropertyValue((ExampleModel m) => m.themeMode);

    return YaruIconButton(
      tooltip: 'ThemeMode (System, Light, Dark)',
      onPressed: () => di<ExampleModel>().setThemeMode(switch (themeMode) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      }),
      icon: switch (themeMode) {
        ThemeMode.system => const Icon(YaruIcons.private_mask),
        ThemeMode.light => const Icon(YaruIcons.sun),
        ThemeMode.dark => const Icon(YaruIcons.clear_night),
      },
    );
  }
}
