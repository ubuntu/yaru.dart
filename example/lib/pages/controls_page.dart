import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  _ControlsPageState createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  final List<bool?> _checkboxValues = [false, null, true];
  int? _radioValue = 1;
  final List<bool> _switchValues = List.generate(3, (i) => i % 2 == 0);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < _checkboxValues.length; ++i) ...[
          Row(
            children: [
              YaruCheckbox(
                value: _checkboxValues[i],
                onChanged: (v) => setState(() => _checkboxValues[i] = v),
                tristate: true,
              ),
              const SizedBox(width: 10),
              YaruCheckbox(
                value: _checkboxValues[i],
                onChanged: null,
                tristate: true,
              )
            ],
          ),
          const SizedBox(height: 10),
        ],
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
        for (var i = 0; i < _switchValues.length; ++i) ...[
          Row(
            children: [
              YaruSwitch(
                value: _switchValues[i],
                onChanged: (v) => setState(() => _switchValues[i] = v),
              ),
              const SizedBox(width: 10),
              Switch(
                value: _switchValues[i],
                onChanged: null,
              )
            ],
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
