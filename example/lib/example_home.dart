import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'example.dart';
import 'example_model.dart';

class ExampleHome extends StatelessWidget with WatchItMixin {
  const ExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = watchPropertyValue((ExampleModel m) => m.themeMode);
    final yaruVariant = watchPropertyValue((ExampleModel m) => m.yaruVariant);
    final forceHighContrast =
        watchPropertyValue((ExampleModel m) => m.forceHighContrast);

    if (Platform.isLinux) {
      return YaruTheme(
        builder: (context, yaru, child) => _ExampleHome(
          themeMode: themeMode,
          lightTheme: forceHighContrast
              ? yaruHighContrastLight
              : yaruVariant?.theme ?? yaru.theme,
          darkTheme: forceHighContrast
              ? yaruHighContrastDark
              : yaruVariant?.darkTheme ?? yaru.darkTheme,
          highContrastTheme: yaruHighContrastLight,
          highContrastDarkTheme: yaruHighContrastDark,
        ),
      );
    }

    return _ExampleHome(
      themeMode: themeMode,
      lightTheme: forceHighContrast
          ? yaruHighContrastLight
          : yaruVariant?.theme ?? yaruLight,
      darkTheme: forceHighContrast
          ? yaruHighContrastDark
          : yaruVariant?.darkTheme ?? yaruDark,
      highContrastTheme: yaruHighContrastLight,
      highContrastDarkTheme: yaruHighContrastDark,
    );
  }
}

class _ExampleHome extends StatelessWidget {
  const _ExampleHome({
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
    required this.highContrastTheme,
    required this.highContrastDarkTheme,
  });

  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yaru',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: themeMode,
      darkTheme: darkTheme,
      highContrastTheme: highContrastDarkTheme,
      highContrastDarkTheme: highContrastDarkTheme,
      home: const Example(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      ),
    );
  }
}
