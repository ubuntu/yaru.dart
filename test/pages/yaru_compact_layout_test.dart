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

      await tester.pumpScaffold(
        YaruCompactLayout(
          length: 4,
          itemBuilder: (context, index, selected) => YaruNavigationRailItem(
            icon: const Icon(YaruIcons.menu),
            label: Text('Item $index'),
            style: variant.value!,
          ),
          pageBuilder: (context, index) => Center(
            child: Text('Page $index'),
          ),
        ),
        themeMode: variant.themeMode,
        size: const Size(500, 300),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(YaruCompactLayout),
        matchesGoldenFile('goldens/yaru_compact_layout-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('compact', YaruNavigationRailStyle.compact),
  ...goldenThemeVariants('labelled', YaruNavigationRailStyle.labelled),
  ...goldenThemeVariants(
    'labelled-extended',
    YaruNavigationRailStyle.labelledExtended,
  ),
});
