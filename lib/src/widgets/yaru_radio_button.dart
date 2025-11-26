// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'yaru_radio.dart';
import 'yaru_toggle_button.dart';
import 'yaru_toggle_button_theme.dart';

/// A desktop style radio button with an interactive label.
class YaruRadioButton<T> extends StatefulWidget {
  /// Creates a new radio button.
  const YaruRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.contentPadding,
    this.toggleable = false,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
    this.hasFocusBorder = true,
  });

  /// See [Radio.value]
  final T value;

  /// See [Radio.groupValue]
  final T? groupValue;

  /// See [Radio.onChanged]
  final ValueChanged<T?>? onChanged;

  /// See [YaruToggleButton.title]
  final Widget title;

  /// See [YaruToggleButton.subtitle]
  final Widget? subtitle;

  /// See [YaruToggleButton.contentPadding]
  final EdgeInsetsGeometry? contentPadding;

  /// See [Radio.toggleable].
  final bool toggleable;

  /// See [Radio.focusNode].
  final FocusNode? focusNode;

  /// See [Radio.autofocus].
  final bool autofocus;

  /// See [Radio.mouseCursor].
  final MouseCursor? mouseCursor;

  /// Whether to display the default focus border on focus or not.
  final bool hasFocusBorder;

  @override
  State<YaruRadioButton<T>> createState() => _YaruRadioButtonState<T>();
}

class _YaruRadioButtonState<T> extends State<YaruRadioButton<T>> {
  final _statesController = WidgetStatesController();

  @override
  void initState() {
    super.initState();
    _statesController.update(WidgetState.disabled, widget.onChanged == null);
  }

  @override
  void didUpdateWidget(YaruRadioButton<T> oldWidget) {
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
      leading: YaruRadio<T>(
        value: widget.value,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
        toggleable: widget.toggleable,
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
    if (widget.groupValue != widget.value || !widget.toggleable) {
      widget.onChanged!(widget.value);
    } else if (widget.toggleable) {
      widget.onChanged!(null);
    }
  }
}
