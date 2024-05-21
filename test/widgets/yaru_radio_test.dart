import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

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
          autofocus: variant.hasState(WidgetState.focused),
          value: variant.hasState(WidgetState.selected),
          groupValue: true,
          onChanged: variant.hasState(WidgetState.disabled) ? null : (_) {},
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
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
        find.byType(YaruRadio<bool>),
        matchesGoldenFile('goldens/yaru_radio-${variant.label}.png'),
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
