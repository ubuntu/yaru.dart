import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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
          autofocus: variant.hasState(MaterialState.focused),
          tristate: tristate,
          value: tristate ? null : variant.hasState(MaterialState.selected),
          onChanged: variant.hasState(MaterialState.disabled) ? null : (_) {},
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
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
        find.byType(YaruCheckbox),
        matchesGoldenFile('goldens/yaru_checkbox-${variant.label}.png'),
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
