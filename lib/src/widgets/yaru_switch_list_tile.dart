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
  State<StatefulWidget> createState() => _YaruSwitchListTileState();
}

class _YaruSwitchListTileState extends State<YaruSwitchListTile> {
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
    final control =
        widget.control ??
        YaruSwitch(
          value: widget.value,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          mouseCursor: widget.mouseCursor,
          onOffShapes: widget.onOffShapes,
        );

    Widget? leading, trailing;
    switch (widget.controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = control;
        trailing = widget.secondary;
        break;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
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
      onTap: widget.onChanged != null
          ? () {
              widget.onChanged!(!widget.value);
            }
          : null,
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      enableFeedback: widget.enableFeedback,
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
