import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

void main() {
  group('YaruMonthGrid', () {
    for (final firstDayOfWeek in [0, 1]) {
      testWidgets(
        'orders headers and days with week starting $firstDayOfWeek',
        (tester) async {
          final headers = <int>[];
          final days = <DateTime>[];
          await tester.pumpWidget(
            MaterialApp(
              home: Localizations(
                locale: const Locale('en'),
                delegates: [
                  _MaterialLocalizationsDelegate(firstDayOfWeek),
                  DefaultWidgetsLocalizations.delegate,
                ],
                child: Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: YaruMonthGrid(
                      displayedMonth: DateTime(2024, 2),
                      dayHeaderBuilder: (index) {
                        headers.add(index);
                        return Text('header $index');
                      },
                      dayItemBuilder: (day) {
                        days.add(day);
                        return Text('$day', key: ValueKey(day));
                      },
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();
          expect(headers, List.generate(7, (i) => (firstDayOfWeek + i) % 7));
          final firstDay = DateTime(2024, 1, firstDayOfWeek == 0 ? 28 : 29);
          expect(
            days,
            List.generate(42, (i) => firstDay.add(Duration(days: i))),
          );
          expect(find.byKey(ValueKey(DateTime(2024, 2, 29))), findsOneWidget);
          expect(find.byKey(ValueKey(days.last)), findsOneWidget);
          expect(
            tester.getSize(find.byKey(ValueKey(days.first))),
            const Size(40, 40),
          );
          expect(
            tester.getTopLeft(find.byKey(ValueKey(days.first))).dy,
            tester.getTopLeft(find.text('header $firstDayOfWeek')).dy + 40,
          );
        },
      );
    }

    testWidgets('uses six rows when weekday headers are omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 280,
              height: 240,
              child: YaruMonthGrid(
                displayedMonth: DateTime(2024, 9),
                dayItemBuilder: (day) => Text('$day', key: ValueKey(day)),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsNWidgets(42));
      expect(
        tester.getTopLeft(find.byKey(ValueKey(DateTime(2024, 9, 1)))),
        tester.getTopLeft(find.byType(YaruMonthGrid)),
      );
      expect(
        tester.getSize(find.byKey(ValueKey(DateTime(2024, 10, 12)))),
        const Size(40, 40),
      );
    });
  });

  group('YaruDayPicker', () {
    for (final theme in [ThemeData(), yaruLight]) {
      for (final textScale in [1.0, 2.0]) {
        testWidgets(
          'header fits with ${theme == yaruLight ? 'Yaru' : 'Material'} theme '
          'and text scale $textScale',
          (tester) async {
            await tester.pumpWidget(
              MaterialApp(
                theme: theme,
                home: Scaffold(
                  body: MediaQuery(
                    data: MediaQueryData(
                      textScaler: TextScaler.linear(textScale),
                    ),
                    child: YaruDayPicker(
                      initialDate: DateTime(2024, 9, 15),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2025),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            expect(find.text('Sep 2024'), findsOneWidget);

            await tester.tap(find.byTooltip('Next month'));
            await tester.pumpAndSettle();
            expect(find.text('Oct 2024'), findsOneWidget);
            expect(tester.takeException(), isNull);

            await tester.tap(find.text('Oct 2024'));
            await tester.pumpAndSettle();
            expect(find.byType(PageView), findsNWidgets(2));
            expect(tester.takeException(), isNull);

            await tester.tap(find.text('Oct 2024'));
            await tester.pumpAndSettle();
            expect(find.byType(YaruMonthGrid), findsOneWidget);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }

    Future<void> pumpPicker(
      WidgetTester tester, {
      DateTime? initialDate,
      DateTimeCallback? onDaySelected,
    }) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruDayPicker(
            initialDate: initialDate,
            firstDate: DateTime(2023, 3, 10),
            lastDate: DateTime(2025, 10, 20),
            onDaySelected: onDaySelected,
          ),
        ),
      ),
    );

    for (final (initial, label) in [
      (DateTime(2022), 'Mar 2023'),
      (DateTime(2026), 'Oct 2025'),
    ]) {
      testWidgets('clamps initial date $initial to the date range', (
        tester,
      ) async {
        final selections = <DateTime>[];
        await pumpPicker(
          tester,
          initialDate: initial,
          onDaySelected: selections.add,
        );
        expect(find.text(label), findsOneWidget);
        expect(selections, isEmpty);
      });
    }

    testWidgets('navigates months across year boundaries without selecting', (
      tester,
    ) async {
      final selections = <DateTime>[];
      await pumpPicker(
        tester,
        initialDate: DateTime(2024, 12, 15),
        onDaySelected: selections.add,
      );
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('Jan 2025'), findsOneWidget);
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
      expect(find.text('Dec 2024'), findsOneWidget);
      expect(selections, isEmpty);
    });

    testWidgets(
      'selects a day and navigates when selecting an adjacent month',
      (tester) async {
        final selections = <DateTime>[];
        await pumpPicker(
          tester,
          initialDate: DateTime(2024, 5, 10),
          onDaySelected: selections.add,
        );
        await tester.tap(find.text('15'));
        await tester.pumpAndSettle();
        expect(selections, [DateTime(2024, 5, 15)]);
        await tester.tap(find.text('30').first);
        await tester.pumpAndSettle();
        expect(selections, [DateTime(2024, 5, 15), DateTime(2024, 4, 30)]);
        expect(find.text('Apr 2024'), findsOneWidget);
      },
    );

    testWidgets('selects month and year before returning to day selection', (
      tester,
    ) async {
      final selections = <DateTime>[];
      await pumpPicker(
        tester,
        initialDate: DateTime(2024, 5, 15),
        onDaySelected: selections.add,
      );
      await tester.tap(find.text('May 2024'));
      await tester.pumpAndSettle();
      expect(find.byType(YaruMonthGrid), findsNothing);
      expect(find.byTooltip('Next month'), findsNothing);
      expect(find.byType(PageView), findsNWidgets(2));

      await tester.tap(find.text('June'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      expect(find.text('Jun 2025'), findsOneWidget);
      expect(selections, isEmpty);

      await tester.tap(find.text('Jun 2025'));
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsNothing);
      expect(find.byType(YaruMonthGrid), findsOneWidget);
      await tester.tap(find.text('15'));
      expect(selections, [DateTime(2025, 6, 15)]);
    });

    testWidgets('month and year arrows stop at their page boundaries', (
      tester,
    ) async {
      await pumpPicker(tester, initialDate: DateTime(2024, 12, 15));
      await tester.tap(find.text('Dec 2024'));
      await tester.pumpAndSettle();
      final monthController = tester
          .widget<PageView>(find.byType(PageView).first)
          .controller!;
      final yearController = tester
          .widget<PageView>(find.byType(PageView).last)
          .controller!;

      expect(monthController.page, 11);
      expect(yearController.page, 1);
      await tester.tap(find.byIcon(YaruIcons.pan_down).first);
      await tester.tap(find.byIcon(YaruIcons.pan_down).last);
      await tester.pumpAndSettle();
      expect(monthController.page, 11);
      expect(yearController.page, 2);
      await tester.tap(find.byIcon(YaruIcons.pan_down).last);
      await tester.pumpAndSettle();
      expect(yearController.page, 2);

      // The first up icon is the toggle in the top bar.
      await tester.tap(find.byIcon(YaruIcons.pan_up).at(1));
      await tester.tap(find.byIcon(YaruIcons.pan_up).last);
      await tester.pumpAndSettle();
      expect(monthController.page, 10);
      expect(yearController.page, 1);

      for (var i = 0; i < 12; i++) {
        await tester.tap(find.byIcon(YaruIcons.pan_up).at(1));
        await tester.tap(find.byIcon(YaruIcons.pan_up).last);
        await tester.pumpAndSettle();
      }
      expect(monthController.page, 0);
      expect(yearController.page, 0);
      expect(find.text('Dec 2024'), findsOneWidget);
    });
  });
}

class _MaterialLocalizations extends DefaultMaterialLocalizations {
  const _MaterialLocalizations(this.firstDayOfWeekIndex);

  @override
  final int firstDayOfWeekIndex;
}

class _MaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _MaterialLocalizationsDelegate(this.firstDayOfWeek);

  final int firstDayOfWeek;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      _MaterialLocalizations(firstDayOfWeek);

  @override
  bool shouldReload(_MaterialLocalizationsDelegate old) =>
      firstDayOfWeek != old.firstDayOfWeek;
}
