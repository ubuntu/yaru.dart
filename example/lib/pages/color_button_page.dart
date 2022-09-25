import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ColorButtonPage extends StatefulWidget {
  const ColorButtonPage({Key? key}) : super(key: key);

  @override
  _ColorButtonPageState createState() => _ColorButtonPageState();
}

class _ColorButtonPageState extends State<ColorButtonPage> {
  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        Center(
          child: YaruColorButton(
              color: Theme.of(context).primaryColor, onPressed: () {}),
        )
      ],
    );
  }
}
