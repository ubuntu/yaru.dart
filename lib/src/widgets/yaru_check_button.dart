import 'package:flutter/material.dart';

import 'yaru_checkbox.dart';
import 'yaru_toggle_button.dart';
import 'yaru_toggle_button_theme.dart';

/// A desktop style check button with an interactive label.
class YaruCheckButton extends StatefulWidget {
  /// Creates a new check button.
  const YaruCheckButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.contentPadding,
    this.tristate = false,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
  });

  /// See [Checkbox.value]
  final bool? value;

  /// See [Checkbox.onChanged]
  final ValueChanged<bool?>? onChanged;

  /// See [YaruToggleButton.title]
  final Widget title;

  /// See [YaruToggleButton.subtitle]
  final Widget? subtitle;

  /// See [YaruToggleButton.contentPadding]
  final EdgeInsetsGeometry? contentPadding;

  /// See [Checkbox.tristate].
  final bool tristate;

  /// See [Checkbox.focusNode].
  final FocusNode? focusNode;

  /// See [Checkbox.autofocus].
  final bool autofocus;

  /// See [Checkbox.mouseCursor].
  final MouseCursor? mouseCursor;

  @override
  State<YaruCheckButton> createState() => _YaruCheckButtonState();
}

class _YaruCheckButtonState extends State<YaruCheckButton> {
  @override
  Widget build(BuildContext context) {
    final states = {
      if (widget.onChanged == null) MaterialState.disabled,
    };
    final mouseCursor =
        MaterialStateProperty.resolveAs(widget.mouseCursor, states) ??
            YaruToggleButtonTheme.of(context)?.mouseCursor?.resolve(states);

    return YaruToggleButton(
      title: widget.title,
      subtitle: widget.subtitle,
      contentPadding: widget.contentPadding,
      leading: YaruCheckbox(
        value: widget.value,
        onChanged: widget.onChanged,
        tristate: widget.tristate,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: mouseCursor,
      ),
      mouseCursor:
          mouseCursor ?? MaterialStateMouseCursor.clickable.resolve(states),
      onToggled: widget.onChanged == null ? null : _onToggled,
    );
  }

  void _onToggled() {
    switch (widget.value) {
      case false:
        widget.onChanged!(true);
        break;
      case true:
        widget.onChanged!(widget.tristate ? null : false);
        break;
      case null:
        widget.onChanged!(false);
        break;
    }
  }
}
