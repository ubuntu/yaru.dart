import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      // ensure traditional focus highlight
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      await tester.pumpScaffold(
        YaruIconButton(
          autofocus: variant.hasState(WidgetState.focused),
          isSelected: variant.value?[WidgetState.selected],
          onPressed: variant.hasState(WidgetState.disabled) ? null : () {},
          icon: const Icon(YaruIcons.star_filled),
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruIconButton));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(YaruIconButton));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruIconButton),
        matchesGoldenFile('goldens/yaru_icon_button-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  // normal (non-toggle) button
  ...goldenThemeVariants('normal', <WidgetState, bool>{}),
  ...goldenThemeVariants('disabled', {WidgetState.disabled: true}),
  ...goldenThemeVariants('focused', {WidgetState.focused: true}),
  ...goldenThemeVariants('hovered', {WidgetState.hovered: true}),
  ...goldenThemeVariants('pressed', {WidgetState.pressed: true}),
  // selected toggle button
  ...goldenThemeVariants('selected', {WidgetState.selected: true}),
  ...goldenThemeVariants('selected-disabled', {
    WidgetState.selected: true,
    WidgetState.disabled: true,
  }),
  ...goldenThemeVariants('selected-focused', {
    WidgetState.selected: true,
    WidgetState.focused: true,
  }),
  ...goldenThemeVariants('selected-hovered', {
    WidgetState.selected: true,
    WidgetState.hovered: true,
  }),
  ...goldenThemeVariants('selected-pressed', {
    WidgetState.selected: true,
    WidgetState.pressed: true,
  }),
  // unselected toggle button
  ...goldenThemeVariants('unselected', {WidgetState.selected: false}),
  ...goldenThemeVariants('unselected-disabled', {
    WidgetState.selected: false,
    WidgetState.disabled: true,
  }),
  ...goldenThemeVariants('unselected-focused', {
    WidgetState.selected: false,
    WidgetState.focused: true,
  }),
  ...goldenThemeVariants('unselected-hovered', {
    WidgetState.selected: false,
    WidgetState.hovered: true,
  }),
  ...goldenThemeVariants('unselected-pressed', {
    WidgetState.selected: false,
    WidgetState.pressed: true,
  }),
});
