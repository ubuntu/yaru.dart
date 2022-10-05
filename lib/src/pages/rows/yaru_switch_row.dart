import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/pages/yaru_tile.dart';

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
    super.key,
    this.enabled = true,
    required this.trailingWidget,
    this.actionDescription,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  /// Whether or not we can interact with the widget
  final bool enabled;

  /// The [Widget] placed at the trailing position.
  final Widget trailingWidget;

  /// The text that is placed below the `trailingWidget`.
  final String? actionDescription;

  /// The current value of the [Switch].
  final bool? value;

  /// The callback that  gets invoked when the [Switch] value changes.
  final Function(bool) onChanged;

  /// The padding [EdgeInsets] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled && value != null;

    return YaruTile(
      enabled: enabled,
      title: trailingWidget,
      subtitle: actionDescription != null ? Text(actionDescription!) : null,
      trailing: Switch(
        value: value ?? false,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
