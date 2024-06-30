import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('contains checkbox, labels and secondary', (tester) async {
    Widget builder({
      required Widget title,
      required Widget? subtitle,
      required Widget? secondary,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: YaruCheckboxListTile(
            title: title,
            subtitle: subtitle,
            secondary: secondary,
            value: false,
            onChanged: (_) {},
          ),
        ),
      );
    }

    await tester.pumpWidget(
      builder(
        title: const Text('title'),
        subtitle: null,
        secondary: null,
      ),
    );
    expect(find.text('title'), findsOneWidget);
    expect(find.byType(YaruCheckbox), findsOneWidget);

    await tester.pumpWidget(
      builder(
        title: const Text('title'),
        subtitle: const Text('subtitle'),
        secondary: const Icon(Icons.check_box),
      ),
    );
    expect(find.text('title'), findsOneWidget);
    expect(find.text('subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.check_box), findsOneWidget);
    expect(find.byType(YaruCheckbox), findsOneWidget);
  });

  testWidgets('the tile react to taps', (tester) async {
    bool? changedValue;
    Widget builder({required bool? initialValue, required bool tristate}) {
      return MaterialApp(
        home: Scaffold(
          body: YaruCheckboxListTile(
            title: const Text('title'),
            value: initialValue,
            tristate: tristate,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
    }

    final tileFinder = find.byType(YaruCheckboxListTile);

    await tester.pumpWidget(builder(initialValue: false, tristate: false));
    await tester.tap(tileFinder);
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: true, tristate: false));
    await tester.tap(tileFinder);
    expect(changedValue, isFalse);

    await tester.pumpWidget(builder(initialValue: false, tristate: true));
    await tester.tap(tileFinder);
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: true, tristate: true));
    await tester.tap(tileFinder);
    expect(changedValue, null);

    await tester.pumpWidget(builder(initialValue: null, tristate: true));
    await tester.tap(tileFinder);
    expect(changedValue, isFalse);
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      // ensure traditional focus highlight
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      final tristate = variant.label.startsWith('tristate');

      await tester.pumpScaffold(
        YaruCheckboxListTile(
          autofocus: variant.hasState(WidgetState.focused),
          tristate: tristate,
          value: tristate ? null : variant.hasState(WidgetState.selected),
          onChanged: variant.hasState(WidgetState.disabled) ? null : (_) {},
          title: const Text('YaruCheckboxListTile'),
          subtitle: const Text('Lorem ipsum dolor sit amet'),
        ),
        themeMode: variant.themeMode,
        size: const Size(325, 72),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruCheckbox));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(YaruCheckbox));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruCheckboxListTile),
        matchesGoldenFile(
          'goldens/yaru_checkbox_list_tile-${variant.label}.png',
        ),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('unchecked', <WidgetState>{}),
  ...goldenThemeVariants('unckecked-disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('unckecked-focused', {WidgetState.focused}),
  ...goldenThemeVariants('unckecked-hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('unckecked-pressed', {WidgetState.pressed}),
  ...goldenThemeVariants('checked', {WidgetState.selected}),
  ...goldenThemeVariants('checked-disabled', {
    WidgetState.selected,
    WidgetState.disabled,
  }),
  ...goldenThemeVariants('checked-focused', {
    WidgetState.selected,
    WidgetState.focused,
  }),
  ...goldenThemeVariants('checked-hovered', {
    WidgetState.selected,
    WidgetState.hovered,
  }),
  ...goldenThemeVariants('checked-pressed', {
    WidgetState.selected,
    WidgetState.pressed,
  }),
  ...goldenThemeVariants('tristate', {WidgetState.selected}),
  ...goldenThemeVariants('tristate-disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('tristate-focused', {WidgetState.focused}),
  ...goldenThemeVariants('tristate-hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('tristate-pressed', {WidgetState.pressed}),
});
