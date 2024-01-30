import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

void main() {
  void dateTimeTest(WidgetTester tester, bool time) async {
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
      await tester.enterText(finder, '14');
      await tester.enterText(finder, '30');
      expect(controller.dateTime, DateTime(2001, 12, 31, 14, 30));
    } else {
      expect(controller.dateTime, DateTime(2001, 12, 31));
    }
  }

  testWidgets('date segments are parsed to DateTime', (tester) async {
    dateTimeTest(tester, false);
  });

  testWidgets('date and time segments are parsed to DateTime', (tester) async {
    dateTimeTest(tester, true);
  });

  testWidgets('time segments are parsed to TimeOfDay', (tester) async {
    final controller = YaruTimeEntryController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruTimeEntry(
            controller: controller,
          ),
        ),
      ),
    );

    final finder = find.byType(YaruTimeEntry);
    await tester.tap(finder);
    await tester.enterText(finder, '14');
    await tester.enterText(finder, '30');
    expect(controller.timeOfDay, const TimeOfDay(hour: 14, minute: 30));
  });

  testWidgets('overflow bound segment value update other segments',
      (tester) async {
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
}
