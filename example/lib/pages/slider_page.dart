import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({Key? key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  var _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        YaruSliderRow(
          actionLabel: "actionLabel",
          value: _sliderValue,
          min: 0,
          max: 100,
          onChanged: (v) {
            setState(() {
              _sliderValue = v;
            });
          },
        )
      ],
    );
  }
}
