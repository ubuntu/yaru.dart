import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('with icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruOptionButton(
            onPressed: () {},
            child: const Icon(Icons.flutter_dash),
          ),
        ),
      ),
    );

    expect(
      find.widgetWithIcon(YaruOptionButton, Icons.flutter_dash),
      findsOneWidget,
    );
  });

  testWidgets('with color disk', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruOptionButton.color(
            onPressed: () {},
            color: Colors.red,
            hasFocusBorder: false,
          ),
        ),
      ),
    );

    final box = find.descendant(
      of: find.byType(YaruOptionButton),
      matching: find.byType(DecoratedBox),
    );
    expect(box, findsOneWidget);
    expect(
      tester.widget<DecoratedBox>(box).decoration,
      isA<BoxDecoration>().having((d) => d.color, 'color', Colors.red),
    );
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      // ensure traditional focus highlight
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      await tester.pumpScaffold(
        YaruOptionButton(
          autofocus: variant.hasState(WidgetState.focused),
          onPressed: variant.hasState(WidgetState.disabled) ? null : () {},
          child: const Icon(YaruIcons.gear),
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruOptionButton));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(YaruOptionButton));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruOptionButton),
        matchesGoldenFile('goldens/yaru_option_button-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('normal', <WidgetState>{}),
  ...goldenThemeVariants('disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('focused', {WidgetState.focused}),
  ...goldenThemeVariants('hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('pressed', {WidgetState.pressed}),
});
