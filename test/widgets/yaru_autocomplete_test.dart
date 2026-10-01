import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/widgets.dart';

const _options = ['apple', 'apricot', 'banana'];

Iterable<String> _optionsBuilder(TextEditingValue value) =>
    _options.where((option) => option.contains(value.text));

Future<void> _pumpAutocomplete(
  WidgetTester tester, {
  YaruAutocomplete<String> autocomplete = const YaruAutocomplete<String>(
    optionsBuilder: _optionsBuilder,
  ),
  TextDirection textDirection = TextDirection.ltr,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(body: autocomplete),
      ),
    ),
  );
}

Future<CapturedAccessibilityAnnouncement> _announcementFor(
  WidgetTester tester,
  String text,
  String message,
) async {
  tester.takeAnnouncements();
  await tester.enterText(find.byType(TextFormField), text);
  await tester.pump();
  return tester.takeAnnouncements().singleWhere(
    (announcement) => announcement.message == message,
  );
}

void main() {
  testWidgets('announces default English messages', (tester) async {
    await _pumpAutocomplete(tester);

    var announcement = await _announcementFor(
      tester,
      'ap',
      '2 options available',
    );
    expect(announcement.message, '2 options available');
    expect(announcement.textDirection, TextDirection.ltr);

    announcement = await _announcementFor(tester, 'b', '1 option available');
    expect(announcement.message, '1 option available');

    announcement = await _announcementFor(tester, 'zzz', 'No options found');
    expect(announcement.message, 'No options found');

    announcement = await _announcementFor(tester, '', 'Input cleared');
    expect(announcement.message, 'Input cleared');
  });

  testWidgets('announces custom messages', (tester) async {
    await _pumpAutocomplete(
      tester,
      autocomplete: YaruAutocomplete<String>(
        optionsBuilder: _optionsBuilder,
        clearedAnnouncement: 'cleared',
        noOptionsAnnouncement: 'nothing',
        optionsCountAnnouncement: (count) => 'count $count',
      ),
    );

    expect(
      (await _announcementFor(tester, 'ap', 'count 2')).message,
      'count 2',
    );
    expect(
      (await _announcementFor(tester, 'zzz', 'nothing')).message,
      'nothing',
    );
    expect((await _announcementFor(tester, '', 'cleared')).message, 'cleared');
  });

  testWidgets('uses the ambient text direction by default', (tester) async {
    await _pumpAutocomplete(tester, textDirection: TextDirection.rtl);

    final announcement = await _announcementFor(
      tester,
      'ap',
      '2 options available',
    );
    expect(announcement.textDirection, TextDirection.rtl);
  });

  testWidgets('announcementTextDirection overrides the ambient direction', (
    tester,
  ) async {
    await _pumpAutocomplete(
      tester,
      autocomplete: const YaruAutocomplete<String>(
        optionsBuilder: _optionsBuilder,
        announcementTextDirection: TextDirection.ltr,
      ),
      textDirection: TextDirection.rtl,
    );

    final announcement = await _announcementFor(
      tester,
      'ap',
      '2 options available',
    );
    expect(announcement.textDirection, TextDirection.ltr);
  });

  List<String> announcedMessages(WidgetTester tester) =>
      tester.takeAnnouncements().map((a) => a.message).toList();

  testWidgets('first arrow down announces the first option', (tester) async {
    await _pumpAutocomplete(tester);
    await _announcementFor(tester, 'ap', '2 options available');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(announcedMessages(tester), ['apple']);
  });

  testWidgets('arrow keys announce the highlighted option', (tester) async {
    await _pumpAutocomplete(tester);
    await _announcementFor(tester, 'ap', '2 options available');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    tester.takeAnnouncements();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(announcedMessages(tester), ['apricot']);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(announcedMessages(tester), ['apple']);
  });

  testWidgets('typing again resets arrow navigation', (tester) async {
    await _pumpAutocomplete(tester);
    await _announcementFor(tester, 'ap', '2 options available');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();

    await _announcementFor(tester, 'a', '3 options available');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(announcedMessages(tester), ['apple']);
  });

  testWidgets('selecting an option keeps focus and skips the count', (
    tester,
  ) async {
    String? selected;
    await _pumpAutocomplete(
      tester,
      autocomplete: YaruAutocomplete<String>(
        optionsBuilder: _optionsBuilder,
        onSelected: (option) => selected = option,
      ),
    );
    await _announcementFor(tester, 'ban', '1 option available');

    await tester.tap(find.text('banana'));
    await tester.pump();
    await tester.pump();

    expect(selected, 'banana');
    expect(announcedMessages(tester), isNot(contains('1 option available')));
    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.focusNode.hasFocus, isTrue);
  });

  testWidgets('ignores results from stale async searches', (tester) async {
    final searches = <String, Completer<Iterable<String>>>{};
    await _pumpAutocomplete(
      tester,
      autocomplete: YaruAutocomplete<String>(
        optionsBuilder: (value) =>
            searches.putIfAbsent(value.text, Completer.new).future,
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'a');
    await tester.enterText(find.byType(TextFormField), 'ap');
    tester.takeAnnouncements();

    searches['ap']!.complete(['apple', 'apricot']);
    searches['a']!.complete(_options);
    await tester.pump();

    final messages = announcedMessages(tester);
    expect(messages, contains('2 options available'));
    expect(messages, isNot(contains('3 options available')));
  });

  testWidgets('tab moves focus past the open options list', (tester) async {
    final nextFocus = FocusNode();
    addTearDown(nextFocus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const YaruAutocomplete<String>(optionsBuilder: _optionsBuilder),
              TextButton(
                focusNode: nextFocus,
                onPressed: () {},
                child: const Text('next'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'ap');
    await tester.pump();
    expect(find.text('apple'), findsOne);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(nextFocus.hasFocus, isTrue);
  });
}
