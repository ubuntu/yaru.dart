import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('contains radio, labels and secondary', (tester) async {
    Widget builder({
      required Widget title,
      required Widget? subtitle,
      required Widget? secondary,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: YaruRadioListTile<int>(
            title: title,
            subtitle: subtitle,
            secondary: secondary,
            value: 0,
            groupValue: 0,
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
    expect(find.text('subtitle'), findsNothing);
    expect(find.byType(YaruRadio<int>), findsOneWidget);

    await tester.pumpWidget(
      builder(
        title: const Text('title'),
        subtitle: const Text('subtitle'),
        secondary: const Icon(Icons.radio_button_checked),
      ),
    );
    expect(find.text('title'), findsOneWidget);
    expect(find.text('subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(find.byType(YaruRadio<int>), findsOneWidget);
  });

  testWidgets('the tile react to taps', (tester) async {
    int? changedValue;
    Widget builder({
      required int value,
      required int groupValue,
      required bool toggleable,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: YaruRadioListTile<int>(
            title: const Text('title'),
            subtitle: const Text('subtitle'),
            value: value,
            groupValue: groupValue,
            toggleable: toggleable,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
    }

    final tileFinder = find.byType(YaruRadioListTile<int>);

    await tester
        .pumpWidget(builder(value: 1, groupValue: 1, toggleable: false));
    await tester.tap(tileFinder);
    expect(changedValue, equals(1));

    await tester
        .pumpWidget(builder(value: 2, groupValue: 3, toggleable: false));
    await tester.tap(tileFinder);
    expect(changedValue, equals(2));

    await tester.pumpWidget(builder(value: 1, groupValue: 1, toggleable: true));
    await tester.tap(tileFinder);
    expect(changedValue, equals(null));

    await tester.pumpWidget(builder(value: 2, groupValue: 3, toggleable: true));
    await tester.tap(tileFinder);
    expect(changedValue, equals(2));
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      // ensure traditional focus highlight
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      await tester.pumpScaffold(
        YaruRadioListTile<bool>(
          autofocus: variant.hasState(WidgetState.focused),
          value: variant.hasState(WidgetState.selected),
          groupValue: true,
          onChanged: variant.hasState(WidgetState.disabled) ? null : (_) {},
          title: const Text('YaruRadioListTile'),
          subtitle: const Text('Lorem ipsum dolor sit amet'),
        ),
        themeMode: variant.themeMode,
        size: const Size(325, 72),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruRadio<bool>));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(YaruRadio<bool>));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruRadioListTile<bool>),
        matchesGoldenFile('goldens/yaru_radio_list_tile-${variant.label}.png'),
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
});
