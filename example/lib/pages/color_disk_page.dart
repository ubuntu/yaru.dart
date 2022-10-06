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
    return YaruPage(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var theme in themeList)
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
        )
      ],
    );
  }
}

const List<YaruVariant> themeList = [
  YaruVariant.orange,
  YaruVariant.sage,
  YaruVariant.bark,
  YaruVariant.olive,
  YaruVariant.viridian,
  YaruVariant.prussianGreen,
  YaruVariant.blue,
  YaruVariant.purple,
  YaruVariant.magenta,
  YaruVariant.red,
];
