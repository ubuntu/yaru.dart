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
        YaruMasterDetailPage(
          layoutDelegate: const YaruMasterFixedPaneDelegate(
            paneWidth: kYaruMasterDetailBreakpoint / 3,
          ),
          length: 8,
          appBar: AppBar(title: const Text('Master')),
          tileBuilder: (context, index, selected) => YaruMasterTile(
            leading: const Icon(YaruIcons.menu),
            title: Text('Tile $index'),
          ),
          pageBuilder: (context, index) => YaruDetailPage(
            appBar: AppBar(
              title: Text('Detail $index'),
            ),
            body: Center(child: Text('Detail $index')),
          ),
        ),
        themeMode: variant.themeMode,
        size: Size(variant.value!, 480),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(YaruMasterDetailPage),
        matchesGoldenFile(
          'goldens/yaru_master_detail-page-${variant.label}.png',
        ),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );

  testWidgets(
    'controller',
    (tester) async {
      final variant = goldenVariant.currentValue!;
      final controller = ValueNotifier<int>(0);
      await tester.pumpScaffold(
        YaruMasterDetailPage(
          controller: controller,
          layoutDelegate: const YaruMasterFixedPaneDelegate(
            paneWidth: kYaruMasterDetailBreakpoint / 3,
          ),
          length: 8,
          appBar: AppBar(title: const Text('Master')),
          tileBuilder: (context, index, selected) => YaruMasterTile(
            leading: const Icon(YaruIcons.menu),
            title: Text('Tile $index'),
          ),
          pageBuilder: (context, index) => YaruDetailPage(
            appBar: AppBar(
              title: Text('Detail title $index'),
            ),
            body: Center(child: Text('Detail body $index')),
          ),
        ),
        themeMode: variant.themeMode,
        size: Size(variant.value!, 480),
      );

      controller.value = 3;
      await tester.pumpAndSettle();
      if (variant.label.startsWith('portrait')) {
        expect(find.text('Master'), findsNothing);
        expect(find.text('Tile 3'), findsNothing);
      } else if (variant.label.startsWith('landscape')) {
        expect(find.text('Master'), findsOneWidget);
        expect(find.text('Tile 3'), findsOneWidget);
      }
      expect(find.text('Detail title 3'), findsOneWidget);
      expect(find.text('Detail body 3'), findsOneWidget);
    },
    variant: goldenVariant,
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('portrait', kYaruMasterDetailBreakpoint / 2),
  ...goldenThemeVariants('landscape', kYaruMasterDetailBreakpoint),
});
