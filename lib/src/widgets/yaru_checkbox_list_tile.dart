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
class YaruCheckboxListTile extends StatelessWidget {
  /// Creates a combination of a [ListTile] and a [YaruCheckbox].
  ///
  /// See [CheckboxListTile].
  const YaruCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.tristate = false,
    this.shape,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.mouseCursor,
    this.hasFocusBorder,
  }) : assert(tristate || value != null),
       assert(!isThreeLine || subtitle != null);

  /// See [CheckboxListTile.value].
  final bool? value;

  /// See [CheckboxListTile.onChanged].
  final ValueChanged<bool?>? onChanged;

  /// See [CheckboxListTile.tileColor].
  final Color? tileColor;

  /// See [CheckboxListTile.title].
  final Widget? title;

  /// See [CheckboxListTile.subtitle].
  final Widget? subtitle;

  /// See [CheckboxListTile.secondary].
  final Widget? secondary;

  /// See [CheckboxListTile.isThreeLine].
  final bool isThreeLine;

  /// See [CheckboxListTile.dense].
  final bool? dense;

  /// See [CheckboxListTile.selected].
  final bool selected;

  /// See [CheckboxListTile.controlAffinity].
  final ListTileControlAffinity controlAffinity;

  /// See [CheckboxListTile.autofocus].
  final bool autofocus;

  /// See [CheckboxListTile.contentPadding].
  final EdgeInsetsGeometry? contentPadding;

  /// See [CheckboxListTile.tristate].
  final bool tristate;

  /// See [CheckboxListTile.shape].
  final ShapeBorder? shape;

  /// See [CheckboxListTile.selectedTileColor].
  final Color? selectedTileColor;

  /// See [CheckboxListTile.visualDensity].
  final VisualDensity? visualDensity;

  /// See [CheckboxListTile.focusNode].
  final FocusNode? focusNode;

  /// See [CheckboxListTile.enableFeedback].
  final bool? enableFeedback;

  /// See [CheckboxListTile.mouseCursor].
  final MouseCursor? mouseCursor;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

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
    final Widget control = YaruCheckbox(
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

    final tile = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: isThreeLine,
      dense: dense,
      enabled: onChanged != null,
      onTap: onChanged != null ? _handleValueChange : null,
      selected: selected,
      autofocus: autofocus,
      contentPadding: contentPadding,
      shape: shape,
      selectedTileColor: selectedTileColor,
      tileColor: tileColor,
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
