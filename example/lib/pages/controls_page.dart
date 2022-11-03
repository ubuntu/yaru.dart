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
      ],
    );
  }
}
