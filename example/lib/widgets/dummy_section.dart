import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DummySection extends StatelessWidget {
  const DummySection({super.key, this.width});
  final double? width;

  @override
  Widget build(BuildContext context) {
    return YaruSection(
      headline: 'Headline',
      headerWidget: const SizedBox(
        child: YaruCircularProgressIndicator(strokeWidth: 3),
        height: 20,
        width: 20,
      ),
      children: const [
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
