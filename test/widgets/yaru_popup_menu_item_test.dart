import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      await tester.pumpScaffold(
        YaruPopupMenuButton(
          child: const Text('Button'),
          itemBuilder: (context) => [
            for (var i = 0; i < 3; ++i)
              YaruCheckedPopupMenuItem(
                checked: variant.hasState(WidgetState.selected),
                enabled: !variant.hasState(WidgetState.disabled),
                child: Text('YaruPopupMenuItem $i'),
              ),
          ],
        ),
        themeMode: variant.themeMode,
        size: const Size(300, 200),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(YaruPopupMenuButton));
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.text('YaruPopupMenuItem 0'));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.text('YaruPopupMenuItem 0'));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/yaru_popup_menu_item-${variant.label}.png',
        ),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('unchecked', <WidgetState>{}),
  ...goldenThemeVariants('unchecked-disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('unchecked-hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('unchecked-pressed', {WidgetState.pressed}),
  ...goldenThemeVariants('checked', {WidgetState.selected}),
  ...goldenThemeVariants('checked-disabled', {
    WidgetState.selected,
    WidgetState.disabled,
  }),
  ...goldenThemeVariants('checked-hovered', {
    WidgetState.selected,
    WidgetState.hovered,
  }),
  ...goldenThemeVariants('checked-pressed', {
    WidgetState.selected,
    WidgetState.pressed,
  }),
});
