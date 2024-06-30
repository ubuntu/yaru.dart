import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    const icon = Icon(YaruIcons.notification_filled);
    final buttons = <(Widget, Widget)>[
      (
        TextButton(
          onPressed: () {},
          child: const Text('Text'),
        ),
        const TextButton(
          onPressed: null,
          autofocus: true,
          child: Text('Text'),
        ),
      ),
      (
        OutlinedButton(
          onPressed: () {},
          child: const Text('Outlined'),
        ),
        const OutlinedButton(
          onPressed: null,
          child: Text('Outlined'),
        ),
      ),
      (
        FilledButton(
          onPressed: () {},
          child: const Text('Filled'),
        ),
        const FilledButton(
          onPressed: null,
          child: Text('Filled'),
        ),
      ),
      (
        ElevatedButton(
          onPressed: () {},
          child: const Text('Elevated'),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text('Elevated'),
        ),
      ),
      (
        ElevatedButton.icon(
          icon: icon,
          onPressed: () {},
          label: const Text('Elevated'),
        ),
        ElevatedButton.icon(
          icon: icon,
          onPressed: null,
          label: const Text('Elevated'),
        ),
      ),
      (
        IconButton.filled(
          onPressed: () {},
          icon: icon,
        ),
        const IconButton.filled(
          onPressed: null,
          icon: icon,
        ),
      ),
      (
        IconButton.outlined(
          onPressed: () {},
          icon: icon,
        ),
        const IconButton.outlined(
          onPressed: null,
          icon: icon,
        ),
      ),
      (
        IconButton.filledTonal(
          onPressed: () {},
          icon: icon,
        ),
        const IconButton.filledTonal(
          onPressed: null,
          icon: icon,
        ),
      ),
      (
        IconButton(
          isSelected: _selected,
          onPressed: () => setState(() => _selected = !_selected),
          icon: icon,
        ),
        const IconButton(
          onPressed: null,
          icon: icon,
        ),
      ),
    ];

    return Wrap(
      direction: Axis.vertical,
      spacing: kWrapSpacing,
      runSpacing: kWrapSpacing,
      children: [
        for (final button in buttons)
          Wrap(
            spacing: kWrapSpacing,
            children: [button.$1, button.$2],
          ),
      ],
    );
  }
}
