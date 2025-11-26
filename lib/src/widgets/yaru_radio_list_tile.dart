// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// A [ListTile] with a [YaruRadio]. In other words, a radio with a label.
///
/// See [RadioListTile] for more details.
///
/// See also:
///
///  * [ListTileTheme], which can be used to affect the style of list tiles,
///    including radio list tiles.
///  * [YaruRadioButton], a similar widget with a desktop style.
///  * [YaruCheckboxListTile], a similar widget for checkboxes.
///  * [YaruSwitchListTile], a similar widget for switches.
///  * [ListTile] and [YaruRadio], the widgets from which this widget is made.
class YaruRadioListTile<T> extends StatelessWidget {
  /// Creates a combination of a [ListTile] and a [YaruRadio].
  ///
  /// See [RadioListTile].
  const YaruRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.mouseCursor,
    this.hasFocusBorder,
  }) : assert(!isThreeLine || subtitle != null);

  /// See [RadioListTile.value].
  final T value;

  /// See [RadioListTile.groupValue].
  final T? groupValue;

  /// See [RadioListTile.onChanged].
  final ValueChanged<T?>? onChanged;

  /// See [RadioListTile.toggleable].
  final bool toggleable;

  /// See [RadioListTile.title].
  final Widget? title;

  /// See [RadioListTile.subtitle].
  final Widget? subtitle;

  /// See [RadioListTile.secondary].
  final Widget? secondary;

  /// See [RadioListTile.isThreeLine].
  final bool isThreeLine;

  /// See [RadioListTile.dense].
  final bool? dense;

  /// See [RadioListTile.selected].
  final bool selected;

  /// See [RadioListTile.controlAffinity].
  final ListTileControlAffinity controlAffinity;

  /// See [RadioListTile.autofocus].
  final bool autofocus;

  /// See [RadioListTile.contentPadding].
  final EdgeInsetsGeometry? contentPadding;

  /// See [RadioListTile.shape].
  final ShapeBorder? shape;

  /// See [RadioListTile.tileColor].
  final Color? tileColor;

  /// See [RadioListTile.selectedTileColor].
  final Color? selectedTileColor;

  /// See [RadioListTile.visualDensity].
  final VisualDensity? visualDensity;

  /// See [RadioListTile.focusNode].
  final FocusNode? focusNode;

  /// See [RadioListTile.enableFeedback].
  final bool? enableFeedback;

  /// See [RadioListTile.mouseCursor].
  final MouseCursor? mouseCursor;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  void _handleValueChange() {
    assert(onChanged != null);
    if (groupValue != value || !toggleable) {
      onChanged!(value);
    } else if (toggleable) {
      onChanged!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? leading, trailing;
    final Widget control = YaruRadio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      toggleable: toggleable,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      hasFocusBorder: false,
    );

    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
      case ListTileControlAffinity.platform:
        leading = control;
        trailing = secondary;
        break;
      case ListTileControlAffinity.trailing:
        leading = secondary;
        trailing = control;
        break;
    }

    final tile = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: isThreeLine,
      dense: dense,
      enabled: onChanged != null,
      shape: shape,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      onTap: onChanged != null ? _handleValueChange : null,
      selected: selected,
      autofocus: autofocus,
      contentPadding: contentPadding,
      visualDensity: visualDensity,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
      mouseCursor: mouseCursor,
    );

    return MergeSemantics(
      child: hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
          ? YaruFocusBorder.primary(
              borderStrokeAlign: BorderSide.strokeAlignInside,
              child: tile,
            )
          : tile,
    );
  }
}
