import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

typedef _TileBuilder = Widget Function(
  FocusNode focusNode,
  VoidCallback? onChanged,
  Widget? control,
);

void main() {
  final builders = <String, _TileBuilder>{
    'switch': (focusNode, onChanged, control) => YaruSwitchListTile(
      value: false,
      onChanged: onChanged == null ? null : (_) => onChanged(),
      title: const Text('Switch'),
      focusNode: focusNode,
      hasFocusBorder: true,
      control: control,
    ),
    'checkbox': (focusNode, onChanged, control) => YaruCheckboxListTile(
      value: false,
      onChanged: onChanged == null ? null : (_) => onChanged(),
      title: const Text('Checkbox'),
      focusNode: focusNode,
      hasFocusBorder: true,
      control: control,
    ),
    'radio': (focusNode, onChanged, control) => YaruRadioListTile<int>(
      value: 1,
      groupValue: 0,
      onChanged: onChanged == null ? null : (_) => onChanged(),
      title: const Text('Radio'),
      focusNode: focusNode,
      hasFocusBorder: true,
      control: control,
    ),
  };

  for (final entry in builders.entries) {
    group(entry.key, () {
      testWidgets('has one tab stop and supports keyboard activation', (
        tester,
      ) async {
        final before = FocusNode();
        final tile = FocusNode();
        final after = FocusNode();
        addTearDown(before.dispose);
        addTearDown(tile.dispose);
        addTearDown(after.dispose);
        var changes = 0;

        await _pumpTile(
          tester,
          before: before,
          after: after,
          child: entry.value(tile, () => changes++, null),
        );
        before.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(tile.hasPrimaryFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();
        expect(changes, 1);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(after.hasPrimaryFocus, isTrue);

        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.pump();
        expect(tile.hasPrimaryFocus, isTrue);
      });

      testWidgets('preserves focus and activation of a custom control', (
        tester,
      ) async {
        final before = FocusNode();
        final tile = FocusNode();
        final control = FocusNode();
        final after = FocusNode();
        addTearDown(before.dispose);
        addTearDown(tile.dispose);
        addTearDown(control.dispose);
        addTearDown(after.dispose);
        var presses = 0;

        await _pumpTile(
          tester,
          before: before,
          after: after,
          child: entry.value(
            tile,
            () {},
            TextButton(
              focusNode: control,
              onPressed: () => presses++,
              child: const Text('Custom control'),
            ),
          ),
        );
        tile.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(control.hasPrimaryFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();
        expect(presses, 1);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(after.hasPrimaryFocus, isTrue);
      });

      testWidgets('skips disabled tiles during keyboard traversal', (
        tester,
      ) async {
        final before = FocusNode();
        final tile = FocusNode();
        final after = FocusNode();
        addTearDown(before.dispose);
        addTearDown(tile.dispose);
        addTearDown(after.dispose);

        await _pumpTile(
          tester,
          before: before,
          after: after,
          child: entry.value(tile, null, null),
        );
        before.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(after.hasPrimaryFocus, isTrue);
      });
    });
  }
}

Future<void> _pumpTile(
  WidgetTester tester, {
  required FocusNode before,
  required FocusNode after,
  required Widget child,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextButton(
              focusNode: before,
              onPressed: () {},
              child: const Text('Before'),
            ),
            child,
            TextButton(
              focusNode: after,
              onPressed: () {},
              child: const Text('After'),
            ),
          ],
        ),
      ),
    ),
  );
}
