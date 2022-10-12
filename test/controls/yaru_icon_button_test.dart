import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../yaru_golden_tester.dart';

void main() {
  testWidgets(
    'golden images',
    (tester) async {
      final variant = goldenVariant.currentValue!;

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      await tester.pumpYaruWidget(
        YaruIconButton(
          autofocus: variant.hasState(MaterialState.focused),
          isSelected: variant.states[MaterialState.selected],
          onPressed: variant.hasState(MaterialState.disabled) ? null : () {},
          icon: const Icon(YaruIcons.star_filled),
        ),
        themeMode: variant.themeMode,
        size: const Size(40, 40),
      );
      await tester.pumpAndSettle();

      if (variant.hasState(MaterialState.hovered) ||
          variant.hasState(MaterialState.pressed)) {
        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer();
        addTearDown(gesture.removePointer);

        final center = tester.getCenter(find.byType(YaruIconButton));
        await gesture.moveTo(center);
        if (variant.hasState(MaterialState.pressed)) {
          await gesture.down(center);
        }
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(YaruIconButton),
        matchesGoldenFile('goldens/yaru_icon_button-${variant.label}.png'),
      );
    },
    variant: goldenVariant,
    tags: 'golden',
  );
}

final goldenVariant = ValueVariant({
  // normal (non-toggle) button
  ...themeVariants('normal'),
  ...themeVariants('disabled', {MaterialState.disabled: true}),
  ...themeVariants('focused', {MaterialState.focused: true}),
  ...themeVariants('hovered', {MaterialState.hovered: true}),
  ...themeVariants('pressed', {MaterialState.pressed: true}),
  // selected toggle button
  ...themeVariants('selected', {MaterialState.selected: true}),
  ...themeVariants('selected-disabled', {
    MaterialState.selected: true,
    MaterialState.disabled: true,
  }),
  ...themeVariants('selected-focused', {
    MaterialState.selected: true,
    MaterialState.focused: true,
  }),
  ...themeVariants('selected-hovered', {
    MaterialState.selected: true,
    MaterialState.hovered: true,
  }),
  ...themeVariants('selected-pressed', {
    MaterialState.selected: true,
    MaterialState.pressed: true,
  }),
  // unselected toggle button
  ...themeVariants('unselected', {MaterialState.selected: false}),
  ...themeVariants('unselected-disabled', {
    MaterialState.selected: false,
    MaterialState.disabled: true,
  }),
  ...themeVariants('unselected-focused', {
    MaterialState.selected: false,
    MaterialState.focused: true,
  }),
  ...themeVariants('unselected-hovered', {
    MaterialState.selected: false,
    MaterialState.hovered: true,
  }),
  ...themeVariants('unselected-pressed', {
    MaterialState.selected: false,
    MaterialState.pressed: true,
  }),
});

List<YaruIconButtonVariant> themeVariants(
  String label, [
  Map<MaterialState, bool> states = const {},
]) {
  return [
    YaruIconButtonVariant(
      label: label,
      themeMode: ThemeMode.light,
      states: states,
    ),
    YaruIconButtonVariant(
      label: label,
      themeMode: ThemeMode.dark,
      states: states,
    ),
  ];
}

@immutable
class YaruIconButtonVariant {
  YaruIconButtonVariant({
    required String label,
    required this.themeMode,
    this.states = const {},
  }) : label = '$label-${themeMode.name}';

  final String label;
  final ThemeMode themeMode;
  final Map<MaterialState, bool> states;

  bool hasState(MaterialState state) => states[state] == true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const MapEquality().equals;
    return other is YaruIconButtonVariant &&
        other.label == label &&
        other.themeMode == themeMode &&
        mapEquals(other.states, states);
  }

  @override
  int get hashCode {
    final mapHash = const MapEquality().hash;
    return Object.hash(label, themeMode, mapHash(states));
  }

  @override
  String toString() =>
      'YaruIconButtonVariant(label: $label, themeMode: $themeMode, states: $states)';
}
