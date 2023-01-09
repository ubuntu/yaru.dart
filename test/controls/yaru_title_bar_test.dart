import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      final controller = YaruWindowController(state: variant.value!);

      await tester.pumpScaffold(
        YaruWindowTitleBar(controller: controller),
        themeMode: variant.themeMode,
        size: const Size(480, kYaruTitleBarHeight),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(YaruTitleBar),
        matchesGoldenFile('goldens/yaru_title_bar-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants(
    'empty',
    const YaruWindowState(
      active: true,
      title: 'empty',
    ),
  ),
  ...goldenThemeVariants(
    'closable',
    const YaruWindowState(
      active: true,
      closable: true,
      title: 'closable',
    ),
  ),
  ...goldenThemeVariants(
    'maximizable',
    const YaruWindowState(
      active: true,
      minimizable: true,
      maximizable: true,
      closable: true,
      title: 'maximizable',
    ),
  ),
  ...goldenThemeVariants(
    'restorable',
    const YaruWindowState(
      active: true,
      minimizable: true,
      restorable: true,
      closable: true,
      title: 'restorable',
    ),
  ),
  ...goldenThemeVariants(
    'inactive',
    const YaruWindowState(
      active: false,
      minimizable: true,
      maximizable: true,
      closable: true,
      title: 'inactive',
    ),
  ),
});
