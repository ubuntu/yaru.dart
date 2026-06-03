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
  State<StatefulWidget> createState() => _YaruRadioListTileState<T>();
}

class _YaruRadioListTileState<T> extends State<YaruRadioListTile<T>> {
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
        YaruRadio<T>(
          value: widget.value,
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
          toggleable: widget.toggleable,
          autofocus: widget.autofocus,
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
      focusNode: _focusNode,
      hoverColor: widget.hoverColor,
      mouseCursor: widget.mouseCursor,
      customBorder: widget.shape,
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
