import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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
          autofocus: variant.hasState(MaterialState.focused),
          isSelected: variant.value?[MaterialState.selected],
          onPressed: variant.hasState(MaterialState.disabled) ? null : () {},
          icon: const Icon(YaruIcons.star_filled),
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.byType(YaruIconButton));
        await tester.pumpAndSettle();
      } else if (variant.hasState(MaterialState.hovered)) {
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
  ...goldenThemeVariants('normal', <MaterialState, bool>{}),
  ...goldenThemeVariants('disabled', {MaterialState.disabled: true}),
  ...goldenThemeVariants('focused', {MaterialState.focused: true}),
  ...goldenThemeVariants('hovered', {MaterialState.hovered: true}),
  ...goldenThemeVariants('pressed', {MaterialState.pressed: true}),
  // selected toggle button
  ...goldenThemeVariants('selected', {MaterialState.selected: true}),
  ...goldenThemeVariants('selected-disabled', {
    MaterialState.selected: true,
    MaterialState.disabled: true,
  }),
  ...goldenThemeVariants('selected-focused', {
    MaterialState.selected: true,
    MaterialState.focused: true,
  }),
  ...goldenThemeVariants('selected-hovered', {
    MaterialState.selected: true,
    MaterialState.hovered: true,
  }),
  ...goldenThemeVariants('selected-pressed', {
    MaterialState.selected: true,
    MaterialState.pressed: true,
  }),
  // unselected toggle button
  ...goldenThemeVariants('unselected', {MaterialState.selected: false}),
  ...goldenThemeVariants('unselected-disabled', {
    MaterialState.selected: false,
    MaterialState.disabled: true,
  }),
  ...goldenThemeVariants('unselected-focused', {
    MaterialState.selected: false,
    MaterialState.focused: true,
  }),
  ...goldenThemeVariants('unselected-hovered', {
    MaterialState.selected: false,
    MaterialState.hovered: true,
  }),
  ...goldenThemeVariants('unselected-pressed', {
    MaterialState.selected: false,
    MaterialState.pressed: true,
  }),
});
