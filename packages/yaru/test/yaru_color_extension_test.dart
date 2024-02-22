import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/src/colors.dart';

final Matcher throwsAssertionError = throwsA(isA<AssertionError>());
final Color midColor = const HSLColor.fromAHSL(.5, 180, .5, .5).toColor();

void main() {
  group('Color.scale() test -', () {
    test('With out of range amount', () {
      expect(() => midColor.scale(alpha: -1.1), throwsAssertionError);
      expect(() => midColor.scale(alpha: 1.1), throwsAssertionError);
      expect(() => midColor.scale(hue: -1.1), throwsAssertionError);
      expect(() => midColor.scale(hue: 1.1), throwsAssertionError);
      expect(() => midColor.scale(saturation: -1.1), throwsAssertionError);
      expect(() => midColor.scale(saturation: 1.1), throwsAssertionError);
      expect(() => midColor.scale(lightness: -1.1), throwsAssertionError);
      expect(() => midColor.scale(lightness: 1.1), throwsAssertionError);
    });
    test('With clamped amount', () {
      expect(
        midColor.scale(alpha: -1.0),
        const Color(0x0040bfbf),
      );
      expect(
        midColor.scale(alpha: 1.0),
        const Color(0xff40bfbf),
      );
      expect(
        midColor.scale(hue: -1.0),
        const Color(0x80bf4040),
      );
      expect(
        midColor.scale(hue: 1.0),
        const Color(0x80bf4040),
      );
      expect(
        midColor.scale(saturation: -1.0),
        const Color(0x80808080),
      );
      expect(
        midColor.scale(saturation: 1.0),
        const Color(0x8000ffff),
      );
      expect(
        midColor.scale(lightness: -1.0),
        const Color(0x80000000),
      );
      expect(
        midColor.scale(lightness: 1.0),
        const Color(0x80ffffff),
      );
    });
    test('With medium amount', () {
      expect(
        midColor.scale(alpha: -0.5),
        const Color(0x4040bfbf),
      );
      expect(
        midColor.scale(alpha: 0.5),
        const Color(0xc040bfbf),
      );
      expect(
        midColor.scale(hue: -0.5),
        const Color(0x8080bf40),
      );
      expect(
        midColor.scale(hue: 0.5),
        const Color(0x808040bf),
      );
      expect(
        midColor.scale(saturation: -0.5),
        const Color(0x80609f9f),
      );
      expect(
        midColor.scale(saturation: 0.5),
        const Color(0x8020dfdf),
      );
      expect(
        midColor.scale(lightness: -0.5),
        const Color(0x80206060),
      );
      expect(
        midColor.scale(lightness: 0.5),
        const Color(0x80a0dfdf),
      );
    });
  });

  group('Color.adjust() test -', () {
    test('With out of range amount', () {
      expect(() => midColor.adjust(alpha: -1.1), throwsAssertionError);
      expect(() => midColor.adjust(alpha: 1.1), throwsAssertionError);
      expect(() => midColor.adjust(hue: -360.1), throwsAssertionError);
      expect(() => midColor.adjust(hue: 360.1), throwsAssertionError);
      expect(() => midColor.adjust(saturation: -1.1), throwsAssertionError);
      expect(() => midColor.adjust(saturation: 1.1), throwsAssertionError);
      expect(() => midColor.adjust(lightness: -1.1), throwsAssertionError);
      expect(() => midColor.adjust(lightness: 1.1), throwsAssertionError);
    });
    test('With clamped amount', () {
      expect(
        midColor.adjust(alpha: -1.0),
        const Color(0x0040bfbf),
      );
      expect(
        midColor.adjust(alpha: 1.0),
        const Color(0xff40bfbf),
      );
      expect(
        midColor.adjust(hue: -180),
        const Color(0x80bf4040),
      );
      expect(
        midColor.adjust(hue: 180),
        const Color(0x80bf4040),
      );
      expect(
        midColor.adjust(saturation: -1.0),
        const Color(0x80808080),
      );
      expect(
        midColor.adjust(saturation: 1.0),
        const Color(0x8000ffff),
      );
      expect(
        midColor.adjust(lightness: -1.0),
        const Color(0x80000000),
      );
      expect(
        midColor.adjust(lightness: 1.0),
        const Color(0x80ffffff),
      );
    });
    test('With medium amount', () {
      expect(
        midColor.adjust(alpha: -0.25),
        const Color(0x4040bfbf),
      );
      expect(
        midColor.adjust(alpha: 0.25),
        const Color(0xc040bfbf),
      );
      expect(
        midColor.adjust(hue: -90),
        const Color(0x8080bf40),
      );
      expect(
        midColor.adjust(hue: 90),
        const Color(0x808040bf),
      );
      expect(
        midColor.adjust(saturation: -0.25),
        const Color(0x80609f9f),
      );
      expect(
        midColor.adjust(saturation: 0.25),
        const Color(0x8020dfdf),
      );
      expect(
        midColor.adjust(lightness: -0.25),
        const Color(0x80206060),
      );
      expect(
        midColor.adjust(lightness: 0.25),
        const Color(0x80a0dfdf),
      );
    });
  });

  group('Color.copyWith() test -', () {
    test('With out of range amount', () {
      expect(() => midColor.copyWith(alpha: -1.1), throwsAssertionError);
      expect(() => midColor.copyWith(alpha: 1.1), throwsAssertionError);
      expect(() => midColor.copyWith(hue: -360.1), throwsAssertionError);
      expect(() => midColor.copyWith(hue: 360.1), throwsAssertionError);
      expect(() => midColor.copyWith(saturation: -1.1), throwsAssertionError);
      expect(() => midColor.copyWith(saturation: 1.1), throwsAssertionError);
      expect(() => midColor.copyWith(lightness: -1.1), throwsAssertionError);
      expect(() => midColor.copyWith(lightness: 1.1), throwsAssertionError);
    });
    test('With various amount', () {
      expect(
        midColor.copyWith(alpha: 0.25),
        const Color(0x4040bfbf),
      );
      expect(
        midColor.copyWith(hue: 90),
        const Color(0x8080bf40),
      );
      expect(
        midColor.copyWith(saturation: 0.75),
        const Color(0x8020dfdf),
      );
      expect(
        midColor.copyWith(lightness: 0.75),
        const Color(0x80a0dfdf),
      );
    });
  });

  group('Color.cap() test -', () {
    test('With out of range amount', () {
      expect(() => midColor.cap(alpha: -1.1), throwsAssertionError);
      expect(() => midColor.cap(alpha: 1.1), throwsAssertionError);
      expect(() => midColor.cap(saturation: -1.1), throwsAssertionError);
      expect(() => midColor.cap(saturation: 1.1), throwsAssertionError);
      expect(() => midColor.cap(lightness: -1.1), throwsAssertionError);
      expect(() => midColor.cap(lightness: 1.1), throwsAssertionError);
    });
    test('With various amount', () {
      expect(
        midColor.cap(alpha: 0.25),
        const Color(0x4040bfbf),
      );
      expect(
        midColor.cap(saturation: 0.25),
        const Color(0x80609f9f),
      );
      expect(
        midColor.cap(lightness: 0.25),
        const Color(0x80206060),
      );
    });
  });

  group('Color.capDown() test -', () {
    test('With out of range amount', () {
      expect(() => midColor.capDown(alpha: -1.1), throwsAssertionError);
      expect(() => midColor.capDown(alpha: 1.1), throwsAssertionError);
      expect(() => midColor.capDown(saturation: -1.1), throwsAssertionError);
      expect(() => midColor.capDown(saturation: 1.1), throwsAssertionError);
      expect(() => midColor.capDown(lightness: -1.1), throwsAssertionError);
      expect(() => midColor.capDown(lightness: 1.1), throwsAssertionError);
    });
    test('With various amount', () {
      expect(
        midColor.capDown(alpha: 0.75),
        const Color(0xbf40bfbf),
      );
      expect(
        midColor.capDown(saturation: 0.75),
        const Color(0x8020dfdf),
      );
      expect(
        midColor.capDown(lightness: 0.75),
        const Color(0x80a0dfdf),
      );
    });
  });

  test('hex', () {
    expect(const Color(0x12345678).toHex(), '#12345678');
  });
}
