import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

extension YaruGoldenTester on WidgetTester {
  Future<void> pumpYaruWidget(
    Widget widget, {
    ThemeMode? themeMode,
    ThemeData? theme,
    ThemeData? darkTheme,
    Size? size,
  }) {
    binding.window.devicePixelRatioTestValue = 1;
    if (size != null) binding.window.physicalSizeTestValue = size;
    return pumpWidget(
      MaterialApp(
        themeMode: themeMode,
        theme: theme ?? yaruLight,
        darkTheme: darkTheme ?? yaruDark,
        home: Scaffold(
          body: Center(child: widget),
        ),
      ),
    );
  }
}
