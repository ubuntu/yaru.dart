import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';
import 'example_model.dart';
import 'pages/theme_page/src/home/color_disk.dart';

class ExampleYaruVariantPicker extends StatelessWidget with WatchItMixin {
  const ExampleYaruVariantPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final model = di<ExampleModel>();
    final yaruVariant = watchPropertyValue((ExampleModel m) => m.yaruVariant);

    return YaruFocusBorder.primary(
      borderRadius: BorderRadius.circular(100),
      child: PopupMenuButton<Color>(
        tooltip: 'Pick a YaruVariant',
        padding: EdgeInsets.zero,
        icon: Icon(
          YaruIcons.color_select,
          color: Theme.of(context).primaryColor,
        ),
        itemBuilder: (context) {
          return [
            for (final variant in YaruVariant.values) // skip flavors
              PopupMenuItem(
                onTap: () => model.setYaruVariant(variant),
                child: Row(
                  children: [
                    ColorDisk(
                      color: variant.color,
                      selected: variant == yaruVariant,
                    ),
                    Text(variant.name),
                  ],
                ),
              ),
          ];
        },
      ),
    );
  }
}
