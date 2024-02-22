import 'package:flutter/material.dart';
import 'package:yaru_widgets/theme.dart';

import 'home.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => YaruTheme(
          data: AppTheme.of(context),
          child: const HomePage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppTheme {
  static YaruThemeData of(BuildContext context) {
    return SharedAppData.getValue(
      context,
      'theme',
      () => const YaruThemeData(),
    );
  }

  static void apply(
    BuildContext context, {
    YaruVariant? variant,
    bool? highContrast,
    ThemeMode? themeMode,
  }) {
    SharedAppData.setValue(
      context,
      'theme',
      AppTheme.of(context).copyWith(
        themeMode: themeMode,
        variant: variant,
        highContrast: highContrast,
      ),
    );
  }
}
