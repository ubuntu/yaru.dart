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
        YaruNavigationPage(
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
        find.byType(YaruNavigationPage),
        matchesGoldenFile('goldens/yaru_navigation_page-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );

  testWidgets(
    'controller',
    (tester) async {
      final variant = goldenVariant.currentValue!;
      final controller = YaruPageController(length: 8);
      await tester.pumpScaffold(
        YaruNavigationPage(
          controller: controller,
          itemBuilder: (context, index, selected) => YaruNavigationRailItem(
            icon: const Icon(YaruIcons.menu),
            label: Text('Tile $index'),
            style: variant.value!,
          ),
          pageBuilder: (context, index) => YaruDetailPage(
            appBar: AppBar(
              title: Text('Detail title $index'),
            ),
            body: Center(child: Text('Detail body $index')),
          ),
        ),
        themeMode: variant.themeMode,
      );

      controller.index = 3;
      await tester.pumpAndSettle();
      if (variant.label.startsWith('compact')) {
        expect(find.text('Tile 3'), findsNothing);
      } else if (variant.label.startsWith('labelled-extended')) {
        expect(find.text('Tile 3'), findsOneWidget);
      } else if (variant.label.startsWith('labelled')) {
        expect(find.text('Tile 3'), findsOneWidget);
      }
      expect(find.text('Detail title 3'), findsOneWidget);
      expect(find.text('Detail body 3'), findsOneWidget);
    },
    variant: goldenVariant,
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
