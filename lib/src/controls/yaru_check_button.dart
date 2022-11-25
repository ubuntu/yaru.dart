import 'package:flutter/material.dart';

import 'yaru_checkbox.dart';
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
    this.tristate = false,
    this.autofocus = false,
    this.focusNode,
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

  @override
  Widget build(BuildContext context) {
    return YaruToggleButton(
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      leading: YaruCheckbox(
        value: value,
        onChanged: onChanged,
        tristate: tristate,
        focusNode: focusNode,
        autofocus: autofocus,
      ),
      onToggled: onChanged == null ? null : _onToggled,
    );
  }

  void _onToggled() {
    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
        break;
    }
  }
}
