import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class TileList extends StatelessWidget {
  const TileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => const YaruTile(
        title: Text('Title'),
        trailing: Icon(YaruIcons.information),
        leading: Icon(YaruIcons.audio),
        subtitle: Text('Subtitle'),
      ),
      itemCount: 20,
    );
  }
}
