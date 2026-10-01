import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;
      final (:page, :width, :itemSize) = variant.value!;

      await tester.pumpScaffold(
        YaruPageIndicator.builder(
          length: 5,
          page: page,
          itemBuilder: itemSize == null
              ? null
              : (index, selectedIndex, _) => YaruPageIndicatorItem(
                  selected: index == selectedIndex,
                  size: itemSize,
                ),
        ),
        themeMode: variant.themeMode,
        size: Size(width, 40),
      );

      await expectLater(
        find.byType(YaruPageIndicator),
        matchesGoldenFile('goldens/yaru_page_indicator-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('first', (page: 0, width: 300.0, itemSize: null)),
  ...goldenThemeVariants('middle', (page: 2, width: 300.0, itemSize: null)),
  ...goldenThemeVariants('last', (page: 4, width: 300.0, itemSize: null)),
  // Too narrow for the dots, so the text fallback is shown.
  ...goldenThemeVariants('text', (page: 2, width: 100.0, itemSize: null)),
  ...goldenThemeVariants('explicit-size', (
    page: 2,
    width: 300.0,
    itemSize: const Size.square(12),
  )),
});
