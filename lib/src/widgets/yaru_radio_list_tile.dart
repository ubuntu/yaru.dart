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
class YaruRadioListTile<T> extends YaruToggleListTile {
  /// Creates a combination of a [ListTile] and a [YaruRadio].
  ///
  /// See [RadioListTile].
  const YaruRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    super.control,
    super.title,
    super.subtitle,
    super.secondary,
    super.controlAffinity,
    super.autofocus = false,
    super.shape,
    super.focusNode,
    super.mouseCursor,
    super.hasFocusBorder,
    super.contentPadding,
  });

  /// See [RadioListTile.value].
  final T value;

  /// See [RadioListTile.groupValue].
  final T? groupValue;

  /// See [RadioListTile.onChanged].
  final ValueChanged<T?>? onChanged;

  /// See [RadioListTile.toggleable].
  final bool toggleable;

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
    final control =
        this.control ??
        YaruRadio<T>(
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

    final tile = YaruListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      enabled: onChanged != null,
      onTap: onChanged != null ? _handleValueChange : null,
      autofocus: autofocus,
      focusNode: focusNode,
      hoverColor: hoverColor,
      mouseCursor: mouseCursor,
      customBorder: shape,
      contentPadding: contentPadding,
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
