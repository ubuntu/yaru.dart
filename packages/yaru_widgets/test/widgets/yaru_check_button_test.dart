import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('contains checkbox and labels', (tester) async {
    Widget builder({required Widget title, required Widget? subtitle}) {
      return MaterialApp(
        home: Scaffold(
          body: YaruCheckButton(
            title: title,
            subtitle: subtitle,
            value: false,
            onChanged: (_) {},
          ),
        ),
      );
    }

    await tester
        .pumpWidget(builder(title: const Text('title'), subtitle: null));
    expect(find.text('title'), findsOneWidget);
    expect(find.text('subtitle'), findsNothing);
    expect(find.byType(YaruCheckbox), findsOneWidget);

    await tester.pumpWidget(
      builder(title: const Text('title'), subtitle: const Text('subtitle')),
    );
    expect(find.text('title'), findsOneWidget);
    expect(find.text('subtitle'), findsOneWidget);
    expect(find.byType(YaruCheckbox), findsOneWidget);
  });

  testWidgets('the labels react to taps', (tester) async {
    bool? changedValue;
    Widget builder({required bool initialValue}) {
      return MaterialApp(
        home: Scaffold(
          body: YaruCheckButton(
            title: const Text('title'),
            subtitle: const Text('subtitle'),
            value: initialValue,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
    }

    await tester.pumpWidget(builder(initialValue: false));
    await tester.tap(find.text('title'));
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: false));
    await tester.tap(find.text('subtitle'));
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: true));
    await tester.tap(find.text('title'));
    expect(changedValue, isFalse);

    await tester.pumpWidget(builder(initialValue: true));
    await tester.tap(find.text('subtitle'));
    expect(changedValue, isFalse);
  });

  testWidgets('mouse cursor changes depending on the state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruCheckButton(
                title: const Text('enabled'),
                value: false,
                onChanged: (_) {},
              ),
              const YaruCheckButton(
                title: Text('disabled'),
                value: false,
                onChanged: null,
              ),
            ],
          ),
        ),
      ),
    );

    final gesture =
        await tester.createGesture(kind: PointerDeviceKind.mouse, pointer: 1);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture
        .moveTo(tester.getCenter(find.widgetWithText(MouseRegion, 'enabled')));
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.click,
    );

    await gesture
        .moveTo(tester.getCenter(find.widgetWithText(MouseRegion, 'disabled')));
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.basic,
    );
  });

  testWidgets('text color changes depending on the state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruCheckButton(
                title: const Text('enabled'),
                value: false,
                onChanged: (_) {},
              ),
              const YaruCheckButton(
                title: Text('disabled'),
                value: false,
                onChanged: null,
              ),
            ],
          ),
        ),
      ),
    );

    final enabled = tester.element(find.text('enabled'));
    expect(
      DefaultTextStyle.of(enabled).style.color,
      isNot(equals(Theme.of(enabled).disabledColor)),
    );

    final disabled = tester.element(find.text('disabled'));
    expect(
      DefaultTextStyle.of(disabled).style.color,
      equals(Theme.of(disabled).disabledColor),
    );
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
        YaruCheckButton(
          autofocus: variant.hasState(MaterialState.focused),
          tristate: tristate,
          value: tristate ? null : variant.hasState(MaterialState.selected),
          onChanged: variant.hasState(MaterialState.disabled) ? null : (_) {},
          title: const Text('YaruCheckButton'),
          subtitle: const Text('Lorem ipsum dolor sit amet'),
        ),
        themeMode: variant.themeMode,
        size: const Size(224, 56),
        alignment: Alignment.centerLeft,
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.byType(YaruCheckbox));
        await tester.pumpAndSettle();
      } else if (variant.hasState(MaterialState.hovered)) {
        await tester.hover(find.byType(YaruCheckbox));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruCheckButton),
        matchesGoldenFile('goldens/yaru_check_button-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  ...goldenThemeVariants('unchecked', <MaterialState>{}),
  ...goldenThemeVariants('unckecked-disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('unckecked-focused', {MaterialState.focused}),
  ...goldenThemeVariants('unckecked-hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('unckecked-pressed', {MaterialState.pressed}),
  ...goldenThemeVariants('checked', {MaterialState.selected}),
  ...goldenThemeVariants('checked-disabled', {
    MaterialState.selected,
    MaterialState.disabled,
  }),
  ...goldenThemeVariants('checked-focused', {
    MaterialState.selected,
    MaterialState.focused,
  }),
  ...goldenThemeVariants('checked-hovered', {
    MaterialState.selected,
    MaterialState.hovered,
  }),
  ...goldenThemeVariants('checked-pressed', {
    MaterialState.selected,
    MaterialState.pressed,
  }),
  ...goldenThemeVariants('tristate', {MaterialState.selected}),
  ...goldenThemeVariants('tristate-disabled', {MaterialState.disabled}),
  ...goldenThemeVariants('tristate-focused', {MaterialState.focused}),
  ...goldenThemeVariants('tristate-hovered', {MaterialState.hovered}),
  ...goldenThemeVariants('tristate-pressed', {MaterialState.pressed}),
});
