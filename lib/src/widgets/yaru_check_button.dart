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
    this.hasFocusBorder = true,
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

  /// Whether to display the default focus border on focus or not.
  final bool hasFocusBorder;

  @override
  State<YaruCheckButton> createState() => _YaruCheckButtonState();
}

class _YaruCheckButtonState extends State<YaruCheckButton> {
  final _statesController = WidgetStatesController();

  @override
  void initState() {
    super.initState();
    _statesController.update(WidgetState.disabled, widget.onChanged == null);
  }

  @override
  void didUpdateWidget(YaruCheckButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _statesController.update(WidgetState.disabled, widget.onChanged == null);
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final states = _statesController.value;
    final mouseCursor =
        WidgetStateProperty.resolveAs(widget.mouseCursor, states) ??
        YaruToggleButtonTheme.of(context)?.mouseCursor?.resolve(states);

    return YaruToggleButton(
      title: widget.title,
      subtitle: widget.subtitle,
      contentPadding: widget.contentPadding,
      hasFocusBorder: widget.hasFocusBorder,
      leading: YaruCheckbox(
        value: widget.value,
        onChanged: widget.onChanged,
        tristate: widget.tristate,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: mouseCursor,
        statesController: _statesController,
        hasFocusBorder: false,
      ),
      mouseCursor:
          mouseCursor ?? WidgetStateMouseCursor.clickable.resolve(states),
      statesController: _statesController,
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
