import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../theme.dart';

class ColorDiskPage extends StatefulWidget {
  const ColorDiskPage({super.key});

  @override
  State<ColorDiskPage> createState() => _ColorDiskPageState();
}

class _ColorDiskPageState extends State<ColorDiskPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final variant in YaruVariant.accents)
            YaruColorDisk(
              onPressed: () => InheritedYaruVariant.apply(context, variant),
              color: variant.color,
              selected: YaruTheme.of(context).variant == variant,
            ),
        ],
      ),
    );
  }
}
