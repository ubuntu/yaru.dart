import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        Center(
          child: YaruColorPickerButton(
              color: Theme.of(context).primaryColor, onPressed: () {}),
        )
      ],
    );
  }
}
