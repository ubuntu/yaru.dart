import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/yaru.dart';

extension YaruGoldenTester on WidgetTester {
  Future<void> pumpScaffold(
    Widget widget, {
    ThemeMode? themeMode,
    ThemeData? theme,
    ThemeData? darkTheme,
    Size? size,
  }) {
    binding.window.devicePixelRatioTestValue = 1;
    if (size != null) binding.window.physicalSizeTestValue = size;
    return pumpWidget(
      MaterialApp(
        themeMode: themeMode,
        theme: theme ?? yaruLight,
        darkTheme: darkTheme ?? yaruDark,
        home: Scaffold(
          body: Center(child: widget),
        ),
      ),
    );
  }

  Future<void> hover(Finder finder) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    addTearDown(gesture.removePointer);
    await gesture.moveTo(getCenter(finder));
  }

  Future<void> down(Finder finder) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    addTearDown(gesture.removePointer);
    await gesture.down(getCenter(finder));
  }
}

@immutable
class YaruGoldenVariant {
  YaruGoldenVariant({
    required String label,
    required this.themeMode,
    this.states = const {},
    this.value,
  }) : label = '$label-${themeMode.name}';

  final String label;
  final ThemeMode themeMode;
  final Map<MaterialState, bool> states;
  final dynamic value;

  bool hasState(MaterialState state) => states[state] == true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const MapEquality().equals;
    return other is YaruGoldenVariant &&
        other.label == label &&
        other.themeMode == themeMode &&
        mapEquals(other.states, states) &&
        other.value == value;
  }

  @override
  int get hashCode {
    final mapHash = const MapEquality().hash;
    return Object.hash(label, themeMode, mapHash(states), value);
  }

  @override
  String toString() =>
      '$label: themeMode: $themeMode, states: $states, value: $value';
}

List<YaruGoldenVariant> goldenThemeVariants(
  String label, [
  Map<MaterialState, bool> states = const {},
  dynamic value,
]) {
  return [
    YaruGoldenVariant(
      label: label,
      themeMode: ThemeMode.light,
      states: states,
      value: value,
    ),
    YaruGoldenVariant(
      label: label,
      themeMode: ThemeMode.dark,
      states: states,
      value: value,
    ),
  ];
}
