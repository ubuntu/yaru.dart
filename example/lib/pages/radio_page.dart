import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  int? _radioValue = 1;
  int? _buttonValue = 1;
  int? _listTileValue = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < 3; ++i) ...[
          Row(
            children: [
              YaruRadio<int>(
                value: i,
                groupValue: _radioValue,
                onChanged: (v) => setState(() => _radioValue = v),
                toggleable: true,
              ),
              const SizedBox(width: 10),
              YaruRadio<int>(
                value: i,
                groupValue: _radioValue,
                onChanged: null,
                toggleable: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        const Divider(),
        for (var i = 0; i < 3; ++i) ...[
          YaruRadioButton<int>(
            value: i,
            groupValue: _buttonValue,
            onChanged: (v) => setState(() => _buttonValue = v),
            toggleable: true,
            title: const Text('YaruRadioButton'),
          ),
          const SizedBox(height: 10),
        ],
        const Divider(),
        for (var i = 0; i < 3; ++i)
          YaruRadioListTile<int>(
            value: i,
            groupValue: _listTileValue,
            onChanged: (v) => setState(() => _listTileValue = v),
            toggleable: true,
            title: const Text('YaruRadioListTile'),
          ),
      ],
    );
  }
}
