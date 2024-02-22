import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('radio react to taps', (tester) async {
    int? changedValue;
    Widget builder({
      required int value,
      required int groupValue,
      required bool toggleable,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: YaruRadio<int>(
            value: value,
            groupValue: groupValue,
            onChanged: (v) => changedValue = v,
            toggleable: toggleable,
          ),
        ),
      );
    }

    final radioFinder = find.byType(YaruRadio<int>);

    await tester
        .pumpWidget(builder(value: 1, groupValue: 1, toggleable: false));
    await tester.tap(radioFinder);
    expect(changedValue, equals(1));

    await tester
        .pumpWidget(builder(value: 2, groupValue: 3, toggleable: false));
    await tester.tap(radioFinder);
    expect(changedValue, equals(2));

    await tester.pumpWidget(builder(value: 1, groupValue: 1, toggleable: true));
    await tester.tap(radioFinder);
    expect(changedValue, equals(null));

    await tester.pumpWidget(builder(value: 2, groupValue: 3, toggleable: true));
    await tester.tap(radioFinder);
    expect(changedValue, equals(2));
  });

  testWidgets('mouse cursor changes depending on the state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruRadio<int>(
                value: 0,
                groupValue: 0,
                onChanged: (_) {},
              ),
              const YaruRadio<int>(
                value: 0,
                groupValue: 0,
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
          (widget) => widget is YaruRadio<int> && widget.onChanged != null,
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
          (widget) => widget is YaruRadio<int> && widget.onChanged == null,
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

      await tester.pumpScaffold(
        YaruRadio<bool>(
          autofocus: variant.hasState(MaterialState.focused),
          value: variant.hasState(MaterialState.selected),
          groupValue: true,
          onChanged: variant.hasState(MaterialState.disabled) ? null : (_) {},
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.byType(YaruRadio<bool>));
        await tester.pumpAndSettle();
      } else if (variant.hasState(MaterialState.hovered)) {
        await tester.hover(find.byType(YaruRadio<bool>));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruRadio<bool>),
        matchesGoldenFile('goldens/yaru_radio-${variant.label}.png'),
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
});
