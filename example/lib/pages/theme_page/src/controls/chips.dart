import 'package:flutter/material.dart';

import '../constants.dart';

class Chips extends StatelessWidget {
  const Chips({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: kWrapSpacing,
      runSpacing: kWrapSpacing,
      children: [
        const Chip(label: Text('Ch-ch-ch-Chip n Dale')),
        Chip(
          label: const Text('Rescue Rangers'),
          onDeleted: () {},
        ),
        const ChoiceChip(
          label: Text('Ch-ch-ch-Chip n Dale'),
          selected: false,
          onSelected: null,
        ),
        ChoiceChip(
          label: const Text("When there's danger"),
          selected: true,
          onSelected: (value) {},
        ),
        const ChoiceChip(
          label: Text('No, no, it never fails'),
          selected: true,
          onSelected: null,
        ),
        ChoiceChip(
          label: const Text('Once they re involved'),
          selected: false,
          onSelected: (value) {},
        ),
      ],
    );
  }
}
