import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('the checkbox react to taps', (tester) async {
    bool? changedValue;
    Widget builder({required bool? initialValue, required bool tristate}) {
      return MaterialApp(
        home: Scaffold(
          body: YaruCheckbox(
            value: initialValue,
            tristate: tristate,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
    }

    final checkboxFinder = find.byType(YaruCheckbox);

    await tester.pumpWidget(builder(initialValue: false, tristate: false));
    await tester.tap(checkboxFinder);
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: true, tristate: false));
    await tester.tap(checkboxFinder);
    expect(changedValue, isFalse);

    await tester.pumpWidget(builder(initialValue: false, tristate: true));
    await tester.tap(checkboxFinder);
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: true, tristate: true));
    await tester.tap(checkboxFinder);
    expect(changedValue, null);

    await tester.pumpWidget(builder(initialValue: null, tristate: true));
    await tester.tap(checkboxFinder);
    expect(changedValue, isFalse);
  });

  testWidgets('mouse cursor changes depending on the state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruCheckbox(
                value: false,
                onChanged: (_) {},
              ),
              const YaruCheckbox(
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

    await gesture.moveTo(
      tester.getCenter(
        find.byWidgetPredicate(
          (widget) => widget is YaruCheckbox && widget.onChanged != null,
        ),
      ),
    );
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.click,
    );

    await gesture.moveTo(
      tester.getCenter(
        find.byWidgetPredicate(
          (widget) => widget is YaruCheckbox && widget.onChanged == null,
        ),
      ),
    );
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.basic,
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
        YaruCheckbox(
          autofocus: variant.hasState(WidgetState.focused),
          tristate: tristate,
          value: tristate ? null : variant.hasState(WidgetState.selected),
          onChanged: variant.hasState(WidgetState.disabled) ? null : (_) {},
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
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
        find.byType(YaruCheckbox),
        matchesGoldenFile('goldens/yaru_checkbox-${variant.label}.png'),
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
