import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DummySection extends StatelessWidget {
  final double? width;

  const DummySection({super.key, this.width});

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
        YaruTile(
          title: Text('Title'),
          trailing: Icon(YaruIcons.information),
          leading: Icon(YaruIcons.audio),
          subtitle: Text('Subtitle'),
        ),
      ],
      width: width,
    );
  }
}
