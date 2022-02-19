import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class CheckBoxRowPage extends StatefulWidget {
  const CheckBoxRowPage({Key? key}) : super(key: key);

  @override
  _CheckBoxRowPageState createState() => _CheckBoxRowPageState();

  static bool searchMatches(String value, BuildContext context) =>
      value.toLowerCase().isNotEmpty &&
      'CheckBoxRow'.toLowerCase().contains(value.toLowerCase());
}

class _CheckBoxRowPageState extends State<CheckBoxRowPage> {
  bool _isCheckBoxSelected = false;

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        YaruCheckboxRow(
          value: _isCheckBoxSelected,
          text: "Text",
          onChanged: (v) {
            setState(() {
              _isCheckBoxSelected = v!;
            });
          },
        )
      ],
    );
  }
}
