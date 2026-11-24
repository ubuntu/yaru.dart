import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaru/yaru.dart';

void main() {
  const sampleItems = [
    SizedBox(key: ValueKey('item_0'), width: 200, height: 200),
    SizedBox(key: ValueKey('item_1'), width: 200, height: 200),
  ];

  Future<void> pumpCarousel(
    WidgetTester tester, {
    List<Widget> children = sampleItems,
    bool navigationControls = true,
    TextDirection textDirection = TextDirection.ltr,
    YaruCarouselController? controller,
    String? previousIconSemanticLabel,
    String? nextIconSemanticLabel,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: Center(
              child: YaruCarousel(
                controller: controller,
                navigationControls: navigationControls,
                previousIconSemanticLabel: previousIconSemanticLabel,
                nextIconSemanticLabel: nextIconSemanticLabel,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('YaruCarousel', () {
    testWidgets('renders navigation controls for multiple items in LTR', (
      tester,
    ) async {
      await pumpCarousel(tester);
      await tester.pump();

      expect(find.byType(YaruCarousel), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNWidgets(2));

      final prevBtn = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_previous),
          matching: find.byType(OutlinedButton),
        ),
      );
      final nextBtn = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_next),
          matching: find.byType(OutlinedButton),
        ),
      );

      expect(prevBtn.onPressed, isNull);
      expect(nextBtn.onPressed, isNotNull);

      await tester.tap(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_next),
          matching: find.byType(OutlinedButton),
        ),
      );
      await tester.pumpAndSettle();

      final prevBtnAfter = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_previous),
          matching: find.byType(OutlinedButton),
        ),
      );
      final nextBtnAfter = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_next),
          matching: find.byType(OutlinedButton),
        ),
      );

      expect(prevBtnAfter.onPressed, isNotNull);
      expect(nextBtnAfter.onPressed, isNull);
    });

    testWidgets('adapts directional navigation controls in RTL context', (
      tester,
    ) async {
      await pumpCarousel(tester, textDirection: TextDirection.rtl);
      await tester.pump();

      expect(find.byType(YaruCarousel), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNWidgets(2));

      final nextBtn = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_previous),
          matching: find.byType(OutlinedButton),
        ),
      );
      final prevBtn = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_next),
          matching: find.byType(OutlinedButton),
        ),
      );

      expect(nextBtn.onPressed, isNotNull);
      expect(prevBtn.onPressed, isNull);

      await tester.tap(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_previous),
          matching: find.byType(OutlinedButton),
        ),
      );
      await tester.pumpAndSettle();

      final nextBtnAfter = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_previous),
          matching: find.byType(OutlinedButton),
        ),
      );
      final prevBtnAfter = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.byIcon(YaruIcons.go_next),
          matching: find.byType(OutlinedButton),
        ),
      );

      expect(nextBtnAfter.onPressed, isNull);
      expect(prevBtnAfter.onPressed, isNotNull);
    });

    testWidgets('hides navigation controls when navigationControls is false', (
      tester,
    ) async {
      await pumpCarousel(tester, navigationControls: false);
      await tester.pump();

      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('supports semantic labels on navigation buttons in LTR', (
      tester,
    ) async {
      await pumpCarousel(
        tester,
        previousIconSemanticLabel: 'Previous slide',
        nextIconSemanticLabel: 'Next slide',
      );
      await tester.pump();

      expect(find.bySemanticsLabel('Next slide'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Next slide'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Previous slide'), findsOneWidget);
    });

    testWidgets('supports semantic labels on navigation buttons in RTL', (
      tester,
    ) async {
      await pumpCarousel(
        tester,
        textDirection: TextDirection.rtl,
        previousIconSemanticLabel: 'Previous slide',
        nextIconSemanticLabel: 'Next slide',
      );
      await tester.pump();

      expect(find.bySemanticsLabel('Next slide'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Next slide'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Previous slide'), findsOneWidget);
    });
  });
}
