import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

void main() {
  testWidgets(
    'Fixed paned view',
    (tester) async {
      final variant = fixedPaneTestVariant.currentValue!;

      const pane = Key('pane');
      const page = Key('page');

      await tester.pumpPanedView(
        SizedBox(
          width: 500,
          height: 500,
          child: YaruPanedView(
            pane: const SizedBox.expand(key: pane),
            page: const SizedBox.expand(key: page),
            layoutDelegate: variant.layoutDelegate,
          ),
        ),
        textDirection: variant.textDirection,
      );

      final panedViewRect = tester.getRect(find.byType(YaruPanedView));
      final paneRect = tester.getRect(find.byKey(pane));
      final pageRect = tester.getRect(find.byKey(page));

      expect(
        find.byType(
          variant.layoutDelegate.paneSide.isHorizontal
              ? VerticalDivider
              : Divider,
        ),
        findsOneWidget,
      );
      expect(find.byType(GestureDetector), findsNothing);
      switch (variant.expectedSide) {
        case Side.left:
          expect(pageRect.left, greaterThan(paneRect.right));
          break;
        case Side.right:
          expect(paneRect.left, greaterThan(pageRect.right));
          break;
        case Side.top:
          expect(pageRect.top, greaterThan(paneRect.bottom));
          break;
        case Side.bottom:
          expect(paneRect.top, greaterThan(pageRect.bottom));
          break;
      }
      expect(panedViewRect.width, 500);
      expect(paneRect.width, variant.expectedPaneSize.width);
      expect(pageRect.width, variant.expectedPageSize.width);
      expect(panedViewRect.height, 500);
      expect(paneRect.height, variant.expectedPaneSize.height);
      expect(pageRect.height, variant.expectedPageSize.height);
    },
    variant: fixedPaneTestVariant,
  );

  testWidgets(
    'Resizable pane view',
    (tester) async {
      final variant = resizablePaneTestVariant.currentValue!;

      const pane = Key('pane');
      const page = Key('page');
      double? onPaneSizeChangeValue;

      await tester.pumpPanedView(
        SizedBox(
          width: 500,
          height: 500,
          child: YaruPanedView(
            pane: const SizedBox.expand(key: pane),
            page: const SizedBox.expand(key: page),
            layoutDelegate: variant.layoutDelegate,
            onPaneSizeChange: (value) => onPaneSizeChangeValue = value,
          ),
        ),
        textDirection: variant.textDirection,
      );
      await tester.pump();

      var panedViewRect = tester.getRect(find.byType(YaruPanedView));
      var paneRect = tester.getRect(find.byKey(pane));
      var pageRect = tester.getRect(find.byKey(page));

      expect(
        find.byType(
          variant.layoutDelegate.paneSide.isHorizontal
              ? VerticalDivider
              : Divider,
        ),
        findsOneWidget,
      );
      switch (variant.expectedSide) {
        case Side.left:
          expect(pageRect.left, greaterThan(paneRect.right));
          break;
        case Side.right:
          expect(paneRect.left, greaterThan(pageRect.right));
          break;
        case Side.top:
          expect(pageRect.top, greaterThan(paneRect.bottom));
          break;
        case Side.bottom:
          expect(paneRect.top, greaterThan(pageRect.bottom));
          break;
      }
      expect(panedViewRect.width, 500);
      expect(paneRect.width, variant.expectedInitialPaneSize.width);
      expect(pageRect.width, variant.expectedInitialPageSize.width);
      expect(panedViewRect.height, 500);
      expect(paneRect.height, variant.expectedInitialPaneSize.height);
      expect(pageRect.height, variant.expectedInitialPageSize.height);

      await tester.drag(find.byType(GestureDetector), variant.offset);
      await tester.pump();

      panedViewRect = tester.getRect(find.byType(YaruPanedView));
      paneRect = tester.getRect(find.byKey(pane));
      pageRect = tester.getRect(find.byKey(page));

      expect(paneRect.width, variant.expectedResizedPaneSize.width);
      expect(pageRect.width, variant.expectedResizedPageSize.width);
      expect(paneRect.height, variant.expectedResizedPaneSize.height);
      expect(pageRect.height, variant.expectedResizedPageSize.height);
      expect(
        onPaneSizeChangeValue,
        variant.layoutDelegate.paneSide.isHorizontal
            ? variant.expectedResizedPaneSize.width
            : variant.expectedResizedPaneSize.height,
      );
    },
    variant: resizablePaneTestVariant,
  );

  testWidgets(
    'Resizing',
    (tester) async {
      const pane = Key('pane');
      const page = Key('page');

      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(500, 500));

      await tester.pumpPanedView(
        const YaruPanedView(
          pane: SizedBox.expand(key: pane),
          page: SizedBox.expand(key: page),
          layoutDelegate: YaruFixedPaneDelegate(paneSize: 200),
        ),
      );

      var panedViewRect = tester.getRect(find.byType(YaruPanedView));
      var paneRect = tester.getRect(find.byKey(pane));
      var pageRect = tester.getRect(find.byKey(page));

      expect(panedViewRect.width, 500);
      expect(paneRect.width, 200);
      expect(pageRect.width, 299);

      await binding.setSurfaceSize(const Size(200, 500));
      await tester.pump();

      panedViewRect = tester.getRect(find.byType(YaruPanedView));
      paneRect = tester.getRect(find.byKey(pane));
      pageRect = tester.getRect(find.byKey(page));

      expect(panedViewRect.width, 200);
      expect(paneRect.width, 100);
      expect(pageRect.width, 99);
    },
  );
}

