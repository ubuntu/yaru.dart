import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class RadioButtonPage extends StatefulWidget {
  const RadioButtonPage({super.key});

  @override
  _RadioButtonPageState createState() => _RadioButtonPageState();
}

class _RadioButtonPageState extends State<RadioButtonPage> {
  int? _value = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < 3; ++i) ...[
          YaruRadioButton<int>(
            value: i,
            groupValue: _value,
            onChanged: (v) => setState(() => _value = v),
            toggleable: true,
            title: const Text('YaruRadioButton'),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
