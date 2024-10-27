import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import '../example_model.dart';

class ColorDiskPage extends StatelessWidget with WatchItMixin {
  const ColorDiskPage({super.key});

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
              onPressed: () => di<ExampleModel>().setYaruVariant(variant),
              color: variant.color,
              selected: watchPropertyValue((ExampleModel m) => m.yaruVariant) ==
                  variant,
            ),
        ],
      ),
    );
  }
}
