import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ControlListTilesPage extends StatefulWidget {
  const ControlListTilesPage({super.key});

  @override
  _ControlListTilesPageState createState() => _ControlListTilesPageState();
}

class _ControlListTilesPageState extends State<ControlListTilesPage> {
  final List<bool?> _checkboxValues = [false, null, true];
  int? _radioValue = 1;
  final List<bool> _switchValues = List.generate(3, (i) => i % 2 == 0);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < _checkboxValues.length; ++i)
          YaruCheckboxListTile(
            value: _checkboxValues[i],
            onChanged: (v) => setState(() => _checkboxValues[i] = v),
            tristate: true,
            title: const Text('YaruCheckboxListTile'),
          ),
        const Divider(),
        for (var i = 0; i < 3; ++i)
          YaruRadioListTile<int>(
            value: i,
            groupValue: _radioValue,
            onChanged: (v) => setState(() => _radioValue = v),
            toggleable: true,
            title: const Text('YaruRadioListTile'),
          ),
        const Divider(),
        for (var i = 0; i < _switchValues.length; ++i)
          YaruSwitchListTile(
            value: _switchValues[i],
            onChanged: (v) => setState(() => _switchValues[i] = v),
            title: const Text('YaruSwitchListTile'),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}
