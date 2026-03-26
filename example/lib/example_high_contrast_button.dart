import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'example_model.dart';

class ExampleHighContrastButton extends StatelessWidget with WatchItMixin {
  const ExampleHighContrastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final highContrast =
        watchPropertyValue((ExampleModel m) => m.forceHighContrast) ||
        Theme.of(context).colorScheme.isHighContrast == true;

    return YaruIconButton(
      tooltip: 'Force HighContrast mode',
      onPressed: di<ExampleModel>().toggleForceHighContrast,
      icon: Icon(highContrast ? YaruIcons.eye_filled : YaruIcons.eye),
    );
  }
}
