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
        YaruPopupMenuButton<dynamic>(
          itemBuilder: (context) => [],
          enabled: !variant.hasState(MaterialState.disabled),
          child: const Text('Menu'),
        ),
        themeMode: variant.themeMode,
        size: const Size(104, 48),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.byType(YaruPopupMenuButton));
        await tester.pump(const Duration(milliseconds: 200));
      } else if (variant.hasState(MaterialState.hovered)) {
        await tester.hover(find.byType(YaruPopupMenuButton));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/yaru_popup_menu_button-${variant.label}.png',
        ),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('normal', <MaterialState>{}),
  ...goldenThemeVariants('disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('hovered', {MaterialState.hovered}),
});
