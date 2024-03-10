import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../constants.dart';

class Toggleables extends StatelessWidget {
  const Toggleables({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const Text('ToggleButtons:'),
            ToggleButtons(
              isSelected: const [true, false, false],
              onPressed: (v) {},
              children: const [Text('Off'), Text('Off'), Text('Off')],
            ),
            ToggleButtons(
              isSelected: const [true, false, false],
              children: const [Text('Off'), Text('Off'), Text('Off')],
            ),
            const Divider(
              height: 2 * kWrapSpacing,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: YaruInfoBox(
            yaruInfoType: YaruInfoType.information,
            subtitle: Text(
              'The following material Checks/Radios are only fallbacks, due to insufficient styling capabilities. Please use YaruCheckBox and YaruRadio instead.',
            ),
          ),
        ),
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
        Wrap(
          spacing: 10,
          children: [
            Switch(onChanged: (value) {}, value: true),
            Switch(onChanged: (value) {}, value: false),
            const Switch(value: true, onChanged: null),
            const Switch(value: false, onChanged: null),
          ],
        ),
      ],
    );
  }
}
