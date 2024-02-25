import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class TilePage extends StatelessWidget {
  const TilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView.builder(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          itemBuilder: (context, index) => const YaruTile(
            title: Text('Title'),
            trailing: Icon(YaruIcons.information),
            leading: Icon(YaruIcons.music_note),
            subtitle: Text('Subtitle'),
          ),
          itemCount: 20,
        );
      },
    );
  }
}
