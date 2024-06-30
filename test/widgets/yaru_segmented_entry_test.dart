import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

void main() {
  testWidgets(
      'previous segment input is cleared when navigating to other segment',
      (tester) async {
    final controller = YaruSegmentedEntryController(length: 2);
    final segment1 = YaruStringSegment.fixed(
      length: 4,
      inputFormatter: (_, __, ___) => 'abcd',
    );
    final segment2 = YaruStringSegment.fixed(
      length: 4,
      inputFormatter: (_, __, ___) => 'efgh',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruSegmentedEntry(
            controller: controller,
            segments: [
              segment1,
              segment2,
            ],
            delimiters: const ['/'],
          ),
        ),
      ),
    );

    final finder = find.byType(YaruSegmentedEntry);
    await tester.tap(finder);
    await tester.enterText(finder, '12');
    controller.maybeSelectNextSegment();
    controller.maybeSelectPreviousSegment();
    await tester.enterText(finder, '34');
    expect(segment1.input, '34');
  });

  testWidgets('next segment is selected when current segment input is full',
      (tester) async {
    final controller = YaruSegmentedEntryController(length: 3);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruSegmentedEntry(
            controller: controller,
            segments: [
              YaruStringSegment.fixed(
                length: 2,
                inputFormatter: (_, __, ___) => 'aa',
              ),
              YaruStringSegment(
                minLength: 2,
                maxLength: 4,
                inputFormatter: (_, __, ___) => 'bb',
              ),
              YaruStringSegment.fixed(
                length: 2,
                inputFormatter: (_, __, ___) => 'cc',
              ),
            ],
            delimiters: const ['/', '/'],
          ),
        ),
      ),
    );

    final finder = find.byType(YaruSegmentedEntry);
    await tester.tap(finder);
    expect(controller.index, 0);
    await tester.enterText(finder, 'ab');
    expect(controller.index, 1);
    await tester.enterText(finder, 'abcd');
    expect(controller.index, 2);
  });

  testWidgets('entry is navigable using arrow/tab keyboard keys',
      (tester) async {
    final controller = YaruSegmentedEntryController(length: 3);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruSegmentedEntry(
            controller: controller,
            segments: [
              YaruStringSegment.fixed(
                length: 2,
                inputFormatter: (_, __, ___) => 'aa',
              ),
              YaruStringSegment.fixed(
                length: 2,
                inputFormatter: (_, __, ___) => 'bb',
              ),
              YaruStringSegment.fixed(
                length: 4,
                inputFormatter: (_, __, ___) => 'cccc',
              ),
            ],
            delimiters: const ['/', '/'],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(YaruSegmentedEntry));
    expect(controller.index, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(controller.index, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(controller.index, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(controller.index, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    expect(controller.index, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    expect(controller.index, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    expect(controller.index, 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    expect(controller.index, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    expect(controller.index, 2);
    await tester.sendShiftKeyEvent(LogicalKeyboardKey.tab);
    expect(controller.index, 1);
    await tester.sendShiftKeyEvent(LogicalKeyboardKey.tab);
    expect(controller.index, 0);
  });

  testWidgets('focus is send to previous/next focus node', (tester) async {
    final previousFocusNode = FocusNode();
    final nextFocusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Focus(
                focusNode: previousFocusNode,
                child: const SizedBox.shrink(),
              ),
              YaruSegmentedEntry(
                segments: [
                  YaruStringSegment.fixed(
                    length: 1,
                    inputFormatter: (_, __, ___) => 'a',
                  ),
                ],
                delimiters: const [],
              ),
              Focus(
                focusNode: nextFocusNode,
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(YaruSegmentedEntry));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(previousFocusNode.hasFocus, false);
    expect(nextFocusNode.hasFocus, true);

    await tester.tap(find.byType(YaruSegmentedEntry));
    await tester.pump();
    await tester.sendShiftKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(previousFocusNode.hasFocus, true);
    expect(nextFocusNode.hasFocus, false);
  });

  testWidgets('numeric value is modified using up/down keyboard keys',
      (tester) async {
    final segment = YaruNumericSegment.fixed(
      length: 2,
      initialValue: 0,
      placeholderLetter: 'a',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruSegmentedEntry(
            segments: [segment],
            delimiters: const [],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(YaruSegmentedEntry));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    expect(segment.value, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    expect(segment.value, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    expect(segment.value, -1);
  });

  testWidgets('segment value is cleared using backspace keyboard key',
      (tester) async {
    final controller = YaruSegmentedEntryController(length: 2);
    final segment1 = YaruNumericSegment.fixed(
      length: 2,
      initialValue: 12,
      placeholderLetter: 'a',
    );
    final segment2 = YaruNumericSegment.fixed(
      length: 2,
      initialValue: 12,
      placeholderLetter: 'a',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YaruSegmentedEntry(
            controller: controller,
            segments: [segment1, segment2],
            delimiters: const ['/'],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(YaruSegmentedEntry));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(segment1.value, 12);
    expect(segment2.value, 12);
    expect(controller.index, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    expect(segment1.value, 12);
    expect(segment2.value, null);
    expect(controller.index, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    expect(segment1.value, 12);
    expect(segment2.value, null);
    expect(controller.index, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    expect(segment1.value, null);
    expect(segment2.value, null);
    expect(controller.index, 0);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> sendShiftKeyEvent(
    LogicalKeyboardKey key,
  ) async {
    await sendKeyDownEvent(LogicalKeyboardKey.shift);
    await sendKeyDownEvent(key);
    await sendKeyUpEvent(key);
    await sendKeyUpEvent(LogicalKeyboardKey.shift);
  }
}
