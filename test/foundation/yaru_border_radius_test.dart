import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:yaru_widgets/src/foundation/yaru_border_radius.dart';

void main() {
  group('- BorderRadiusExtension.inner() test -', () {
    test('With no padding', () {
      testBorderRadiusInner(
        BorderRadius.circular(10),
        EdgeInsets.zero,
        BorderRadius.circular(10),
      );
    });

    test('With same side padding', () {
      testBorderRadiusInner(
        BorderRadius.circular(10),
        const EdgeInsets.all(4),
        BorderRadius.circular(8),
      );
    });

    test('With large padding', () {
      testBorderRadiusInner(
        BorderRadius.circular(10),
        const EdgeInsets.all(40),
        BorderRadius.zero,
      );
    });

    test('With different side padding', () {
      testBorderRadiusInner(
        BorderRadius.circular(10),
        const EdgeInsets.fromLTRB(2, 4, 6, 8),
        const BorderRadius.only(
          topLeft: Radius.elliptical(9, 8),
          topRight: Radius.elliptical(7, 8),
          bottomRight: Radius.elliptical(7, 6),
          bottomLeft: Radius.elliptical(9, 6),
        ),
      );
    });

    test('With different corner radius', () {
      testBorderRadiusInner(
        const BorderRadius.only(
          topLeft: Radius.elliptical(2, 4),
          topRight: Radius.elliptical(6, 8),
          bottomLeft: Radius.elliptical(10, 12),
          bottomRight: Radius.elliptical(14, 16),
        ),
        const EdgeInsets.all(2),
        const BorderRadius.only(
          topLeft: Radius.elliptical(1, 3),
          topRight: Radius.elliptical(5, 7),
          bottomLeft: Radius.elliptical(9, 11),
          bottomRight: Radius.elliptical(13, 15),
        ),
      );
    });

    test('With different corner radius and side padding', () {
      testBorderRadiusInner(
        const BorderRadius.only(
          topLeft: Radius.elliptical(10, 12),
          topRight: Radius.elliptical(14, 16),
          bottomLeft: Radius.elliptical(18, 20),
          bottomRight: Radius.elliptical(22, 24),
        ),
        const EdgeInsets.fromLTRB(2, 4, 6, 8),
        const BorderRadius.only(
          topLeft: Radius.elliptical(9, 10),
          topRight: Radius.elliptical(11, 14),
          bottomLeft: Radius.elliptical(17, 16),
          bottomRight: Radius.elliptical(19, 20),
        ),
      );
    });
  });
}

void testBorderRadiusInner(
  BorderRadius initial,
  EdgeInsets padding,
  BorderRadius expected,
) {
  expect(initial.inner(padding), expected);
}