enum Side {
  top,
  right,
  bottom,
  left;
}

class FixedPaneTestVariant {
  FixedPaneTestVariant({
    required this.layoutDelegate,
    required this.textDirection,
    required this.expectedSide,
    required this.expectedPaneSize,
    required this.expectedPageSize,
  });

  FixedPaneTestVariant.horizontal({
    required YaruPaneSide paneSide,
    required this.textDirection,
    required this.expectedSide,
  })  : layoutDelegate = YaruFixedPaneDelegate(
          paneSize: 200,
          paneSide: paneSide,
        ),
        expectedPaneSize = const Size(200, 500),
        expectedPageSize = const Size(299, 500);

  FixedPaneTestVariant.vertical({
    required YaruPaneSide paneSide,
    required this.textDirection,
    required this.expectedSide,
  })  : layoutDelegate = YaruFixedPaneDelegate(
          paneSize: 200,
          paneSide: paneSide,
        ),
        expectedPaneSize = const Size(500, 200),
        expectedPageSize = const Size(500, 299);

  final YaruFixedPaneDelegate layoutDelegate;
  final TextDirection textDirection;
  final Side expectedSide;
  final Size expectedPaneSize;
  final Size expectedPageSize;

  @override
  String toString() =>
      'Fixed, Side: ${layoutDelegate.paneSide}, Text direction: $textDirection, Expected side: $expectedSide';
}

class ResizablePaneTestVariant {
  ResizablePaneTestVariant({
    required this.layoutDelegate,
    required this.textDirection,
    required this.expectedSide,
    required this.expectedInitialPaneSize,
    required this.expectedInitialPageSize,
    required this.offset,
    required this.expectedResizedPaneSize,
    required this.expectedResizedPageSize,
  });

  ResizablePaneTestVariant.horizontal({
    required YaruPaneSide paneSide,
    required this.textDirection,
    required this.expectedSide,
    required double offset,
  })  : layoutDelegate = YaruResizablePaneDelegate(
          initialPaneSize: 200,
          minPaneSize: 20,
          minPageSize: 20,
          paneSide: paneSide,
        ),
        expectedInitialPaneSize = const Size(200, 500),
        expectedInitialPageSize = const Size(299, 500),
        offset = Offset(offset, 0),
        expectedResizedPaneSize =
            Size(200 + (expectedSide == Side.left ? offset : -offset), 500),
        expectedResizedPageSize =
            Size(299 - (expectedSide == Side.left ? offset : -offset), 500);

