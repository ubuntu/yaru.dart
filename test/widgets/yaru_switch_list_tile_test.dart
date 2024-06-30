import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('contains switch, labels and secondary', (tester) async {
    Widget builder({
      required Widget title,
      required Widget? subtitle,
      required Widget? secondary,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: YaruSwitchListTile(
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
    expect(find.byType(YaruSwitch), findsOneWidget);

    await tester.pumpWidget(
      builder(
        title: const Text('title'),
        subtitle: const Text('subtitle'),
        secondary: const Icon(Icons.circle),
      ),
    );
    expect(find.text('title'), findsOneWidget);
    expect(find.text('subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.circle), findsOneWidget);
    expect(find.byType(YaruSwitch), findsOneWidget);
  });

  testWidgets('the tile react to taps', (tester) async {
    bool? changedValue;
    Widget builder({required bool initialValue}) {
      return MaterialApp(
        home: Scaffold(
          body: YaruSwitchListTile(
            title: const Text('title'),
            subtitle: const Text('subtitle'),
            value: initialValue,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
    }

    final switchFinder = find.byType(YaruSwitchListTile);

    await tester.pumpWidget(builder(initialValue: false));
    await tester.tap(switchFinder);
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: true));
    await tester.tap(switchFinder);
    expect(changedValue, isFalse);
  });

  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      // ensure traditional focus highlight
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      await tester.pumpScaffold(
        YaruSwitchListTile(
          autofocus: variant.hasState(WidgetState.focused),
          value: variant.hasState(WidgetState.selected),
          onChanged: variant.hasState(WidgetState.disabled) ? null : (_) {},
          title: const Text('YaruSwitchListTile'),
          subtitle: const Text('Lorem ipsum dolor sit amet'),
        ),
        themeMode: variant.themeMode,
        size: const Size(325, 72),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(WidgetState.pressed)) {
        await tester.down(find.byType(YaruSwitch));
        await tester.pumpAndSettle();
      } else if (variant.hasState(WidgetState.hovered)) {
        await tester.hover(find.byType(YaruSwitch));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruSwitchListTile),
        matchesGoldenFile('goldens/yaru_switch_list_tile-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('off', <WidgetState>{}),
  ...goldenThemeVariants('off-disabled', {WidgetState.disabled}),
  ...goldenThemeVariants('off-focused', {WidgetState.focused}),
  ...goldenThemeVariants('off-hovered', {WidgetState.hovered}),
  ...goldenThemeVariants('off-pressed', {WidgetState.pressed}),
  ...goldenThemeVariants('on', {WidgetState.selected}),
  ...goldenThemeVariants('on-disabled', {
    WidgetState.selected,
    WidgetState.disabled,
  }),
  ...goldenThemeVariants('on-focused', {
    WidgetState.selected,
    WidgetState.focused,
  }),
  ...goldenThemeVariants('on-hovered', {
    WidgetState.selected,
    WidgetState.hovered,
  }),
  ...goldenThemeVariants('on-pressed', {
    WidgetState.selected,
    WidgetState.pressed,
  }),
});
