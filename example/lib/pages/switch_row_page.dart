import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class SwitchRowPage extends StatefulWidget {
  const SwitchRowPage({Key? key}) : super(key: key);

  @override
  _SwitchRowPageState createState() => _SwitchRowPageState();
}

class _SwitchRowPageState extends State<SwitchRowPage> {
  bool _yaruSwitchEnabled = false;

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        YaruSwitchRow(
          value: _yaruSwitchEnabled,
          onChanged: (v) {
            setState(() {
              _yaruSwitchEnabled = v;
            });
          },
          trailingWidget: Text("Trailing Widget"),
        )
      ],
    );
  }
}
