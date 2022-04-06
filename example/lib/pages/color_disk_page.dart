import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
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
    primaryColor: YaruColors.ubuntuOrange,
  ),
  GlobalTheme(
    lightTheme: yaruSageLight,
    darkTheme: yaruSageDark,
    primaryColor: sageMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yaruBarkLight,
    darkTheme: yaruBarkDark,
    primaryColor: barkMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yaruOliveLight,
    darkTheme: yaruOliveDark,
    primaryColor: oliveMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yaruViridianLight,
    darkTheme: yaruViridianDark,
    primaryColor: viridianMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yaruPrussianGreenLight,
    darkTheme: yaruPrussianGreenDark,
    primaryColor: prussianGreenMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yaruBlueLight,
    darkTheme: yaruBlueDark,
    primaryColor: blueMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yaruPurpleLight,
    darkTheme: yaruPurpleDark,
    primaryColor: purpleMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yarMagentaLight,
    darkTheme: yaruMagentaDark,
    primaryColor: magentaMaterialColor,
  ),
  GlobalTheme(
    lightTheme: yaruRedLight,
    darkTheme: yaruRedDark,
    primaryColor: lightRedMaterialColor,
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
