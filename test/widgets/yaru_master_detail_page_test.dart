import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;
      final withSubtitle = variant.value!.withSubtitle;
      final withSpacer = variant.value!.withSpacer;

      await tester.pumpScaffold(
        YaruMasterDetailPage(
          paneLayoutDelegate: const YaruFixedPaneDelegate(
            paneSize: kYaruMasterDetailBreakpoint / 3,
          ),
          length: withSpacer ? 3 : 8,
          appBar: AppBar(title: const Text('Master')),
          tileBuilder: (context, index, selected, maxWidth) {
            if (withSpacer && index == 1) {
              return const Spacer();
            }
            return YaruMasterTile(
              leading: const Icon(YaruIcons.menu),
              title: Text('Tile $index'),
              subtitle: withSubtitle ? Text('Subtitle $index') : null,
            );
          },
          pageBuilder: (context, index) => YaruDetailPage(
            appBar: AppBar(title: Text('Detail $index')),
            body: Center(child: Text('Detail $index')),
          ),
        ),
        themeMode: variant.themeMode,
        size: Size(variant.value!.orientation.width, 480),
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

  testWidgets('controller', (tester) async {
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
          paneLayoutDelegate: const YaruFixedPaneDelegate(
            paneSize: kYaruMasterDetailBreakpoint / 3,
          ),
          appBar: AppBar(title: const Text('Master')),
          tileBuilder: (context, index, selected, maxWidth) => YaruMasterTile(
            leading: const Icon(YaruIcons.menu),
            title: Text('Tile $index'),
          ),
          pageBuilder: (context, index) => YaruDetailPage(
            appBar: AppBar(title: Text('Detail title $index')),
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
  }, variant: orientationVariant);

  testWidgets('availableWidth is updated with screen resize in portrait', (
    tester,
  ) async {
    const variant = Orientation.portrait;
    final initialSize = Size(variant.width, 480);
    const length = 3;

    await tester.pumpScaffold(
      YaruMasterDetailPage(
        length: length,
        paneLayoutDelegate: const YaruFixedPaneDelegate(
          paneSize: kYaruMasterDetailBreakpoint / 3,
        ),
        tileBuilder: (context, index, selected, availableWidth) =>
            YaruMasterTile(title: Text(availableWidth.toString())),
        pageBuilder: (context, index) => const SizedBox(),
      ),
      size: initialSize,
    );

    expect(
      find.text(initialSize.width.toString()),
      findsNWidgets(length),
      reason: 'Available width should match initial screen width',
    );

    final newSize = Size(initialSize.width / 2, initialSize.height);
    tester.view.physicalSize = newSize;
    await tester.pump();

    expect(
      find.text(newSize.width.toString()),
      findsNWidgets(length),
      reason: 'Available width should update to new screen width',
    );
  });

  testWidgets('availableWidth is updated when pane resized in landscape', (
    tester,
  ) async {
    const variant = Orientation.landscape;
    const length = 3;

    const initialPaneSize = kYaruMasterDetailBreakpoint / 3;
    const minPaneSize = initialPaneSize * 0.8;

    await tester.pumpScaffold(
      YaruMasterDetailPage(
        length: length,
        paneLayoutDelegate: const YaruResizablePaneDelegate(
          initialPaneSize: initialPaneSize,
          minPaneSize: minPaneSize,
          minPageSize: 1,
        ),
        tileBuilder: (context, index, selected, availableWidth) =>
            YaruMasterTile(title: Text(availableWidth.toString())),
        pageBuilder: (context, index) => const SizedBox(),
      ),
      size: Size(variant.width, 480),
    );

    expect(
      find.text(initialPaneSize.toString()),
      findsNWidgets(length),
      reason: 'Available width should match initial pane size',
    );

    // Resize pane to minimum
    await tester.drag(
      find.byKey(const ValueKey('YaruPanedView.leftPaneResizer')),
      const Offset(-100, 0),
    );
    await tester.pump();

    expect(
      find.text(minPaneSize.toString()),
      findsNWidgets(length),
      reason: 'Available width should be updated when pane is resized',
    );
  });
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants(
    'portrait',
    YaruMasterDetailGoldenVariant(orientation: Orientation.portrait),
  ),
  ...goldenThemeVariants(
    'landscape',
    YaruMasterDetailGoldenVariant(orientation: Orientation.landscape),
  ),
  ...goldenThemeVariants(
    'portrait-subtitle',
    YaruMasterDetailGoldenVariant(
      orientation: Orientation.portrait,
      withSubtitle: true,
    ),
  ),
  ...goldenThemeVariants(
    'landscape-subtitle',
    YaruMasterDetailGoldenVariant(
      orientation: Orientation.landscape,
      withSubtitle: true,
    ),
  ),
  ...goldenThemeVariants(
    'portrait-spacer',
    YaruMasterDetailGoldenVariant(
      orientation: Orientation.portrait,
      withSpacer: true,
    ),
  ),
  ...goldenThemeVariants(
    'landscape-spacer',
    YaruMasterDetailGoldenVariant(
      orientation: Orientation.landscape,
      withSpacer: true,
    ),
  ),
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

class YaruMasterDetailGoldenVariant {
  YaruMasterDetailGoldenVariant({
    required this.orientation,
    this.withSubtitle = false,
    this.withSpacer = false,
  });

  final Orientation orientation;
  final bool withSubtitle;
  final bool withSpacer;
}
