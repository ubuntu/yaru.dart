import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaru/theme.dart';

extension YaruGoldenTester on WidgetTester {
  Future<void> pumpScaffold(
    Widget widget, {
    ThemeMode? themeMode,
    ThemeData? theme,
    ThemeData? darkTheme,
    Size? size,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    view.devicePixelRatio = 1;
    if (size != null) view.physicalSize = size;
    return pumpWidget(
      MaterialApp(
        themeMode: themeMode,
        theme: theme ?? yaruLight,
        darkTheme: darkTheme ?? yaruDark,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Align(
            alignment: alignment,
            child: widget,
          ),
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
class YaruGoldenVariant<T> {
  YaruGoldenVariant({
    required String label,
    required this.themeMode,
    this.value,
  }) : label = '$label-${themeMode.name}';

  final String label;
  final ThemeMode themeMode;
  final T? value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final deepEquals = const DeepCollectionEquality().equals;
    return other is YaruGoldenVariant &&
        other.label == label &&
        other.themeMode == themeMode &&
        deepEquals(other.value, value);
  }

  @override
  int get hashCode {
    final deepHash = const DeepCollectionEquality().hash;
    return Object.hash(label, themeMode, deepHash(value));
  }

  @override
  String toString() => '$label: themeMode: $themeMode, value: $value';
}

extension YaruGoldenVariantStateSet on YaruGoldenVariant<Set<WidgetState>> {
  bool hasState(WidgetState state) => value?.contains(state) == true;
}

extension YaruGoldenVariantStateMap
    on YaruGoldenVariant<Map<WidgetState, bool>> {
  bool hasState(WidgetState state) => value?[state] == true;
}

List<YaruGoldenVariant<T>> goldenThemeVariants<T>(String label, [T? value]) {
  return [
    YaruGoldenVariant(
      label: label,
      themeMode: ThemeMode.light,
      value: value,
    ),
    YaruGoldenVariant(
      label: label,
      themeMode: ThemeMode.dark,
      value: value,
    ),
  ];
}
