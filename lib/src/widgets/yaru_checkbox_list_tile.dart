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
  State<StatefulWidget> createState() => _YaruCheckboxListTileState();
}

class _YaruCheckboxListTileState extends State<YaruCheckboxListTile> {
  bool _tileHasFocus = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? leading, trailing;
    final control =
        widget.control ??
        YaruCheckbox(
          value: widget.value,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          tristate: widget.tristate,
          mouseCursor: widget.mouseCursor,
        );

    switch (widget.controlAffinity) {
      case ListTileControlAffinity.leading:
      case ListTileControlAffinity.platform:
        leading = control;
        trailing = widget.secondary;
        break;
      case ListTileControlAffinity.trailing:
        leading = widget.secondary;
        trailing = control;
        break;
    }

    final tile = YaruListTile(
      leading: leading,
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: trailing,
      enabled: widget.onChanged != null,
      onTap: widget.onChanged != null ? widget._handleValueChange : null,
      autofocus: widget.autofocus,
      customBorder: widget.shape,
      focusNode: _focusNode,
      enableFeedback: widget.enableFeedback,
      mouseCursor: widget.mouseCursor,
      contentPadding: widget.contentPadding,
      hasFocusBorder: false,
      onFocusChange: (focus) => setState(() {
        _tileHasFocus = _focusNode.hasPrimaryFocus;
      }),
    );

    return MergeSemantics(
      child:
          widget.hasFocusBorder ??
              YaruTheme.maybeOf(context)?.focusBorders == true
          ? YaruFocusBorder.primary(
              borderStrokeAlign: BorderSide.strokeAlignInside,
              borderColor: _tileHasFocus ? null : Colors.transparent,
              child: tile,
            )
          : tile,
    );
  }
}
