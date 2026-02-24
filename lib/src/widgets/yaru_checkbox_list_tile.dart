import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// A [ListTile] with a [YaruCheckbox]. In other words, a checkbox with a label.
///
/// See [CheckboxListTile] for more details.
///
/// See also:
///
///  * [ListTileTheme], which can be used to affect the style of list tiles,
///    including checkbox list tiles.
///  * [YaruCheckButton], a similar widget with a desktop style.
///  * [YaruRadioListTile], a similar widget for radio buttons.
///  * [YaruSwitchListTile], a similar widget for switches.
///  * [ListTile] and [YaruCheckbox], the widgets from which this widget is made.
class YaruCheckboxListTile extends YaruToggleListTile {
  /// Creates a combination of a [ListTile] and a [YaruCheckbox].
  ///
  /// See [CheckboxListTile].
  const YaruCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    super.control,
    super.title,
    super.subtitle,
    super.secondary,
    super.controlAffinity,
    super.autofocus = false,
    super.shape,
    super.focusNode,
    super.enableFeedback,
    super.mouseCursor,
    super.hasFocusBorder,
    super.contentPadding,
  }) : assert(tristate || value != null);

  /// See [CheckboxListTile.value].
  final bool? value;

  /// See [CheckboxListTile.onChanged].
  final ValueChanged<bool?>? onChanged;

  /// See [CheckboxListTile.tristate].
  final bool tristate;

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? leading, trailing;
    final control =
        this.control ??
        YaruCheckbox(
          value: value,
          onChanged: onChanged,
          autofocus: autofocus,
          tristate: tristate,
          mouseCursor: mouseCursor,
          hasFocusBorder: false,
        );

    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = control;
        trailing = secondary;
        break;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
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
      customBorder: shape,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
      mouseCursor: mouseCursor,
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
