import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// Abstract class for toggleable list tiles like [YaruRadioListTile],
/// [YaruCheckboxListTile], and [YaruSwitchListTile].
abstract class YaruToggleListTile<T> extends StatelessWidget {
  const YaruToggleListTile({
    super.key,
    this.control,
    this.title,
    this.subtitle,
    this.secondary,
    this.autofocus = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.shape,
    this.focusNode,
    this.enableFeedback = true,
    this.hoverColor,
    this.mouseCursor,
    this.onOffShapes,
    this.hasFocusBorder,
    this.contentPadding,
  });

  final Widget? control;

  /// See [YaruListTile.title].
  final Widget? title;

  /// See [YaruListTile.subtitle].
  final Widget? subtitle;

  /// See [SwitchListTile.secondary].
  final Widget? secondary;

  /// See [YaruListTile.autofocus].
  final bool autofocus;

  /// See [ListTileControlAffinity].
  final ListTileControlAffinity controlAffinity;

  /// See [YaruListTile.contentPadding].
  final EdgeInsetsGeometry? contentPadding;

  /// See [YaruListTile.customBorder].
  final ShapeBorder? shape;

  /// See [YaruListTile.focusNode].
  final FocusNode? focusNode;

  /// See [YaruListTile.enableFeedback].
  final bool enableFeedback;

  /// See [YaruListTile.hoverColor].
  final Color? hoverColor;

  /// See [YaruListTile.mouseCursor].
  final MouseCursor? mouseCursor;

  /// See [YaruSwitch.onOffShapes]
  final bool? onOffShapes;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;
}
