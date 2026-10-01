import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  Finder dotAt(int index) => find
      .descendant(
        of: find.byType(YaruPageIndicatorItem).at(index),
        matching: find.byType(DecoratedBox),
      )
      .first;

  Future<void> pumpIndicator(WidgetTester tester, Widget indicator) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: indicator)),
      ),
    );
  }

  testWidgets('selected dot is larger than unselected dots', (tester) async {
    await pumpIndicator(tester, YaruPageIndicator(length: 3, page: 1));

    expect(tester.getSize(dotAt(0)), const Size.square(8));
    expect(tester.getSize(dotAt(1)), const Size.square(12));
    expect(tester.getSize(dotAt(2)), const Size.square(8));
  });

  testWidgets('dot size scales with dotSize', (tester) async {
    await pumpIndicator(
      tester,
      YaruPageIndicator(length: 2, page: 0, dotSize: 24),
    );

    expect(tester.getSize(dotAt(0)), const Size.square(24));
    expect(tester.getSize(dotAt(1)), const Size.square(16));
  });

  testWidgets('explicit item size is not changed', (tester) async {
    await pumpIndicator(
      tester,
      YaruPageIndicator.builder(
        length: 2,
        page: 0,
        itemBuilder: (index, selectedIndex, length) => YaruPageIndicatorItem(
          selected: index == selectedIndex,
          size: const Size.square(12),
        ),
      ),
    );

    expect(tester.getSize(dotAt(0)), const Size.square(12));
    expect(tester.getSize(dotAt(1)), const Size.square(12));
  });

  testWidgets('animated item settles at the new size', (tester) async {
    Widget build(bool selected) => MaterialApp(
      home: Center(
        child: SizedBox.square(
          dimension: 12,
          child: YaruPageIndicatorItem(
            selected: selected,
            animationDuration: const Duration(milliseconds: 100),
          ),
        ),
      ),
    );

    await tester.pumpWidget(build(false));
    expect(tester.getSize(dotAt(0)), const Size.square(8));

    await tester.pumpWidget(build(true));
    await tester.pumpAndSettle();
    expect(tester.getSize(dotAt(0)), const Size.square(12));
  });

  testWidgets('default item uses the indicator animation', (tester) async {
    const duration = Duration(milliseconds: 100);
    Widget build(int page) =>
        YaruPageIndicator(length: 2, page: page, animationDuration: duration);

    await pumpIndicator(tester, build(0));
    await pumpIndicator(tester, build(1));
    await tester.pump(duration ~/ 2);

    final midway = tester.getSize(dotAt(1)).width;
    expect(midway, greaterThan(8));
    expect(midway, lessThan(12));

    await tester.pumpAndSettle();
    expect(tester.getSize(dotAt(1)), const Size.square(12));
  });

  testWidgets('whole item slot is the tap target', (tester) async {
    int? tapped;
    await pumpIndicator(
      tester,
      YaruPageIndicator(length: 3, page: 0, onTap: (page) => tapped = page),
    );

    final slot = find.ancestor(
      of: find.byType(YaruPageIndicatorItem).at(2),
      matching: find.byType(GestureDetector),
    );
    final rect = tester.getRect(slot.first);
    expect(rect.size, const Size.square(12));

    // Outside the 8px unselected dot, inside the 12px slot.
    await tester.tapAt(rect.topLeft + const Offset(1, 1));
    expect(tapped, 2);
  });

  testWidgets('carousel indicator distinguishes the selected dot by size', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruCarousel(
            height: 200,
            width: 400,
            children: List.generate(3, (_) => const SizedBox.expand()),
          ),
        ),
      ),
    );

    expect(tester.getSize(dotAt(0)), const Size.square(12));
    expect(tester.getSize(dotAt(1)), const Size.square(8));
    expect(tester.getSize(dotAt(2)), const Size.square(8));
  });

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
