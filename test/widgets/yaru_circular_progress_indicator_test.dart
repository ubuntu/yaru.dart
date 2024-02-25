import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/src/widgets/yaru_circular_progress_indicator.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('- YaruCircularProgressIndicator Test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: YaruCircularProgressIndicator(
            value: 0.5,
            color: Colors.redAccent,
            semanticsLabel: 'Semantic Label',
            semanticsValue: 'Semantic Value',
          ),
        ),
      ),
    );

    final linearProgressIndicatorFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruCircularProgressIndicator && widget.value == 0.5,
    );
    final semanticValueFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruCircularProgressIndicator &&
          widget.semanticsValue == 'Semantic Value',
    );
    final semanticLabelFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruCircularProgressIndicator &&
          widget.semanticsLabel == 'Semantic Label',
    );
    expect(find.byType(YaruCircularProgressIndicator), findsOneWidget);
    expect(linearProgressIndicatorFinder, findsOneWidget);
    expect(semanticLabelFinder, findsOneWidget);
    expect(semanticValueFinder, findsOneWidget);
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      await tester.pumpScaffold(
        YaruCircularProgressIndicator(value: variant.value),
        themeMode: variant.themeMode,
        size: const Size(36, 36),
      );
      await tester.pump();

      await expectLater(
        find.byType(YaruCircularProgressIndicator),
        matchesGoldenFile(
          'goldens/yaru_circular_progress_indicator-${variant.label}.png',
        ),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('indeterminate', null),
  ...goldenThemeVariants('empty', 0.0),
  ...goldenThemeVariants('half', 0.5),
  ...goldenThemeVariants('full', 1.0),
});
