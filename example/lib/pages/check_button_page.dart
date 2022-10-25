import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class CheckButtonPage extends StatefulWidget {
  const CheckButtonPage({super.key});

  @override
  _CheckButtonPageState createState() => _CheckButtonPageState();
}

class _CheckButtonPageState extends State<CheckButtonPage> {
  final List<bool?> _values = List.generate(3, (i) => i % 2 == 0);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < _values.length; ++i) ...[
          YaruCheckButton(
            value: _values[i],
            onChanged: (v) => setState(() => _values[i] = v),
            tristate: true,
            title: const Text('YaruCheckButton'),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
