import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets('the switch react to taps', (tester) async {
    bool? changedValue;
    Widget builder({required bool initialValue}) {
      return MaterialApp(
        home: Scaffold(
          body: YaruSwitch(
            value: initialValue,
            onChanged: (v) => changedValue = v,
          ),
        ),
      );
    }

    final switchFinder = find.byType(YaruSwitch);

    await tester.pumpWidget(builder(initialValue: false));
    await tester.tap(switchFinder);
    expect(changedValue, isTrue);

    await tester.pumpWidget(builder(initialValue: true));
    await tester.tap(switchFinder);
    expect(changedValue, isFalse);
  });

  testWidgets('mouse cursor changes depending on the state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              YaruSwitch(
                value: false,
                onChanged: (_) {},
              ),
              const YaruSwitch(
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
          (widget) => widget is YaruSwitch && widget.onChanged != null,
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
          (widget) => widget is YaruSwitch && widget.onChanged == null,
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
        YaruSwitch(
          autofocus: variant.hasState(MaterialState.focused),
          value: variant.hasState(MaterialState.selected),
          onChanged: variant.hasState(MaterialState.disabled) ? null : (_) {},
        ),
        themeMode: variant.themeMode,
        size: const Size(62, 37),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.pressed)) {
        await tester.down(find.byType(YaruSwitch));
        await tester.pumpAndSettle();
      } else if (variant.hasState(MaterialState.hovered)) {
        await tester.hover(find.byType(YaruSwitch));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruSwitch),
        matchesGoldenFile('goldens/yaru_switch-${variant.label}.png'),
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
