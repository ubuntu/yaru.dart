import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

void main() {
  Future<void> dateTimeTest(WidgetTester tester, bool time) async {
    final controller = YaruDateTimeEntryController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruDateTimeEntry(
            controller: controller,
            includeTime: time,
            firstDateTime: DateTime(1900),
            lastDateTime: DateTime(2050),
          ),
        ),
      ),
    );

    final finder = find.byType(YaruDateTimeEntry);
    await tester.tap(finder);
    await tester.enterText(finder, '12');
    await tester.enterText(finder, '31');
    await tester.enterText(finder, '2001');

    if (time) {
      await tester.enterText(finder, '11');
      await tester.enterText(finder, '30');
      expect(controller.dateTime, DateTime(2001, 12, 31, 11, 30));
    } else {
      expect(controller.dateTime, DateTime(2001, 12, 31));
    }
  }

  testWidgets('date segments are parsed to DateTime', (tester) async {
    await dateTimeTest(tester, false);
  });

  testWidgets('date and time segments are parsed to DateTime', (tester) async {
    await dateTimeTest(tester, true);
  });

  testWidgets('time segments are parsed to TimeOfDay', (tester) async {
    final controller = YaruTimeEntryController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: YaruTimeEntry(controller: controller)),
      ),
    );

    final finder = find.byType(YaruTimeEntry);
    await tester.tap(finder);
    await tester.enterText(finder, '11');
    await tester.pump();
    await tester.enterText(finder, '30');
    await tester.pump();
    expect(controller.timeOfDay, const TimeOfDay(hour: 11, minute: 30));
  });

  testWidgets('overflow bound segment value update other segments', (
    tester,
  ) async {
    final controller = YaruDateTimeEntryController(
      dateTime: DateTime(1999, 12, 31, 23, 59),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruDateTimeEntry(
            controller: controller,
            firstDateTime: DateTime(1900),
            lastDateTime: DateTime(2050),
          ),
        ),
      ),
    );

    final finder = find.byType(YaruDateTimeEntry);
    await tester.tap(finder);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    expect(controller.dateTime, DateTime(2000, 01, 01, 00, 00));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    expect(controller.dateTime, DateTime(1999, 12, 31, 23, 59));
  });

  testWidgets('out of bound date time are invalided', (tester) async {
    final formKey = GlobalKey<FormState>();
    final controller = YaruDateTimeEntryController();
    var predicate = true;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: YaruDateTimeEntry(
              controller: controller,
              firstDateTime: DateTime(2000),
              lastDateTime: DateTime(2050),
              selectableDateTimePredicate: (dateTime) => predicate,
            ),
          ),
        ),
      ),
    );

    final finder = find.byType(YaruDateTimeEntry);
    await tester.tap(finder);

    controller.dateTime = DateTime(2001);
    expect(formKey.currentState?.validate(), true);

    controller.dateTime = DateTime(1900);
    expect(formKey.currentState?.validate(), false);

    controller.dateTime = DateTime(2060);
    expect(formKey.currentState?.validate(), false);

    predicate = false;
    controller.dateTime = DateTime(2001);
    expect(formKey.currentState?.validate(), false);
  });

  testWidgets('partial fill is invalided', (tester) async {
    final formKey = GlobalKey<FormState>();
    final controller = YaruDateTimeEntryController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: YaruDateTimeEntry(
              controller: controller,
              firstDateTime: DateTime(2000),
              lastDateTime: DateTime(2050),
            ),
          ),
        ),
      ),
    );

    final finder = find.byType(YaruDateTimeEntry);
    await tester.tap(finder);
    await tester.enterText(finder, '01');
    expect(formKey.currentState?.validate(), false);
  });

  testWidgets('accept empty', (tester) async {
    final formKey = GlobalKey<FormState>();
    final controller = YaruDateTimeEntryController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: YaruDateTimeEntry(
              controller: controller,
              acceptEmpty: true,
              firstDateTime: DateTime(2000),
              lastDateTime: DateTime(2050),
            ),
          ),
        ),
      ),
    );

    final finder = find.byType(YaruDateTimeEntry);
    await tester.tap(finder);
    expect(formKey.currentState?.validate(), true);
    await tester.enterText(finder, '01');
    expect(formKey.currentState?.validate(), false);
  });

  testWidgets('out of bound first character selects next segment', (
    tester,
  ) async {
    final controller = YaruDateTimeEntryController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruDateTimeEntry(
            controller: controller,
            firstDateTime: DateTime(2000),
            lastDateTime: DateTime(2050),
          ),
        ),
      ),
    );

    final finder = find.byType(YaruDateTimeEntry);
    await tester.tap(finder);
    await tester.enterText(finder, '2');
    await tester.enterText(finder, '4');
    await tester.enterText(finder, '2000');
    await tester.enterText(finder, '3');
    await tester.enterText(finder, '6');
    expect(controller.dateTime, DateTime(2000, 2, 4, 3, 6));
  });

  testWidgets('segments can\'t go below 0 using keyboard arrow', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruDateTimeEntry(
            controller: YaruDateTimeEntryController(),
            firstDateTime: DateTime(1900),
            lastDateTime: DateTime(2050),
          ),
        ),
      ),
    );

    final finder = find.byType(YaruDateTimeEntry);
    final state = tester.state<YaruDateTimeEntryState>(finder);
    await tester.tap(finder);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    expect(state.monthSegment.value, 0);
  });

  group('calendar popup', () {
    for (final includeTime in [false, true]) {
      testWidgets('selects a date with includeTime=$includeTime', (
        tester,
      ) async {
        final controller = YaruDateTimeEntryController(
          dateTime: DateTime(2024, 5, 10, 14, 35),
        );
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        final changes = <DateTime?>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: YaruDateTimeEntry(
                controller: controller,
                focusNode: focusNode,
                includeTime: includeTime,
                force24HourFormat: true,
                firstDateTime: DateTime(2023),
                lastDateTime: DateTime(2025, 12, 31),
                onChanged: changes.add,
              ),
            ),
          ),
        );

        expect(find.byType(YaruDayPicker), findsNothing);
        await tester.tap(find.byType(YaruDateTimeEntry));
        final state = tester.state<YaruDateTimeEntryState>(
          find.byType(YaruDateTimeEntry),
        );
        state.segmentedEntryController!.selectLastSegment();
        await tester.tap(find.byIcon(YaruIcons.calendar_month));
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);
        final picker = tester.widget<YaruDayPicker>(find.byType(YaruDayPicker));
        expect(picker.initialDate, controller.dateTime);
        expect(picker.firstDate, DateTime(2023));
        expect(picker.lastDate, DateTime(2025, 12, 31));
        expect(find.text('May 2024'), findsOneWidget);

        changes.clear();
        await tester.tap(find.text('15'));
        await tester.pumpAndSettle();
        final expected = includeTime
            ? DateTime(2024, 5, 15, 14, 35)
            : DateTime(2024, 5, 15);
        expect(controller.dateTime, expected);
        expect(changes, isNotEmpty);
        expect(changes, everyElement(expected));
        expect(find.byType(YaruDayPicker), findsNothing);
        expect(state.segmentedEntryController!.index, 0);
        expect(focusNode.hasFocus, isTrue);

        await tester.tap(find.byIcon(YaruIcons.calendar_month));
        await tester.pumpAndSettle();
        expect(
          tester.widget<YaruDayPicker>(find.byType(YaruDayPicker)).initialDate,
          expected,
        );
      });
    }

    testWidgets('selects a date in an initially empty entry', (tester) async {
      final controller = YaruDateTimeEntryController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YaruDateTimeEntry(
              controller: controller,
              force24HourFormat: true,
              firstDateTime: DateTime(2024, 5, 1),
              lastDateTime: DateTime(2024, 5, 31),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(YaruIcons.calendar_month));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(controller.dateTime, DateTime(2024, 5, 15));
      expect(find.byType(YaruDayPicker), findsNothing);
    });

    testWidgets('dismisses on outside tap without changing the value', (
      tester,
    ) async {
      final initial = DateTime(2024, 5, 10);
      final controller = YaruDateTimeEntryController(dateTime: initial);
      final changes = <DateTime?>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YaruDateTimeEntry(
              controller: controller,
              firstDateTime: DateTime(2023),
              lastDateTime: DateTime(2025),
              onChanged: changes.add,
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(YaruIcons.calendar_month));
      await tester.pumpAndSettle();
      expect(find.byType(YaruDayPicker), findsOneWidget);
      changes.clear();
      await tester.tapAt(const Offset(700, 500));
      await tester.pumpAndSettle();
      expect(find.byType(YaruDayPicker), findsNothing);
      expect(controller.dateTime, initial);
      expect(changes, isEmpty);
    });

    testWidgets('time entry only shows the clear button', (tester) async {
      final controller = YaruTimeEntryController(
        timeOfDay: const TimeOfDay(hour: 14, minute: 35),
      );
      final changes = <TimeOfDay?>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YaruTimeEntry(controller: controller, onChanged: changes.add),
          ),
        ),
      );
      expect(find.byIcon(YaruIcons.calendar_month), findsNothing);
      expect(find.byType(OverlayPortal), findsNothing);
      await tester.tap(find.byIcon(YaruIcons.edit_clear));
      await tester.pumpAndSettle();
      expect(controller.timeOfDay, isNull);
      expect(changes, isNotEmpty);
      expect(changes, everyElement(isNull));
    });
  });

  for (final (hour, pm, expectedHour) in [
    ('12', false, 0),
    ('12', true, 12),
    ('01', false, 1),
    ('01', true, 13),
  ]) {
    testWidgets('parses $hour ${pm ? 'PM' : 'AM'} in 12-hour format', (
      tester,
    ) async {
      final controller = YaruTimeEntryController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YaruTimeEntry(
              controller: controller,
              force24HourFormat: false,
            ),
          ),
        ),
      );
      final entry = find.byType(YaruTimeEntry);
      await tester.tap(entry);
      await tester.enterText(entry, hour);
      await tester.enterText(entry, '30');
      if (pm) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      }
      expect(controller.timeOfDay, TimeOfDay(hour: expectedHour, minute: 30));
    });
  }

  testWidgets('calendar uses the replacement focus node', (tester) async {
    final controller = YaruDateTimeEntryController(
      dateTime: DateTime(2024, 5, 10),
    );
    final firstFocusNode = FocusNode();
    final secondFocusNode = FocusNode();
    addTearDown(firstFocusNode.dispose);
    addTearDown(secondFocusNode.dispose);

    Future<void> pumpEntry(FocusNode? focusNode) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruDateTimeEntry(
            controller: controller,
            focusNode: focusNode,
            firstDateTime: DateTime(2023),
            lastDateTime: DateTime(2025),
          ),
        ),
      ),
    );

    await pumpEntry(null);
    await pumpEntry(firstFocusNode);
    firstFocusNode.requestFocus();
    await tester.pump();
    expect(firstFocusNode.hasFocus, isTrue);
    await pumpEntry(secondFocusNode);
    await tester.tap(find.byIcon(YaruIcons.calendar_month));
    await tester.pumpAndSettle();
    expect(firstFocusNode.hasFocus, isFalse);
    expect(secondFocusNode.hasFocus, isTrue);
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    expect(secondFocusNode.hasFocus, isTrue);
    expect(controller.dateTime, DateTime(2024, 5, 15));

    await tester.pumpWidget(const SizedBox.shrink());
    void listener() {}
    firstFocusNode.addListener(listener);
    secondFocusNode.addListener(listener);
    firstFocusNode.removeListener(listener);
    secondFocusNode.removeListener(listener);
    expect(tester.takeException(), isNull);
  });
}
