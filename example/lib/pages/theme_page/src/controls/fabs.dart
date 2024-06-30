import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';
import '../utils.dart';

class Fabs extends StatelessWidget {
  const Fabs({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() => showSnack(context);

    return Wrap(
      spacing: kWrapSpacing,
      runSpacing: kWrapSpacing,
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(YaruIcons.plus),
        ),
        FloatingActionButton.extended(
          onPressed: onPressed,
          label: const Text('Yay! +1 ❤️ for Yaru'),
        ),
        FloatingActionButton.small(
          onPressed: onPressed,
          child: const Icon(YaruIcons.plus),
        ),
        FloatingActionButton.large(
          onPressed: onPressed,
          child: const Icon(YaruIcons.plus),
        ),
      ],
    );
  }
}
