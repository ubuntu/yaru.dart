import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ToggleButtonsRowPage extends StatefulWidget {
  const ToggleButtonsRowPage({Key? key}) : super(key: key);

  @override
  _ToggleButtonsRowPageState createState() => _ToggleButtonsRowPageState();
}

class _ToggleButtonsRowPageState extends State<ToggleButtonsRowPage> {
  final List<bool> _selectedValues = [false, false];

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        YaruToggleButtonsRow(
          actionLabel: "Action Label",
          labels: ["label1", "label2"],
          onPressed: (v) {
            setState(() {
              _selectedValues[v] = !_selectedValues[v];
            });
          },
          selectedValues: _selectedValues,
          actionDescription: "Action Description",
        )
      ],
    );
  }
}
