import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

Future<void> _pumpDropdown(
  WidgetTester tester, {
  int? selected = 2,
  List<YaruDropdownEntry<int>>? entries,
  ValueChanged<int>? onSelected,
  bool enabled = true,
}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(800, 600);
  addTearDown(tester.view.reset);
  return tester.pumpWidget(
    MaterialApp(
      theme: yaruLight,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            child: YaruDropdown<int>(
              decoration: const InputDecoration(labelText: 'Label'),
              entries:
                  entries ??
                  const [
                    YaruDropdownEntry(value: 1),
                    YaruDropdownEntry(value: 2),
                    YaruDropdownEntry.divider(),
                    YaruDropdownEntry(value: 3, enabled: false),
                  ],
              selected: selected,
              onSelected: enabled ? (onSelected ?? (_) {}) : null,
              itemBuilder: (context, value, _) => Text('Item $value'),
            ),
          ),
        ),
      ),
    ),
  );
}

final _button = find.byType(OutlinedButton);

SemanticsNode _buttonNode(WidgetTester tester) => tester.getSemantics(_button);

MenuItemButton? _focusedMenuItem() => FocusManager
    .instance
    .primaryFocus
    ?.context
    ?.findAncestorWidgetOfExactType<MenuItemButton>();

final _selectedItems = find.semantics.byPredicate(
  (node) => node.flagsCollection.isSelected == Tristate.isTrue,
);

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      await tester.pumpScaffold(
        YaruDropdown<int>(
          autofocus: variant.hasState(WidgetState.focused),
          decoration: const InputDecoration(labelText: 'Label'),
          values: const [1, 2, 3],
          selected: 2,
          onSelected: variant.hasState(WidgetState.disabled) ? null : (_) {},
          itemBuilder: (context, value, _) => Text('Item $value'),
        ),
        themeMode: variant.themeMode,
        size: const Size(200, 56),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(OutlinedButton));
        await tester.pump(const Duration(milliseconds: 200));
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(OutlinedButton));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/yaru_dropdown-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );

  testWidgets('closed button semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpDropdown(tester);

    expect(
      _buttonNode(tester),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasExpandedState: true,
        isExpanded: false,
        label: 'Label, Item 2',
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('open button semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpDropdown(tester);
    await tester.tap(_button);
    await tester.pumpAndSettle();

    expect(
      _buttonNode(tester),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasExpandedState: true,
        isExpanded: true,
        label: 'Label, Item 2',
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('selected, unselected and disabled items', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpDropdown(tester);
    await tester.tap(_button);
    await tester.pumpAndSettle();

    SemanticsNode item(String text) =>
        tester.getSemantics(find.widgetWithText(MenuItemButton, text));

    expect(
      item('Item 2'),
      matchesSemantics(
        label: 'Item 2',
        hasSelectedState: true,
        isSelected: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        isFocused: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    expect(
      item('Item 1'),
      matchesSemantics(
        label: 'Item 1',
        hasSelectedState: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    expect(
      item('Item 3'),
      matchesSemantics(
        label: 'Item 3',
        hasSelectedState: true,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    handle.dispose();
  });

  testWidgets('null onSelected disables the dropdown', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpDropdown(tester, enabled: false);

    expect(
      _buttonNode(tester),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasExpandedState: true,
        label: 'Label, Item 2',
      ),
    );

    await tester.tap(_button, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(MenuItemButton), findsNothing);
    handle.dispose();
  });

  testWidgets('tap selects an item and closes the menu', (tester) async {
    int? selected;
    await _pumpDropdown(tester, onSelected: (v) => selected = v);
    await tester.tap(_button);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Item 1'));
    await tester.pumpAndSettle();

    expect(selected, 1);
    expect(find.byType(MenuItemButton), findsNothing);
  });

  testWidgets('disabled entry cannot be selected', (tester) async {
    int? selected;
    await _pumpDropdown(tester, onSelected: (v) => selected = v);
    await tester.tap(_button);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Item 3'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(selected, isNull);
    expect(find.byType(MenuItemButton), findsWidgets);
  });

  testWidgets('no selection: nothing is marked selected', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpDropdown(tester, selected: null);

    expect(
      _buttonNode(tester),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasExpandedState: true,
        label: 'Label',
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );

    await tester.tap(_button);
    await tester.pumpAndSettle();
    expect(
      find.semantics.byPredicate(
        (node) => node.flagsCollection.isSelected == Tristate.isTrue,
      ),
      findsNothing,
    );
    handle.dispose();
  });

  testWidgets('no selection: first enabled entry gets focus', (tester) async {
    await _pumpDropdown(
      tester,
      selected: null,
      entries: const [
        YaruDropdownEntry.divider(),
        YaruDropdownEntry(value: 1, enabled: false),
        YaruDropdownEntry(value: 2),
        YaruDropdownEntry(value: 3),
      ],
    );
    await tester.tap(_button);
    await tester.pumpAndSettle();

    final focused = FocusManager.instance.primaryFocus!;
    final item = focused.context!
        .findAncestorWidgetOfExactType<MenuItemButton>();
    expect(item, isNotNull);
    expect(
      find.descendant(of: find.byWidget(item!), matching: find.text('Item 2')),
      findsOneWidget,
    );
  });

  testWidgets('selected value not in entries behaves as no selection', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await _pumpDropdown(tester, selected: 42);
    expect(_buttonNode(tester).label, 'Label');

    await tester.tap(_button);
    await tester.pumpAndSettle();

    expect(_selectedItems, findsNothing);
    expect(
      find.descendant(
        of: find.byWidget(_focusedMenuItem()!),
        matching: find.text('Item 1'),
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets(
    'duplicate values: only the first match is selected and focused',
    (tester) async {
      final handle = tester.ensureSemantics();
      await _pumpDropdown(
        tester,
        selected: 1,
        entries: const [
          YaruDropdownEntry(value: 1),
          YaruDropdownEntry(value: 1),
        ],
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();

      final items = find.byType(MenuItemButton);
      expect(tester.takeException(), isNull);
      expect(items, findsNWidgets(2));
      expect(_selectedItems, findsOneWidget);
      expect(
        _focusedMenuItem(),
        same(tester.widget<MenuItemButton>(items.first)),
      );
      handle.dispose();
    },
  );

  testWidgets('button name follows the selected value', (tester) async {
    final handle = tester.ensureSemantics();
    var selected = 2;
    late StateSetter setState;
    await tester.pumpWidget(
      MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, set) {
              setState = set;
              return YaruDropdown<int>(
                decoration: const InputDecoration(labelText: 'Label'),
                values: const [1, 2],
                selected: selected,
                onSelected: (v) => set(() => selected = v),
                itemBuilder: (context, value, _) => Text('Item $value'),
              );
            },
          ),
        ),
      ),
    );
    expect(_buttonNode(tester).label, 'Label, Item 2');

    setState(() => selected = 1);
    await tester.pump();
    expect(_buttonNode(tester).label, 'Label, Item 1');
    handle.dispose();
  });

  testWidgets('button name is not merged with a surrounding list tile', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: YaruListTile(
            title: const Text('Title'),
            subtitle: const Text('Subtitle'),
            trailing: SizedBox(
              width: 240,
              child: YaruDropdown<int>(
                decoration: const InputDecoration(labelText: 'Label'),
                values: const [1],
                selected: 1,
                onSelected: (_) {},
                itemBuilder: (context, value, _) => Text('Item $value'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(_buttonNode(tester).label, 'Label, Item 1');
    handle.dispose();
  });

  testWidgets('null entry can be selected and is marked selected', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    int? selected = 1;
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => YaruDropdown<int?>(
              decoration: const InputDecoration(labelText: 'Label'),
              entries: const [
                YaruDropdownEntry<int?>(value: null, child: Text('None')),
                YaruDropdownEntry<int?>(value: 1),
                YaruDropdownEntry<int?>(value: 2),
              ],
              selected: selected,
              onSelected: (v) => setState(() {
                calls++;
                selected = v;
              }),
              itemBuilder: (context, value, _) => Text('Item $value'),
            ),
          ),
        ),
      ),
    );
    expect(_buttonNode(tester).label, 'Label, Item 1');

    await tester.tap(_button);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, 'None'));
    await tester.pumpAndSettle();

    expect(calls, 1);
    expect(selected, isNull);
    expect(_buttonNode(tester).label, 'Label, None');

    await tester.tap(_button);
    await tester.pumpAndSettle();
    expect(
      tester
          .getSemantics(find.widgetWithText(MenuItemButton, 'None'))
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    handle.dispose();
  });

  testWidgets('semanticValue overrides the value in the name', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: YaruDropdown<int>(
            decoration: const InputDecoration(labelText: 'Label'),
            values: const [1],
            selected: 1,
            semanticValue: 'custom',
            onSelected: (_) {},
            itemBuilder: (context, value, _) => const Icon(Icons.add),
          ),
        ),
      ),
    );
    expect(_buttonNode(tester).label, 'Label, custom');
    handle.dispose();
  });

  testWidgets('no label and no value leaves the button unnamed', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: YaruDropdown<int>(
            values: const [1],
            onSelected: (_) {},
            itemBuilder: (context, value, _) => Text('Item $value'),
          ),
        ),
      ),
    );
    expect(_buttonNode(tester).label, isEmpty);
    handle.dispose();
  });

  testWidgets('menu opens under the button by default', (tester) async {
    await _pumpDropdown(tester);
    await tester.tap(_button);
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.widgetWithText(MenuItemButton, 'Item 1')).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(_button).dy),
    );
  });

  testWidgets('menu width follows the current size of the button', (
    tester,
  ) async {
    late StateSetter setWidth;
    var width = 200.0;
    await tester.pumpWidget(
      MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: StatefulBuilder(
              builder: (context, setState) {
                setWidth = setState;
                return SizedBox(
                  width: width,
                  child: YaruDropdown<int>(
                    values: const [1, 2],
                    selected: 1,
                    onSelected: (_) {},
                    itemBuilder: (context, value, _) => Text('Item $value'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    setWidth(() => width = 400);
    await tester.pumpAndSettle();
    await tester.tap(_button);
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.widgetWithText(MenuItemButton, 'Item 1')).width,
      tester.getSize(_button).width,
    );
  });

  group('focus', () {
    testWidgets('uses a provided focus node and does not dispose it', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: yaruLight,
          home: Scaffold(
            body: YaruDropdown<int>(
              focusNode: node,
              values: const [1, 2],
              selected: 1,
              onSelected: (_) {},
              itemBuilder: (context, value, _) => Text('Item $value'),
            ),
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();
      expect(node.hasPrimaryFocus, isTrue);

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      // Throws if the widget disposed the node it does not own.
      node.requestFocus();
      node.unfocus();
    });

    testWidgets('swapping the focus node moves the listener', (tester) async {
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      Widget build(FocusNode node) => MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: YaruDropdown<int>(
            focusNode: node,
            values: const [1],
            selected: 1,
            onSelected: (_) {},
            itemBuilder: (context, value, _) => Text('Item $value'),
          ),
        ),
      );
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(build(first));
      await tester.pumpWidget(build(second));

      second.requestFocus();
      await tester.pump();
      await tester.pump();
      expect(second.hasPrimaryFocus, isTrue);
      expect(_buttonNode(tester).flagsCollection.isFocused, Tristate.isTrue);
      handle.dispose();
    });

    testWidgets('autofocus focuses the button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: yaruLight,
          home: Scaffold(
            body: YaruDropdown<int>(
              autofocus: true,
              values: const [1],
              selected: 1,
              onSelected: (_) {},
              itemBuilder: (context, value, _) => Text('Item $value'),
            ),
          ),
        ),
      );

      expect(
        FocusManager.instance.primaryFocus!.context!
            .findAncestorWidgetOfExactType<OutlinedButton>(),
        isNotNull,
      );
    });

    testWidgets('outline is highlighted when focused and while open', (
      tester,
    ) async {
      await _pumpDropdown(tester);
      bool isFocused() =>
          tester.widget<InputDecorator>(find.byType(InputDecorator)).isFocused;

      expect(isFocused(), isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(isFocused(), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byType(MenuItemButton), findsWidgets);
      expect(isFocused(), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(isFocused(), isTrue);
    });

    testWidgets('outline stays highlighted in every frame after picking', (
      tester,
    ) async {
      await _pumpDropdown(tester);
      await tester.tap(_button);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 1'));

      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(
          tester.widget<InputDecorator>(find.byType(InputDecorator)).isFocused,
          isTrue,
          reason: 'frame $i',
        );
      }
    });
  });

  group('keyboard', () {
    testWidgets('Enter and Space open, selected item is focused', (
      tester,
    ) async {
      for (final key in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space]) {
        await _pumpDropdown(tester);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(key);
        await tester.pumpAndSettle();

        expect(find.byType(MenuItemButton), findsNWidgets(3));
        final focused = FocusManager.instance.primaryFocus!;
        expect(
          find.descendant(
            of: find.byWidget(
              focused.context!.findAncestorWidgetOfExactType<MenuItemButton>()!,
            ),
            matching: find.text('Item 2'),
          ),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('disabled selected entry: first enabled entry gets focus', (
      tester,
    ) async {
      int? selected;
      await _pumpDropdown(
        tester,
        selected: 2,
        onSelected: (v) => selected = v,
        entries: const [
          YaruDropdownEntry(value: 1),
          YaruDropdownEntry(value: 2, enabled: false),
          YaruDropdownEntry(value: 3),
        ],
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();

      final item = FocusManager.instance.primaryFocus!.context!
          .findAncestorWidgetOfExactType<MenuItemButton>();
      expect(item, isNotNull);
      expect(
        find.descendant(
          of: find.byWidget(item!),
          matching: find.text('Item 1'),
        ),
        findsOneWidget,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, 3);
    });

    testWidgets('arrows navigate, Enter selects', (tester) async {
      int? selected;
      await _pumpDropdown(tester, onSelected: (v) => selected = v);
      await tester.tap(_button);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, 1);
      expect(find.byType(MenuItemButton), findsNothing);
    });

    testWidgets('Escape closes and returns focus to the button', (
      tester,
    ) async {
      await _pumpDropdown(tester);
      await tester.tap(_button);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(MenuItemButton), findsNothing);
      final focused = FocusManager.instance.primaryFocus!;
      expect(
        focused.context!.findAncestorWidgetOfExactType<OutlinedButton>(),
        isNotNull,
      );
    });

    testWidgets('arrow navigation skips disabled entries', (tester) async {
      int? selected;
      await _pumpDropdown(
        tester,
        selected: 1,
        onSelected: (v) => selected = v,
        entries: const [
          YaruDropdownEntry(value: 1),
          YaruDropdownEntry(value: 2, enabled: false),
          YaruDropdownEntry(value: 3),
        ],
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, 3);
    });

    testWidgets('Escape closes the menu when every entry is disabled', (
      tester,
    ) async {
      await _pumpDropdown(
        tester,
        entries: const [
          YaruDropdownEntry(value: 1, enabled: false),
          YaruDropdownEntry(value: 2, enabled: false),
        ],
        selected: 1,
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();
      expect(find.byType(MenuItemButton), findsNWidgets(2));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(MenuItemButton), findsNothing);
    });

    testWidgets('selecting returns focus to the button', (tester) async {
      await _pumpDropdown(tester);
      await tester.tap(_button);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(
        FocusManager.instance.primaryFocus!.context!
            .findAncestorWidgetOfExactType<OutlinedButton>(),
        isNotNull,
      );
    });

    testWidgets('closing by clicking elsewhere keeps focus on the button', (
      tester,
    ) async {
      final other = FocusNode();
      addTearDown(other.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: yaruLight,
          home: Scaffold(
            body: Column(
              children: [
                YaruDropdown<int>(
                  values: const [1, 2],
                  selected: 1,
                  onSelected: (_) {},
                  itemBuilder: (context, value, _) => Text('Item $value'),
                ),
                TextField(focusNode: other),
              ],
            ),
          ),
        ),
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();
      // The first click only dismisses the menu (as with any MenuAnchor).
      await tester.tap(find.byType(TextField), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(MenuItemButton), findsNothing);
      expect(
        FocusManager.instance.primaryFocus!.context!
            .findAncestorWidgetOfExactType<OutlinedButton>(),
        isNotNull,
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(other.hasFocus, isTrue);
    });
  });
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('normal', <WidgetState>{}),
  ...goldenThemeVariants('disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('focused', {WidgetState.focused}),
});
