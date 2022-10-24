import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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
                child: Text('YaruPopupMenuItem $i'),
                checked: variant.hasState(MaterialState.selected),
                enabled: !variant.hasState(MaterialState.disabled),
              ),
          ],
        ),
        themeMode: variant.themeMode,
        size: const Size(300, 200),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(YaruPopupMenuButton));
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.text('YaruPopupMenuItem 0'));
        await tester.pumpAndSettle();
      } else if (variant.hasState(MaterialState.hovered)) {
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
  ...goldenThemeVariants('unchecked', <MaterialState>{}),
  ...goldenThemeVariants('unchecked-disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('unchecked-hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('unchecked-pressed', {MaterialState.pressed}),
  ...goldenThemeVariants('checked', {MaterialState.selected}),
  ...goldenThemeVariants('checked-disabled', {
    MaterialState.selected,
    MaterialState.disabled,
  }),
  ...goldenThemeVariants('checked-hovered', {
    MaterialState.selected,
    MaterialState.hovered,
  }),
  ...goldenThemeVariants('checked-pressed', {
    MaterialState.selected,
    MaterialState.pressed,
  }),
});
