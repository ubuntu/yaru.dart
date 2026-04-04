import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:yaru/src/themes/common_themes.dart';
import 'package:yaru/src/themes/text_theme.dart';

void main() {
  group('TextTheme', () {
    test('Package does not affect fontFamilyFallback', () {
      var textStyle = createTextTheme(textColor: Colors.black).bodyMedium!;
      textStyle = textStyle.copyWith(fontFamilyFallback: ['Adwaita Sans']);
      expect(
        textStyle.fontFamilyFallback,
        ['Adwaita Sans'],
        reason:
            'If TextStyle.package is non-null, it is incorrectly applied to fontFamilyFallback.\n'
            'Remove TextStyle.package.',
      );
    });
    test('Font can be overridden with copyWith()', () {
      var textStyle = createTextTheme(textColor: Colors.black).bodyMedium!;
      expect(textStyle.fontFamily, 'packages/yaru/Ubuntu');
      textStyle = textStyle.copyWith(fontFamily: 'Adwaita Sans', package: null);
      expect(
        textStyle.fontFamily,
        'Adwaita Sans',
        reason:
            'If TextStyle.package is non-null, it can\'t be overridden with copyWith().\n'
            'Remove TextStyle.package.',
      );
    });

    test('Font is propagated across components', () {
      final theme = createYaruTheme(
        colorScheme: const ColorScheme.light(),
        fontFamily: 'Adwaita Sans',
        fontFamilyFallback: ['Cantarell'],
      );

      final bodyMedium = theme.textTheme.bodyMedium!;
      expect(bodyMedium.fontFamily, 'Adwaita Sans');
      expect(bodyMedium.fontFamilyFallback, ['Cantarell']);

      final appBarStyle = theme.appBarTheme.titleTextStyle!;
      expect(appBarStyle.fontFamily, 'Adwaita Sans');
      expect(appBarStyle.fontFamilyFallback, ['Cantarell']);

      final menuButtonStyle = theme.menuButtonTheme.style!.textStyle!.resolve(
        {},
      )!;
      expect(menuButtonStyle.fontFamily, 'Adwaita Sans');
      expect(menuButtonStyle.fontFamilyFallback, ['Cantarell']);

      final listTileTitle = theme.listTileTheme.titleTextStyle!;
      expect(listTileTitle.fontFamily, 'Adwaita Sans');
      expect(listTileTitle.fontFamilyFallback, ['Cantarell']);

      final listTileSubtitle = theme.listTileTheme.subtitleTextStyle!;
      expect(listTileSubtitle.fontFamily, 'Adwaita Sans');
      expect(listTileSubtitle.fontFamilyFallback, ['Cantarell']);

      final chipStyle = theme.chipTheme.labelStyle!;
      expect(chipStyle.fontFamily, 'Adwaita Sans');
      expect(chipStyle.fontFamilyFallback, ['Cantarell']);
    });
  });
}
