import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/src/widgets/yaru_linear_progress_indicator.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('- YaruLinearProgressIndicator Test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: YaruLinearProgressIndicator(
            value: 0.5,
            color: Colors.redAccent,
            semanticsLabel: 'Semantic Label',
            semanticsValue: 'Semantic Value',
          ),
        ),
      ),
    );

    final linearProgressIndicatorFinder = find.byWidgetPredicate(
      (widget) => widget is YaruLinearProgressIndicator && widget.value == 0.5,
    );
    final semanticValueFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruLinearProgressIndicator &&
          widget.semanticsValue == 'Semantic Value',
    );
    final semanticLabelFinder = find.byWidgetPredicate(
      (widget) =>
          widget is YaruLinearProgressIndicator &&
          widget.semanticsLabel == 'Semantic Label',
    );
    expect(find.byType(YaruLinearProgressIndicator), findsOneWidget);
    expect(linearProgressIndicatorFinder, findsOneWidget);
    expect(semanticLabelFinder, findsOneWidget);
    expect(semanticValueFinder, findsOneWidget);
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      await tester.pumpScaffold(
        YaruLinearProgressIndicator(value: variant.value),
        themeMode: variant.themeMode,
        size: const Size(200, 6),
      );
      await tester.pump();

      await expectLater(
        find.byType(YaruLinearProgressIndicator),
        matchesGoldenFile(
          'goldens/yaru_linear_progress_indicator-${variant.label}.png',
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
