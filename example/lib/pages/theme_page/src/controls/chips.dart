import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';

class Chips extends StatelessWidget {
  const Chips({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: kWrapSpacing,
      runSpacing: kWrapSpacing,
      children: [
        const Chip(label: Text('Chip')),
        Chip(
          deleteIcon: const Icon(YaruIcons.window_close),
          label: const Text('Deletable Chip'),
          onDeleted: () {},
        ),
        const ChoiceChip(
          label: Text('Disabled Chip'),
          selected: false,
          onSelected: null,
        ),
        ChoiceChip(
          label: const Text('Selected ChoiceChip'),
          selected: true,
          onSelected: (value) {},
        ),
        ChoiceChip(
          label: const Text('ChoiceChip'),
          selected: false,
          onSelected: (value) {},
        ),
        const ChoiceChip(
          label: Text('Selected, disabled ChoiceChip'),
          selected: true,
          onSelected: null,
        ),
      ],
    );
  }
}
