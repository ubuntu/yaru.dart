import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

const kMinSectionWidth = 400.0;

class SectionPage extends StatefulWidget {
  const SectionPage({super.key});

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        const DummySection(width: kMinSectionWidth),
        const SizedBox(height: 20),
        YaruSection(
          width: kMinSectionWidth,
          child: Column(
            children: [
              for (var i = 0; i < 10; ++i)
                const YaruTile(
                  title: Text('Title'),
                  trailing: Icon(YaruIcons.information),
                  leading: Icon(YaruIcons.music_note),
                  subtitle: Text('Subtitle'),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class DummySection extends StatelessWidget {
  const DummySection({super.key, this.width});
  final double? width;

  @override
  Widget build(BuildContext context) {
    return YaruSection(
      headline: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Headline'),
          SizedBox(
            child: YaruCircularProgressIndicator(strokeWidth: 3),
            height: 20,
            width: 20,
          )
        ],
      ),
      child: const YaruTile(
        title: Text('Title'),
        trailing: Icon(YaruIcons.information),
        leading: Icon(YaruIcons.music_note),
        subtitle: Text('Subtitle'),
      ),
      width: width,
    );
  }
}
