import 'package:flutter/material.dart';

import 'yaru_radio.dart';
import 'yaru_toggle_button.dart';
import 'yaru_toggle_button_theme.dart';

/// A desktop style radio button with an interactive label.
class YaruRadioButton<T> extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final states = {
      if (onChanged == null) MaterialState.disabled,
    };
    final mouseCursor =
        MaterialStateProperty.resolveAs(this.mouseCursor, states) ??
            YaruToggleButtonTheme.of(context)?.mouseCursor?.resolve(states);

    return YaruToggleButton(
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      leading: YaruRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        toggleable: toggleable,
        focusNode: focusNode,
        autofocus: autofocus,
        mouseCursor: mouseCursor,
      ),
      mouseCursor:
          mouseCursor ?? MaterialStateMouseCursor.clickable.resolve(states),
      onToggled: onChanged == null ? null : _onToggled,
    );
  }

  void _onToggled() {
    if (groupValue != value || !toggleable) {
      onChanged!(value);
    } else if (toggleable) {
      onChanged!(null);
    }
  }
}
