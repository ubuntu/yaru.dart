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
        const YaruCloseButton(),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruCloseButton));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(YaruCloseButton));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruCloseButton),
        matchesGoldenFile('goldens/yaru_close_button-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('normal', <WidgetState>{}),
  ...goldenThemeVariants('hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('pressed', {WidgetState.pressed}),
});