  ResizablePaneTestVariant.vertical({
    required YaruPaneSide paneSide,
    required this.textDirection,
    required this.expectedSide,
    required double offset,
  })  : layoutDelegate = YaruResizablePaneDelegate(
          initialPaneSize: 200,
          minPaneSize: 20,
          minPageSize: 20,
          paneSide: paneSide,
        ),
        expectedInitialPaneSize = const Size(500, 200),
        expectedInitialPageSize = const Size(500, 299),
        offset = Offset(0, offset),
        expectedResizedPaneSize =
            Size(500, 200 + (expectedSide == Side.top ? offset : -offset)),
        expectedResizedPageSize =
            Size(500, 299 - (expectedSide == Side.top ? offset : -offset));

  final YaruResizablePaneDelegate layoutDelegate;
  final TextDirection textDirection;
  final Side expectedSide;
  final Size expectedInitialPaneSize;
  final Size expectedInitialPageSize;
  final Offset offset;
  final Size expectedResizedPaneSize;
  final Size expectedResizedPageSize;

  @override
  String toString() =>
      'Resizable, Side: ${layoutDelegate.paneSide}, Text direction: $textDirection, Expected side: $expectedSide';
}

final fixedPaneTestVariant = ValueVariant({
  FixedPaneTestVariant.horizontal(
    paneSide: YaruPaneSide.start,
    textDirection: TextDirection.ltr,
    expectedSide: Side.left,
  ),
  FixedPaneTestVariant.horizontal(
    paneSide: YaruPaneSide.end,
    textDirection: TextDirection.ltr,
    expectedSide: Side.right,
  ),
  FixedPaneTestVariant.horizontal(
    paneSide: YaruPaneSide.start,
    textDirection: TextDirection.rtl,
    expectedSide: Side.right,
  ),
  FixedPaneTestVariant.horizontal(
    paneSide: YaruPaneSide.end,
    textDirection: TextDirection.rtl,
    expectedSide: Side.left,
  ),
  for (final textDirection in TextDirection.values) ...[
    FixedPaneTestVariant.horizontal(
      paneSide: YaruPaneSide.left,
      textDirection: textDirection,
      expectedSide: Side.left,
    ),
    FixedPaneTestVariant.horizontal(
      paneSide: YaruPaneSide.right,
      textDirection: textDirection,
      expectedSide: Side.right,
    ),
    FixedPaneTestVariant.vertical(
      paneSide: YaruPaneSide.top,
      textDirection: textDirection,
      expectedSide: Side.top,
    ),
    FixedPaneTestVariant.vertical(
      paneSide: YaruPaneSide.bottom,
      textDirection: textDirection,
      expectedSide: Side.bottom,
    ),
  ],
});

final resizablePaneTestVariant = ValueVariant({
  ResizablePaneTestVariant.horizontal(
    paneSide: YaruPaneSide.start,
    textDirection: TextDirection.ltr,
    expectedSide: Side.left,
    offset: 20,
  ),
  ResizablePaneTestVariant.horizontal(
    paneSide: YaruPaneSide.end,
    textDirection: TextDirection.ltr,
    expectedSide: Side.right,
    offset: -20,
  ),
  ResizablePaneTestVariant.horizontal(
    paneSide: YaruPaneSide.start,
    textDirection: TextDirection.rtl,
    expectedSide: Side.right,
    offset: -20,
  ),
  ResizablePaneTestVariant.horizontal(
    paneSide: YaruPaneSide.end,
    textDirection: TextDirection.rtl,
    expectedSide: Side.left,
    offset: 20,
  ),
  for (final textDirection in TextDirection.values) ...[
    ResizablePaneTestVariant.horizontal(
      paneSide: YaruPaneSide.left,
      textDirection: textDirection,
      expectedSide: Side.left,
      offset: 20,
    ),
    ResizablePaneTestVariant.horizontal(
      paneSide: YaruPaneSide.right,
      textDirection: textDirection,
      expectedSide: Side.right,
      offset: -20,
    ),
    ResizablePaneTestVariant.vertical(
      paneSide: YaruPaneSide.top,
      textDirection: textDirection,
      expectedSide: Side.top,
      offset: 20,
    ),
    ResizablePaneTestVariant.vertical(
      paneSide: YaruPaneSide.bottom,
      textDirection: textDirection,
      expectedSide: Side.bottom,
      offset: -20,
    ),
  ],
});

extension YaruPanedViewTester on WidgetTester {
  Future<void> pumpPanedView(
    Widget widget, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: Center(
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
