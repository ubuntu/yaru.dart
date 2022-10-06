import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import '../widgets/dummy_section.dart';
import '../widgets/tile_list.dart';

const kMinSectionWidth = 400.0;

class SectionPage extends StatefulWidget {
  const SectionPage({super.key});

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    return const YaruPage(
      children: [
        DummySection(width: kMinSectionWidth),
        YaruSection(
          width: kMinSectionWidth,
          children: [
            TileList(),
          ],
        )
      ],
    );
  }
}
