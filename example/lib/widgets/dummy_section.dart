import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DummySection extends StatelessWidget {
  final double? width;

  const DummySection({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YaruSection(
      headline: 'Headline',
      headerWidget: SizedBox(
        child: YaruCircularProgressIndicator(strokeWidth: 3),
        height: 20,
        width: 20,
      ),
      children: [
        YaruRow(
          trailingWidget: Text("Trailing Widget"),
          actionWidget: Text("Action Widget"),
          description: Text("Description"),
        ),
      ],
      width: width,
    );
  }
}
