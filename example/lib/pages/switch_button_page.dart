import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class SwitchButtonPage extends StatefulWidget {
  const SwitchButtonPage({super.key});

  @override
  _SwitchButtonPageState createState() => _SwitchButtonPageState();
}

class _SwitchButtonPageState extends State<SwitchButtonPage> {
  final _values = List.generate(3, (i) => i % 2 == 0);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < _values.length; ++i) ...[
          YaruSwitchButton(
            value: _values[i],
            onChanged: (v) => setState(() => _values[i] = v),
            title: const Text('YaruSwitchButton'),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
