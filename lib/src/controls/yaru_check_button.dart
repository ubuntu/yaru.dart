import 'package:flutter/material.dart';

import 'yaru_toggle_button.dart';

/// A desktop style check button with an interactive label.
class YaruCheckButton extends StatelessWidget {
  /// Creates a new check button.
  const YaruCheckButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.contentPadding,
  });

  /// See [Checkbox.value]
  final bool value;

  /// See [Checkbox.onChanged]
  final ValueChanged<bool?>? onChanged;

  /// See [YaruToggleButton.title]
  final Widget title;

  /// See [YaruToggleButton.subtitle]
  final Widget? subtitle;

  /// See [YaruToggleButton.contentPadding]
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return YaruToggleButton(
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      leading: SizedBox.square(
        dimension: kMinInteractiveDimension - 8,
        child: Center(
          child: Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
      onToggled: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
