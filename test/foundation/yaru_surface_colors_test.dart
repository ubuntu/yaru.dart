import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/theme.dart';

void main() {
  test('Default window backgrounds match GTK Yaru for every accent', () {
    for (final primary in [
      YaruColors.orange,
      YaruColors.blue,
      YaruColors.purple,
    ]) {
      final light = createYaruLightTheme(primaryColor: primary);
      final dark = createYaruDarkTheme(primaryColor: primary);

      for (final theme in [light, dark]) {
        final expected = theme.brightness == Brightness.light
            ? const Color(0xFFFAFAFA)
            : const Color(0xFF2C2C2C);
        expect(theme.colorScheme.surface, expected);
        expect(theme.colorScheme.surfaceTint, expected);
        expect(theme.scaffoldBackgroundColor, expected);
        expect(theme.canvasColor, expected);
        expect(theme.appBarTheme.backgroundColor, expected);
      }

      // Fixing the dark background must not change light-theme text.
      expect(light.colorScheme.onSurface, YaruColors.jet.scale(lightness: 0.1));
      expect(dark.colorScheme.onSurface, YaruColors.porcelain);
    }
  });

  test('Explicit base colors remain final surface colors', () {
    const custom = Color(0xFF123456);
    final light = createYaruLightTheme(
      primaryColor: YaruColors.orange,
      lightBaseColor: custom,
    );
    final dark = createYaruDarkTheme(
      primaryColor: YaruColors.orange,
      darkBaseColor: custom,
    );
    for (final theme in [light, dark]) {
      expect(theme.colorScheme.surface, custom);
      expect(theme.scaffoldBackgroundColor, custom);
    }
  });

  test('High contrast themes use the same window backgrounds', () {
    expect(
      yaruHighContrastLight.scaffoldBackgroundColor,
      const Color(0xFFFAFAFA),
    );
    expect(
      yaruHighContrastDark.scaffoldBackgroundColor,
      const Color(0xFF2C2C2C),
    );
  });
}
