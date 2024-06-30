import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  final List<bool?> _checkboxValues = [false, null, true];
  final List<bool?> _buttonValues = [false, null, true];
  final List<bool?> _listTileValues = [false, null, true];

  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
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
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            const Divider(),
            for (var i = 0; i < _buttonValues.length; ++i) ...[
              YaruCheckButton(
                title: const Text('YaruCheckButton'),
                value: _buttonValues[i],
                onChanged: (v) => setState(() => _buttonValues[i] = v),
                tristate: true,
              ),
              const SizedBox(height: 10),
            ],
            const Divider(),
            for (var i = 0; i < _listTileValues.length; ++i) ...[
              YaruCheckboxListTile(
                value: _listTileValues[i],
                onChanged: (v) => setState(() => _listTileValues[i] = v),
                tristate: true,
                title: const Text('YaruCheckboxListTile'),
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}
