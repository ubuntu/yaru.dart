import 'package:flutter/material.dart';

class YaruCheckboxRow extends StatelessWidget {
  /// Creates a check box in a row along with a text
  const YaruCheckboxRow({
    super.key,
    this.enabled = true,
    required this.value,
    required this.onChanged,
    required this.text,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.spaceSizedBox = const SizedBox(width: 4),
  });

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

  /// The [SizexBox] between the [CheckBox] and the [Text].
  final SizedBox spaceSizedBox;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: [
        Checkbox(
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
        spaceSizedBox,
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
