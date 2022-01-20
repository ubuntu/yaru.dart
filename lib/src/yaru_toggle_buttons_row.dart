import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_row.dart';

class YaruToggleButtonsRow extends StatelessWidget {
  /// Creates a set of Yaru style toggle buttons.
  ///
  /// It displays its strings provided in a [List] of [labels] along [direction].
  /// The state of each button is controlled by [selectedValues], which is a list
  /// of bools that determine if a button is in an active, disabled, or
  /// selected state. They are both correlated by their index in the list.
  /// The length of [selectedValues] has to match the length of the [labels]
  /// list.
  ///
  /// Both [labels] and [selectedValues] properties arguments are required.
  /// If the [selectedValues] is null the widget will return [SizedBox].
  ///
  /// For example:
  /// ```dart
  ///  final List<bool> _selectedValues = [false, false];
  ///  YaruToggleButtonsRow(
  ///           actionLabel: "Action Label",
  ///           labels: ["label1", "label2"],
  ///           onPressed: (v) {
  ///             setState(() {
  ///               _selectedValues[v] = !_selectedValues[v];
  ///             });
  ///           },
  ///           selectedValues: _selectedValues,
  ///           actionDescription: "Action Description",
  ///         ),
  ///```
  const YaruToggleButtonsRow({
    Key? key,
    this.enabled = true,
    required this.actionLabel,
    this.actionDescription,
    required this.labels,
    required this.selectedValues,
    required this.onPressed,
    this.width,
  }) : super(key: key);

  /// Whether or not we can interact with the widget
  final bool enabled;

  /// The label placed at trailing Position.
  final String actionLabel;

  /// The description placed below the `actionLabel`
  final String? actionDescription;

  /// The toggle button strings.
  ///
  /// These are [Strings]. The boolean selection
  /// state of each widget is defined by the corresponding [selectedValues]
  /// list item.
  ///
  /// The length of [labels] has to match the length of [selectedValues].
  final List<String> labels;

  /// The corresponding selection state of each toggle button.
  ///
  /// Each value in this list represents the selection state of the [labels]
  /// widget at the same index.
  ///
  /// The length of [selectedValues] has to match the length of [labels].
  final List<bool>? selectedValues;

  /// The callback that is called when a button is tapped.
  ///
  /// The index parameter of the callback is the index of the button that is
  /// tapped or otherwise activated.
  ///
  /// When the callback is null, all toggle buttons will be disabled.
  final Function(int) onPressed;

  /// Optional width passed to [YaruRow]
  final double? width;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled && selectedValues != null;

    return YaruRow(
      width: width,
      enabled: enabled,
      trailingWidget: Text(actionLabel),
      description: actionDescription,
      actionWidget: ToggleButtons(
        constraints: const BoxConstraints(minHeight: 40.0),
        isSelected:
            selectedValues ?? List.generate(labels.length, (_) => false),
        children: labels
            .map(
              (label) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  label,
                  style: enabled
                      ? null
                      : TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            )
            .toList(),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
