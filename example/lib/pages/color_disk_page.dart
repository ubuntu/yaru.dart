import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import '../theme.dart';

class ColorDiskPage extends StatefulWidget {
  const ColorDiskPage({super.key});

  @override
  State<ColorDiskPage> createState() => _ColorDiskPageState();
}

class _ColorDiskPageState extends State<ColorDiskPage> {
  @override
  Widget build(BuildContext context) {
    final lightTheme = context.read<LightTheme>();
    final darkTheme = context.read<DarkTheme>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var theme in YaruVariant.values)
            YaruColorDisk(
              onPressed: () {
                lightTheme.value = theme.theme;
                darkTheme.value = theme.darkTheme;
              },
              color: theme.color,
              selected: Theme.of(context).primaryColor == theme.color,
            ),
        ],
      ),
    );
  }
}
