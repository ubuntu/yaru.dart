import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// A [ListTile] with a [YaruSwitch]. In other words, a switch with a label.
///
/// See [SwitchListTile] for more details.
///
/// See also:
///
///  * [ListTileTheme], which can be used to affect the style of list tiles,
///    including switch list tiles.
///  * [YaruSwitchButton], a similar widget with a desktop style.
///  * [YaruCheckboxListTile], a similar widget for checkboxes.
///  * [YaruRadioListTile], a similar widget for radio buttons.
///  * [ListTile] and [YaruSwitch], the widgets from which this widget is made.
class YaruSwitchListTile extends YaruToggleListTile {
  /// Creates a combination of a [ListTile] and a [YaruSwitch].
  ///
  /// See [SwitchListTile].
  const YaruSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    super.control,
    super.title,
    super.subtitle,
    super.secondary,
    super.autofocus = false,
    super.controlAffinity,
    super.shape,
    super.focusNode,
    super.enableFeedback = true,
    super.hoverColor,
    super.mouseCursor,
    super.onOffShapes,
    super.hasFocusBorder,
    super.contentPadding,
  });

  /// See [SwitchListTile.value].
  final bool value;

  /// See [SwitchListTile.onChanged].
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final control =
        this.control ??
        YaruSwitch(
          value: value,
          onChanged: onChanged,
          autofocus: autofocus,
          mouseCursor: mouseCursor,
          onOffShapes: onOffShapes,
          hasFocusBorder: false,
        );

    Widget? leading, trailing;
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
      onTap: onChanged != null
          ? () {
              onChanged!(!value);
            }
          : null,
      autofocus: autofocus,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
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
