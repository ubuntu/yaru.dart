import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  final _switchValues = [false, true, false];
  final _buttonValues = [false, true, false];
  final _listTileValues = [false, true, false];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < _switchValues.length; ++i) ...[
          Row(
            children: [
              YaruSwitch(
                value: _switchValues[i],
                onChanged: (v) => setState(() => _switchValues[i] = v),
              ),
              const SizedBox(width: 10),
              YaruSwitch(
                value: _switchValues[i],
                onChanged: null,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        const Divider(),
        for (var i = 0; i < _buttonValues.length; ++i) ...[
          YaruSwitchButton(
            value: _buttonValues[i],
            onChanged: (v) => setState(() => _buttonValues[i] = v),
            title: const Text('YaruSwitchButton'),
          ),
          const SizedBox(height: 10),
        ],
        const Divider(),
        for (var i = 0; i < _listTileValues.length; ++i)
          YaruSwitchListTile(
            value: _listTileValues[i],
            onChanged: (v) => setState(() => _listTileValues[i] = v),
            title: const Text('YaruSwitchListTile'),
          ),
      ],
    );
  }
}
