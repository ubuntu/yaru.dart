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
class YaruSwitchListTile extends StatelessWidget {
  /// Creates a combination of a [ListTile] and a [YaruSwitch].
  ///
  /// See [SwitchListTile].
  const YaruSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.secondary,
    this.selected = false,
    this.autofocus = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.shape,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.hoverColor,
    this.mouseCursor,
    this.onOffShapes,
    this.hasFocusBorder,
  }) : assert(!isThreeLine || subtitle != null);

  /// See [SwitchListTile.value].
  final bool value;

  /// See [SwitchListTile.onChanged].
  final ValueChanged<bool>? onChanged;

  /// See [SwitchListTile.tileColor].
  final Color? tileColor;

  /// See [SwitchListTile.title].
  final Widget? title;

  /// See [SwitchListTile.subtitle].
  final Widget? subtitle;

  /// See [SwitchListTile.secondary].
  final Widget? secondary;

  /// See [SwitchListTile.isThreeLine].
  final bool isThreeLine;

  /// See [SwitchListTile.dense].
  final bool? dense;

  /// See [SwitchListTile.contentPadding].
  final EdgeInsetsGeometry? contentPadding;

  /// See [SwitchListTile.selected].
  final bool selected;

  /// See [SwitchListTile.autofocus].
  final bool autofocus;

  /// See [SwitchListTile.controlAffinity].
  final ListTileControlAffinity controlAffinity;

  /// See [SwitchListTile.shape].
  final ShapeBorder? shape;

  /// See [SwitchListTile.selectedTileColor].
  final Color? selectedTileColor;

  /// See [SwitchListTile.visualDensity].
  final VisualDensity? visualDensity;

  /// See [SwitchListTile.focusNode].
  final FocusNode? focusNode;

  /// See [SwitchListTile.enableFeedback].
  final bool? enableFeedback;

  /// See [SwitchListTile.hoverColor].
  final Color? hoverColor;

  /// See [SwitchListTile.mouseCursor].
  final MouseCursor? mouseCursor;

  /// See [YaruSwitch.onOffShapes]
  final bool? onOffShapes;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  @override
  Widget build(BuildContext context) {
    final control = YaruSwitch(
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

    final tile = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: contentPadding,
      enabled: onChanged != null,
      onTap: onChanged != null
          ? () {
              onChanged!(!value);
            }
          : null,
      selected: selected,
      selectedTileColor: selectedTileColor,
      autofocus: autofocus,
      shape: shape,
      tileColor: tileColor,
      visualDensity: visualDensity,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
      hoverColor: hoverColor,
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
