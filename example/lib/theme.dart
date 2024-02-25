import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class InheritedYaruVariant
    extends InheritedNotifier<ValueNotifier<YaruVariant?>> {
  InheritedYaruVariant({
    super.key,
    required super.child,
  }) : super(notifier: ValueNotifier(null));

  static YaruVariant? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedYaruVariant>()!
        .notifier!
        .value;
  }

  static void apply(BuildContext context, YaruVariant variant) {
    context
        .findAncestorWidgetOfExactType<InheritedYaruVariant>()!
        .notifier!
        .value = variant;
  }
}
