import 'package:flutter/material.dart';

import 'yaru_radio.dart';
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
    this.toggleable = false,
    this.autofocus = false,
    this.focusNode,
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

  @override
  Widget build(BuildContext context) {
    return YaruToggleButton(
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      leading: SizedBox.square(
        dimension: kMinInteractiveDimension - 8,
        child: Center(
          child: YaruRadio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            toggleable: toggleable,
            focusNode: focusNode,
            autofocus: autofocus,
          ),
        ),
      ),
      onToggled: onChanged != null ? () => onChanged!(value) : null,
    );
  }
}
