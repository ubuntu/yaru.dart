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

String? _focusedItemText(WidgetTester tester) {
  final item = _focusedMenuItem();
  if (item == null) return null;
  final text = find.descendant(
    of: find.byWidget(item),
    matching: find.byType(Text),
  );
  return tester.widget<Text>(text.first).data;
}

Matcher _buttonSemantics({required bool expanded}) => matchesSemantics(
  isButton: true,
  hasEnabledState: true,
  isEnabled: true,
  isFocusable: true,
  hasExpandedState: true,
  isExpanded: expanded,
  label: 'Label, Item 2',
  hasTapAction: true,
  hasFocusAction: true,
);

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

  testWidgets('button semantics when closed and when open', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpDropdown(tester);
    expect(_buttonNode(tester), _buttonSemantics(expanded: false));

    await tester.tap(_button);
    await tester.pumpAndSettle();
    expect(_buttonNode(tester), _buttonSemantics(expanded: true));
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

  testWidgets('tapping selects an entry and closes the menu', (tester) async {
    int? selected;
    await _pumpDropdown(tester, onSelected: (v) => selected = v);
    await tester.tap(_button);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Item 3'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(selected, isNull);
    expect(find.byType(MenuItemButton), findsWidgets);

    await tester.tap(find.text('Item 1'));
    await tester.pumpAndSettle();
    expect(selected, 1);
    expect(find.byType(MenuItemButton), findsNothing);
  });

  for (final selected in [null, 42]) {
    testWidgets('selected $selected matches no entry: nothing is selected', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pumpDropdown(
        tester,
        selected: selected,
        entries: const [
          YaruDropdownEntry.divider(),
          YaruDropdownEntry(value: 1, enabled: false),
          YaruDropdownEntry(value: 2),
          YaruDropdownEntry(value: 3),
        ],
      );
      expect(_buttonNode(tester).label, 'Label');

      await tester.tap(_button);
      await tester.pumpAndSettle();

      expect(_selectedItems, findsNothing);
      expect(_focusedItemText(tester), 'Item 2');
      handle.dispose();
    });
  }

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

  testWidgets('selectedEntry is the entry matching selected', (tester) async {
    const entries = [
      YaruDropdownEntry<int?>.divider(),
      YaruDropdownEntry<int?>(value: null, child: Text('None')),
      YaruDropdownEntry<int?>(value: 1),
    ];
    YaruDropdown<int?> dropdown(int? selected) => YaruDropdown<int?>(
      entries: entries,
      selected: selected,
      onSelected: (_) {},
      itemBuilder: (context, value, _) => Text('Item $value'),
    );

    expect(dropdown(1).selectedEntry, entries[2]);
    expect(dropdown(null).selectedEntry, entries[1]);
    expect(dropdown(42).selectedEntry, isNull);
  });

  testWidgets('a long label is truncated and does not overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: yaruLight,
        home: Scaffold(
          body: SizedBox(
            width: 150,
            child: YaruDropdown<int>(
              values: const [1],
              selected: 1,
              onSelected: (_) {},
              itemBuilder: (context, value, _) =>
                  const Text('A very long option label that cannot fit'),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final label = tester.widget<DefaultTextStyle>(
      find
          .ancestor(
            of: find.descendant(of: _button, matching: find.byType(Text)),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(label.style.overflow, TextOverflow.ellipsis);
  });

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

    final menu = find
        .ancestor(
          of: find.widgetWithText(MenuItemButton, 'Item 1'),
          matching: find.byType(Material),
        )
        .first;
    expect(
      tester.getTopLeft(menu).dy - tester.getBottomLeft(_button).dy,
      closeTo(6, 0.01),
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

    testWidgets('focused entry gets a Yaru focus border when enabled', (
      tester,
    ) async {
      for (final enabled in [true, false]) {
        await tester.pumpWidget(
          YaruTheme(
            data: YaruThemeData(focusBorders: enabled),
            child: MaterialApp(
              theme: yaruLight,
              home: Scaffold(
                body: YaruDropdown<int>(
                  values: const [1, 2, 3],
                  selected: 2,
                  onSelected: (_) {},
                  itemBuilder: (context, value, _) => Text('Item $value'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(_button);
        await tester.pumpAndSettle();

        final border = find.ancestor(
          of: find.byWidget(_focusedMenuItem()!),
          matching: find.byType(YaruFocusBorder),
        );
        expect(border, enabled ? findsOneWidget : findsNothing);
        if (enabled) {
          final container = tester.widget<AnimatedContainer>(
            find.descendant(
              of: border,
              matching: find.byType(AnimatedContainer),
            ),
          );
          final decoration = container.foregroundDecoration! as BoxDecoration;
          expect(
            (decoration.border! as Border).top.color,
            yaruLight.colorScheme.primary,
          );
        }
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('focused entry has no background, hovered entry does', (
      tester,
    ) async {
      await _pumpDropdown(tester);
      await tester.tap(_button);
      await tester.pumpAndSettle();

      final overlay = _focusedMenuItem()!.style!.overlayColor!;
      expect(overlay.resolve({WidgetState.focused}), Colors.transparent);
      expect(
        overlay.resolve({WidgetState.focused, WidgetState.hovered}),
        isNull,
      );
    });

    testWidgets('outline follows focus: button, menu, then back on Escape', (
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
      expect(_focusedMenuItem(), isNotNull);
      expect(isFocused(), isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(MenuItemButton), findsNothing);
      expect(isFocused(), isTrue);
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

    testWidgets('a selected entry far down the list is scrolled into view', (
      tester,
    ) async {
      await _pumpDropdown(
        tester,
        selected: 35,
        entries: [
          for (var i = 1; i <= 40; i++) YaruDropdownEntry<int>(value: i),
        ],
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();

      final item = find.byWidget(_focusedMenuItem()!);
      final scrollable = find.ancestor(
        of: item,
        matching: find.byType(Scrollable),
      );
      final view = tester.getRect(scrollable.first);
      final rect = tester.getRect(item);
      expect(_focusedItemText(tester), 'Item 35');
      expect(rect.top, greaterThanOrEqualTo(view.top - 0.5));
      expect(rect.bottom, lessThanOrEqualTo(view.bottom + 0.5));
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

    testWidgets('arrows navigate, Enter selects and focus returns', (
      tester,
    ) async {
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
      expect(
        tester.widget<InputDecorator>(find.byType(InputDecorator)).isFocused,
        isTrue,
      );
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

    testWidgets('Home and End focus the first and last enabled entry', (
      tester,
    ) async {
      await _pumpDropdown(
        tester,
        selected: 2,
        entries: const [
          YaruDropdownEntry<int>(value: 0, enabled: false),
          YaruDropdownEntry<int>(value: 1),
          YaruDropdownEntry<int>(value: 2),
          YaruDropdownEntry<int>.divider(),
          YaruDropdownEntry<int>(value: 4),
          YaruDropdownEntry<int>(value: 5, enabled: false),
        ],
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(_focusedItemText(tester), 'Item 4');

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(_focusedItemText(tester), 'Item 1');
    });

    group('Tab', () {
      Future<void> pumpBetweenFields(
        WidgetTester tester, {
        ValueChanged<int>? onSelected,
        List<YaruDropdownEntry<int>> entries = const [
          YaruDropdownEntry(value: 1),
          YaruDropdownEntry(value: 2),
          YaruDropdownEntry(value: 3),
        ],
        int selected = 2,
      }) {
        return tester.pumpWidget(
          MaterialApp(
            theme: yaruLight,
            home: Scaffold(
              body: Column(
                children: [
                  const TextField(key: ValueKey('before')),
                  YaruDropdown<int>(
                    entries: entries,
                    selected: selected,
                    onSelected: onSelected ?? (_) {},
                    itemBuilder: (context, value, _) => Text('Item $value'),
                  ),
                  const TextField(key: ValueKey('after')),
                ],
              ),
            ),
          ),
        );
      }

      Key? focusedFieldKey() => FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<TextField>()
          ?.key;

      Future<void> tab(WidgetTester tester, {bool shift = false}) async {
        if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.pumpAndSettle();
      }

      Future<void> open(WidgetTester tester) async {
        await tester.tap(_button);
        await tester.pumpAndSettle();
      }

      testWidgets('cycles through the entries and wraps, staying in the menu', (
        tester,
      ) async {
        await pumpBetweenFields(tester);
        await open(tester);
        expect(_focusedItemText(tester), 'Item 2');

        final seen = <String?>[];
        for (final shift in [false, false, false, true, true]) {
          await tab(tester, shift: shift);
          seen.add(_focusedItemText(tester));
          expect(focusedFieldKey(), isNull);
        }

        expect(seen, ['Item 3', 'Item 1', 'Item 2', 'Item 1', 'Item 3']);
        expect(find.byType(MenuItemButton), findsNWidgets(3));
      });

      testWidgets('skips dividers and disabled entries', (tester) async {
        await pumpBetweenFields(
          tester,
          selected: 1,
          entries: const [
            YaruDropdownEntry(value: 1),
            YaruDropdownEntry.divider(),
            YaruDropdownEntry(value: 2, enabled: false),
            YaruDropdownEntry(value: 3),
          ],
        );
        await open(tester);

        await tab(tester);

        expect(_focusedItemText(tester), 'Item 3');
      });

      testWidgets('with every entry disabled it keeps focus on the button', (
        tester,
      ) async {
        await pumpBetweenFields(
          tester,
          selected: 1,
          entries: const [
            YaruDropdownEntry(value: 1, enabled: false),
            YaruDropdownEntry(value: 2, enabled: false),
          ],
        );
        await open(tester);

        await tab(tester);

        expect(find.byType(MenuItemButton), findsNWidgets(2));
        expect(focusedFieldKey(), isNull);
        expect(
          FocusManager.instance.primaryFocus!.context!
              .findAncestorWidgetOfExactType<OutlinedButton>(),
          isNotNull,
        );
      });

      testWidgets('after the menu closes Tab traverses normally', (
        tester,
      ) async {
        await pumpBetweenFields(tester);
        await open(tester);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        await tab(tester);

        expect(find.byType(MenuItemButton), findsNothing);
        expect(focusedFieldKey(), const ValueKey('after'));
      });

      testWidgets('closed dropdown still takes part in normal traversal', (
        tester,
      ) async {
        await pumpBetweenFields(tester);
        await tester.tap(find.byKey(const ValueKey('before')));
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(
          FocusManager.instance.primaryFocus!.context!
              .findAncestorWidgetOfExactType<OutlinedButton>(),
          isNotNull,
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(focusedFieldKey(), const ValueKey('after'));
      });
    });

    group('PageUp and PageDown', () {
      final many = [
        for (var i = 1; i <= 40; i++) YaruDropdownEntry<int>(value: i),
      ];

      int focusedValue(WidgetTester tester) =>
          int.parse(_focusedItemText(tester)!.split(' ').last);

      bool focusedItemIsVisible(WidgetTester tester) {
        final item = find.byWidget(_focusedMenuItem()!);
        final scrollable = Scrollable.of(tester.element(item));
        final itemRect = tester.getRect(item);
        final viewRect = tester.getRect(find.byWidget(scrollable.widget));
        return itemRect.top >= viewRect.top - 0.5 &&
            itemRect.bottom <= viewRect.bottom + 0.5;
      }

      Future<void> press(WidgetTester tester, LogicalKeyboardKey key) async {
        await tester.sendKeyEvent(key);
        await tester.pumpAndSettle();
      }

      Future<void> open(
        WidgetTester tester, {
        required int selected,
        List<YaruDropdownEntry<int>>? entries,
      }) async {
        await _pumpDropdown(
          tester,
          selected: selected,
          entries: entries ?? many,
        );
        await tester.tap(_button);
        await tester.pumpAndSettle();
      }

      testWidgets('jump a page at a time and keep the entry visible', (
        tester,
      ) async {
        await open(tester, selected: 20);

        await press(tester, LogicalKeyboardKey.pageDown);
        expect(focusedValue(tester), inInclusiveRange(22, 39));
        expect(focusedItemIsVisible(tester), isTrue);

        await press(tester, LogicalKeyboardKey.pageUp);
        expect(focusedValue(tester), 20);
        expect(focusedItemIsVisible(tester), isTrue);
      });

      testWidgets('stop at the ends', (tester) async {
        await open(tester, selected: 1);

        await press(tester, LogicalKeyboardKey.pageUp);
        expect(focusedValue(tester), 1);

        for (var i = 0; i < 10; i++) {
          await press(tester, LogicalKeyboardKey.pageDown);
        }
        expect(focusedValue(tester), 40);

        for (var i = 0; i < 10; i++) {
          await press(tester, LogicalKeyboardKey.pageUp);
        }
        expect(focusedValue(tester), 1);
      });

      testWidgets('when every entry fits they go to the last and first', (
        tester,
      ) async {
        await open(
          tester,
          selected: 2,
          entries: const [
            YaruDropdownEntry(value: 1),
            YaruDropdownEntry(value: 2),
            YaruDropdownEntry(value: 3),
          ],
        );

        await press(tester, LogicalKeyboardKey.pageDown);
        expect(focusedValue(tester), 3);

        await press(tester, LogicalKeyboardKey.pageUp);
        expect(focusedValue(tester), 1);
      });

      testWidgets('a page spans the visible rows when entries are disabled', (
        tester,
      ) async {
        await open(
          tester,
          selected: 1,
          entries: [
            for (var i = 1; i <= 80; i++)
              YaruDropdownEntry<int>(value: i, enabled: i.isOdd),
          ],
        );
        final first = tester.element(
          find.widgetWithText(MenuItemButton, 'Item 1'),
        );
        final rows =
            (Scrollable.of(first).position.viewportDimension /
                    first.size!.height)
                .floor();

        await press(tester, LogicalKeyboardKey.pageDown);

        expect(focusedValue(tester) - 1, inInclusiveRange(rows - 1, rows));
        expect(_focusedMenuItem()!.onPressed, isNotNull);
      });
    });

    testWidgets('navigation keys do not change the value', (tester) async {
      final selections = <int>[];
      await _pumpDropdown(
        tester,
        selected: 20,
        onSelected: selections.add,
        entries: [
          for (var i = 1; i <= 40; i++) YaruDropdownEntry<int>(value: i),
        ],
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();

      for (final key in [
        LogicalKeyboardKey.tab,
        LogicalKeyboardKey.home,
        LogicalKeyboardKey.end,
        LogicalKeyboardKey.pageUp,
        LogicalKeyboardKey.pageDown,
      ]) {
        await tester.sendKeyEvent(key);
        await tester.pumpAndSettle();
      }

      expect(selections, isEmpty);
      expect(find.byType(MenuItemButton), findsWidgets);
    });

    testWidgets('entries can shrink while the menu is open', (tester) async {
      final count = ValueNotifier(10);
      addTearDown(count.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: yaruLight,
          home: Scaffold(
            body: ValueListenableBuilder<int>(
              valueListenable: count,
              builder: (context, n, _) => YaruDropdown<int>(
                values: [for (var i = 1; i <= n; i++) i],
                selected: 1,
                onSelected: (_) {},
                itemBuilder: (context, value, _) => Text('Item $value'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(_button);
      await tester.pumpAndSettle();

      count.value = 3;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(_focusedItemText(tester), 'Item 3');
    });

    testWidgets('Escape still dismisses a dialog when the menu is closed', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: yaruLight,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: YaruDropdown<int>(
                      autofocus: true,
                      values: const [1, 2],
                      selected: 1,
                      onSelected: (_) {},
                      itemBuilder: (context, value, _) => Text('Item $value'),
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('normal', <WidgetState>{}),
  ...goldenThemeVariants('disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('focused', {WidgetState.focused}),
});
