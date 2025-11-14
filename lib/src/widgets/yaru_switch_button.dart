import 'package:flutter/material.dart';

import 'yaru_switch.dart';
import 'yaru_toggle_button.dart';
import 'yaru_toggle_button_theme.dart';

/// A desktop style switch button with an interactive label.
class YaruSwitchButton extends StatefulWidget {
  /// Creates a new switch button.
  const YaruSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.contentPadding,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
    this.onOffShapes,
    this.hasFocusBorder = true,
  });

  /// See [Switch.value]
  final bool value;

  /// See [Switch.onChanged]
  final ValueChanged<bool>? onChanged;

  /// See [YaruToggleButton.title]
  final Widget title;

  /// See [YaruToggleButton.subtitle]
  final Widget? subtitle;

  /// See [YaruToggleButton.contentPadding]
  final EdgeInsetsGeometry? contentPadding;

  /// See [Switch.focusNode].
  final FocusNode? focusNode;

  /// See [Switch.autofocus].
  final bool autofocus;

  /// See [Switch.mouseCursor].
  final MouseCursor? mouseCursor;

  /// See [YaruSwitch.onOffShapes]
  final bool? onOffShapes;

  /// Whether to display the default focus border on focus or not.
  final bool hasFocusBorder;

  @override
  State<YaruSwitchButton> createState() => _YaruSwitchButtonState();
}

class _YaruSwitchButtonState extends State<YaruSwitchButton> {
  final _statesController = WidgetStatesController();

  @override
  void initState() {
    super.initState();
    _statesController.update(WidgetState.disabled, widget.onChanged == null);
  }

  @override
  void didUpdateWidget(YaruSwitchButton oldWidget) {
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
      leading: YaruSwitch(
        value: widget.value,
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: mouseCursor,
        statesController: _statesController,
        onOffShapes: widget.onOffShapes,
        hasFocusBorder: false,
      ),
      mouseCursor:
          mouseCursor ?? WidgetStateMouseCursor.clickable.resolve(states),
      statesController: _statesController,
      onToggled: widget.onChanged != null
          ? () => widget.onChanged!(!widget.value)
          : null,
    );
  }
}
