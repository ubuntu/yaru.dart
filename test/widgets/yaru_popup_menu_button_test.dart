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
        YaruPopupMenuButton<dynamic>(
          itemBuilder: (context) => [],
          enabled: !variant.hasState(WidgetState.disabled),
          child: const Text('Menu'),
        ),
        themeMode: variant.themeMode,
        size: const Size(104, 48),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruPopupMenuButton));
        await tester.pump(const Duration(milliseconds: 200));
      } else if (variant.hasState(WidgetState.hovered)) {
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
  ...goldenThemeVariants('normal', <WidgetState>{}),
  ...goldenThemeVariants('disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('hovered', {WidgetState.hovered}),
});
