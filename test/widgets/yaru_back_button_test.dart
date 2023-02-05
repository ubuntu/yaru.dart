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
        const YaruBackButton(),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.byType(YaruBackButton));
        await tester.pumpAndSettle();
      } else if (variant.hasState(MaterialState.hovered)) {
        await tester.hover(find.byType(YaruBackButton));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruBackButton),
        matchesGoldenFile('goldens/yaru_back_button-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('normal', <MaterialState>{}),
  ...goldenThemeVariants('hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('pressed', {MaterialState.pressed}),
});
