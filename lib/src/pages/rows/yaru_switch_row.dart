import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/pages/rows/yaru_row.dart';

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
    this.enabled = true,
    required this.trailingWidget,
    this.actionDescription,
    required this.value,
    required this.onChanged,
    this.width,
    this.padding = const EdgeInsets.all(8.0),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
  }) : super(key: key);

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

  /// Optional width passed to [YaruRow]
  final double? width;

  /// The padding [EdgeInsets] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsets padding;

  /// The [MainAxisAlignment] which defaults to [MainAxisAlignment.spaceBetween].
  final MainAxisAlignment mainAxisAlignment;

  /// The [MainAxisSize] which defaults to [MainAxisSize.max].
  final MainAxisSize mainAxisSize;

  /// The [CrossAxisAlignment] which defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// The optional [TextDirection].
  final TextDirection? textDirection;

  /// The [VerticalDirection] which defaults to [VerticalDirection.down].
  final VerticalDirection verticalDirection;

  /// The optional [TextBaseline].
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled && value != null;

    return YaruRow(
      width: width,
      enabled: enabled,
      trailingWidget: trailingWidget,
      description: actionDescription,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      actionWidget: Switch(
        value: value ?? false,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
