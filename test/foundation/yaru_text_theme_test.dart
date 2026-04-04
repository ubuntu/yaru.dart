import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:yaru/src/themes/text_theme.dart';

void main() {
  group('TextTheme', () {
    test('Package does not affect fontFamilyFallback', () {
      var textStyle = createTextTheme(Colors.black).bodyMedium!;
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
      var textStyle = createTextTheme(Colors.black).bodyMedium!;
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
  });
}
