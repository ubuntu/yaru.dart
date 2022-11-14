import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('the checkbox react to taps', (tester) async {
    var clicked = false;

    Widget builder() {
      return MaterialApp(
        home: Scaffold(
          body: YaruWindowControl(
            type: YaruWindowControlType.minimize,
            onTap: () {
              clicked = true;
            },
          ),
        ),
      );
    }

    final checkboxFinder = find.byType(YaruWindowControl);

    await tester.pumpWidget(builder());
    await tester.tap(checkboxFinder);
    expect(clicked, isTrue);
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      late YaruWindowControlType type;

      if (variant.label.startsWith('close')) {
        type = YaruWindowControlType.close;
      } else if (variant.label.startsWith('maximize')) {
        type = YaruWindowControlType.maximize;
      } else if (variant.label.startsWith('restore')) {
        type = YaruWindowControlType.restore;
      } else if (variant.label.startsWith('minimize')) {
        type = YaruWindowControlType.minimize;
      }

      await tester.pumpScaffold(
        YaruWindowControl(
          type: type,
          onTap: variant.hasState(MaterialState.disabled) ? null : () {},
        ),
        themeMode: variant.themeMode,
        size: const Size(24, 24),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.byType(YaruWindowControl));
        await tester.pumpAndSettle();
      } else if (variant.hasState(MaterialState.hovered)) {
        await tester.hover(find.byType(YaruWindowControl));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruWindowControl),
        matchesGoldenFile('goldens/yaru_window_control-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('close', <MaterialState>{}),
  ...goldenThemeVariants('close-disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('close-hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('close-pressed', {MaterialState.pressed}),
  ...goldenThemeVariants('maximize', <MaterialState>{}),
  ...goldenThemeVariants('maximize-disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('maximize-hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('maximize-pressed', {MaterialState.pressed}),
  ...goldenThemeVariants('restore', <MaterialState>{}),
  ...goldenThemeVariants('restore-disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('restore-hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('restore-pressed', {MaterialState.pressed}),
  ...goldenThemeVariants('minimize', <MaterialState>{}),
  ...goldenThemeVariants('minimize-disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('minimize-hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('minimize-pressed', {MaterialState.pressed}),
});
