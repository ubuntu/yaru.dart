import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_row.dart';

class YaruSwitchRow extends StatelessWidget {
  /// Creates yaru style switch. The [Switch] will be aligned horizontally along with the  `trailingWidget`.
  ///
  /// for example:
  ///```dart
  /// bool _yaruSwitchEnabled = false;
  /// YaruSwitchRow(
  ///          value: _yaruSwitchEnabled,
  ///          onChanged: (v) {
  ///             setState(() {
  ///               _yaruSwitchEnabled = v;
  ///             });
  ///           },
  ///           trailingWidget: Text("Trailing Widget"),
  ///         ),
  ///```
  const YaruSwitchRow({
    Key? key,
    required this.trailingWidget,
    this.actionDescription,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  /// The [Widget] placed at the trailing position.
  final Widget trailingWidget;

  /// The text that is placed below the `trailingWidget`.
  final String? actionDescription;

  /// The current value of the [Switch].
  final bool? value;

  /// The callback that  gets invoked when the [Switch] value changes.
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final value = this.value;

    if (value == null) {
      return const SizedBox();
    }

    return YaruRow(
      trailingWidget: trailingWidget,
      description: actionDescription,
      actionWidget: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
