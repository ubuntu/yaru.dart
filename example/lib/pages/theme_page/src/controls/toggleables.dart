import 'package:flutter/material.dart';

import '../constants.dart';

class Toggleables extends StatefulWidget {
  const Toggleables({super.key});

  @override
  State<Toggleables> createState() => _ToggleablesState();
}

class _ToggleablesState extends State<Toggleables> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Info: those are just Fallback toggleables. Please use YaruCheckBox and YaruRadio instead',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).clearMaterialBanners(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        Row(
          children: [
            Checkbox(value: true, onChanged: (_) {}),
            Checkbox(value: false, onChanged: (_) {}),
            const Checkbox(value: true, onChanged: null),
            const Checkbox(value: false, onChanged: null),
          ],
        ),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: true,
              onChanged: (_) {},
            ),
            Radio(
              value: false,
              groupValue: true,
              onChanged: (_) {},
            ),
            const Radio(
              value: true,
              groupValue: true,
              onChanged: null,
            ),
            const Radio(
              value: false,
              groupValue: true,
              onChanged: null,
            ),
          ],
        ),
        Row(
          children: [
            Switch(onChanged: (value) {}, value: true),
            Switch(onChanged: (value) {}, value: false),
            const Switch(value: true, onChanged: null),
            const Switch(value: false, onChanged: null),
          ],
        ),
        Row(
          children: [
            ToggleButtons(
              isSelected: const [true, false, false],
              onPressed: (v) {},
              children: const [Text('Off'), Text('Off'), Text('Off')],
            ),
            const SizedBox(
              width: kWrapSpacing,
            ),
            ToggleButtons(
              isSelected: const [true, false, false],
              children: const [Text('Off'), Text('Off'), Text('Off')],
            ),
          ],
        ),
      ],
    );
  }
}
