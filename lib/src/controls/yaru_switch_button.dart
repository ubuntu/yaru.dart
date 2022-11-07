import 'package:flutter/material.dart';

import 'yaru_switch.dart';
import 'yaru_toggle_button.dart';

/// A desktop style switch button with an interactive label.
class YaruSwitchButton extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return YaruToggleButton(
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      leading: YaruSwitch(
        value: value,
        onChanged: onChanged,
        focusNode: focusNode,
        autofocus: autofocus,
      ),
      onToggled: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
