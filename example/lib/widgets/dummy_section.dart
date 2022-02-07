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
        child: CircularProgressIndicator(),
        height: 20,
        width: 20,
      ),
      children: [
        YaruRow(
          enabled: true,
          trailingWidget: Text("Trailing Widget"),
          actionWidget: Text("Action Widget"),
          description: "Description",
        ),
      ],
      width: width,
    );
  }
}
