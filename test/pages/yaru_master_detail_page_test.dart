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
        size: Size(variant.value!.width, 480),
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
      final variant = orientationVariant.currentValue!;
      final controller = YaruPageController(length: 8);

      Future<void> buildMasterDetailPage({
        int? length,
        int? initialIndex,
        YaruPageController? controller,
      }) {
        return tester.pumpScaffold(
          YaruMasterDetailPage(
            length: length,
            initialIndex: initialIndex,
            controller: controller,
            layoutDelegate: const YaruMasterFixedPaneDelegate(
              paneWidth: kYaruMasterDetailBreakpoint / 3,
            ),
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
          size: Size(variant.width, 480),
        );
      }

      void expectDetailPage(int index) {
        for (var i = 0; i < 8; i++) {
          final matcher = i == index ? findsOneWidget : findsNothing;
          expect(find.text('Detail title $i'), matcher);
          expect(find.text('Detail body $i'), matcher);
        }
      }

      await buildMasterDetailPage(controller: controller);
      await tester.pumpAndSettle();
      if (variant == Orientation.portrait) {
        expectDetailPage(-1);
      } else {
        expectDetailPage(0);
      }

      controller.index = 0;
      await tester.pumpAndSettle();
      expectDetailPage(0);

      controller.index = 5;
      await tester.pumpAndSettle();
      expectDetailPage(5);

      await buildMasterDetailPage(length: 3, initialIndex: 1);
      await tester.pumpAndSettle();
      expectDetailPage(1);
    },
    variant: orientationVariant,
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('portrait', Orientation.portrait),
  ...goldenThemeVariants('landscape', Orientation.landscape),
});

final orientationVariant = ValueVariant(Orientation.values.toSet());

extension OrientationX on Orientation {
  double get width {
    switch (this) {
      case Orientation.portrait:
        return kYaruMasterDetailBreakpoint / 2;
      case Orientation.landscape:
        return kYaruMasterDetailBreakpoint;
    }
  }
}
