import 'package:flutter/material.dart';

class YaruCheckboxRow extends StatelessWidget {
  /// Creates a check box in a row along with a text
  const YaruCheckboxRow({
    Key? key,
    this.enabled = true,
    required this.value,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  /// Whether or not we can interact with the checkbox
  final bool enabled;

  /// The current value of the checkbox
  final bool? value;

  /// Called when the value of the checkbox should change. The checkbox passes the new value to the callback.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// _isCheckBoxEnabled = false;
  /// YaruCheckboxRow(
  ///   value: _isCheckBoxEnabled,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _isCheckBoxEnabled = newValue!;
  ///     });
  ///   },
  /// )
  /// ```
  final Function(bool?) onChanged;

  /// Specifies the  name of checkBox
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: enabled
                ? null
                : TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
      ],
    );
  }
}
