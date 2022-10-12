import 'package:flutter/material.dart';

import 'yaru_toggle_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return YaruToggleButton(
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      leading: SizedBox.square(
        dimension: kMinInteractiveDimension - 8,
        child: Center(
          child: Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ),
      ),
      onToggled: onChanged != null ? () => onChanged!(value) : null,
    );
  }
}
