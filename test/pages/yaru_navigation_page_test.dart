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
      final style = styleVariant.currentValue!;
      final controller = YaruPageController(length: 8);

      Future<void> buildNavigationPage({
        int? length,
        int? initialIndex,
        YaruPageController? controller,
      }) {
        return tester.pumpScaffold(
          YaruNavigationPage(
            length: length,
            initialIndex: initialIndex,
            controller: controller,
            itemBuilder: (context, index, selected) => YaruNavigationRailItem(
              icon: const Icon(YaruIcons.menu),
              label: Text('Tile $index'),
              style: style,
            ),
            pageBuilder: (context, index) => YaruDetailPage(
              appBar: AppBar(
                title: Text('Detail title $index'),
              ),
              body: Center(child: Text('Detail body $index')),
            ),
          ),
        );
      }

      void expectDetailPage(int index) {
        for (var i = 0; i < 8; i++) {
          final matcher = i == index ? findsOneWidget : findsNothing;
          expect(find.text('Detail title $i'), matcher);
          expect(find.text('Detail body $i'), matcher);
        }
      }

      await buildNavigationPage(controller: controller);
      await tester.pumpAndSettle();
      expectDetailPage(0);

      controller.index = 0;
      await tester.pumpAndSettle();
      expectDetailPage(0);

      controller.index = 5;
      await tester.pumpAndSettle();
      expectDetailPage(5);

      await buildNavigationPage(length: 3, initialIndex: 1);
      await tester.pumpAndSettle();
      expectDetailPage(1);
    },
    variant: styleVariant,
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

final styleVariant = ValueVariant(YaruNavigationRailStyle.values.toSet());
