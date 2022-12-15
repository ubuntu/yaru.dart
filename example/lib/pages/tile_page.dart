import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class TilePage extends StatelessWidget {
  const TilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(kYaruPagePadding),
      itemBuilder: (context, index) => const YaruTile(
        title: Text('Title'),
        trailing: Icon(YaruIcons.information),
        leading: Icon(YaruIcons.music_note),
        subtitle: Text('Subtitle'),
      ),
      itemCount: 20,
    );
  }
}
