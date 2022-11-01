import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  _ControlsPageState createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  final List<bool?> _values = [false, null, true];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        for (var i = 0; i < _values.length; ++i) ...[
          Center(
            child: Row(
              children: [
                YaruCheckbox(
                  value: _values[i],
                  onChanged: (v) => setState(() => _values[i] = v),
                  tristate: true,
                ),
                const SizedBox(width: 10),
                YaruCheckbox(
                  value: _values[i],
                  onChanged: null,
                  tristate: true,
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
