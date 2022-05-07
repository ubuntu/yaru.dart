import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_colors/yaru_colors.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/theme.dart';

class ColorDiskPage extends StatefulWidget {
  const ColorDiskPage({Key? key}) : super(key: key);

  @override
  State<ColorDiskPage> createState() => _ColorDiskPageState();
}

class _ColorDiskPageState extends State<ColorDiskPage> {
  @override
  Widget build(BuildContext context) {
    final lightTheme = context.read<LightTheme>();
    final darkTheme = context.read<DarkTheme>();
    return YaruPage(children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var globalTheme in globalThemeList)
              YaruColorDisk(
                onPressed: () {
                  lightTheme.value = globalTheme.lightTheme;
                  darkTheme.value = globalTheme.darkTheme;
                },
                color: globalTheme.primaryColor,
                selected:
                    Theme.of(context).primaryColor == globalTheme.primaryColor,
              ),
          ],
        ),
      )
    ]);
  }
}

final List<GlobalTheme> globalThemeList = [
  GlobalTheme(
    lightTheme: yaruLight,
    darkTheme: yaruDark,
    primaryColor: YaruColors.orange,
  ),
  GlobalTheme(
    lightTheme: yaruSageLight,
    darkTheme: yaruSageDark,
    primaryColor: YaruColors.sage,
  ),
  GlobalTheme(
    lightTheme: yaruBarkLight,
    darkTheme: yaruBarkDark,
    primaryColor: YaruColors.bark,
  ),
  GlobalTheme(
    lightTheme: yaruOliveLight,
    darkTheme: yaruOliveDark,
    primaryColor: YaruColors.olive,
  ),
  GlobalTheme(
    lightTheme: yaruViridianLight,
    darkTheme: yaruViridianDark,
    primaryColor: YaruColors.viridian,
  ),
  GlobalTheme(
    lightTheme: yaruPrussianGreenLight,
    darkTheme: yaruPrussianGreenDark,
    primaryColor: YaruColors.prussianGreen,
  ),
  GlobalTheme(
    lightTheme: yaruBlueLight,
    darkTheme: yaruBlueDark,
    primaryColor: YaruColors.blue,
  ),
  GlobalTheme(
    lightTheme: yaruPurpleLight,
    darkTheme: yaruPurpleDark,
    primaryColor: YaruColors.purple,
  ),
  GlobalTheme(
    lightTheme: yaruMagentaLight,
    darkTheme: yaruMagentaDark,
    primaryColor: YaruColors.magenta,
  ),
  GlobalTheme(
    lightTheme: yaruRedLight,
    darkTheme: yaruRedDark,
    primaryColor: YaruColors.red,
  ),
];

class GlobalTheme {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final MaterialColor primaryColor;

  GlobalTheme({
    required this.lightTheme,
    required this.darkTheme,
    required this.primaryColor,
  });
}
