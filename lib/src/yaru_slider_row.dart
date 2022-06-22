import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_row.dart';

class YaruSliderRow extends StatelessWidget {
  /// Creates a yaru style slider.
  /// If the `value` property is null the [Widget] will return [SizedBox].
  /// Slider is passed as an `actionWidget   inside [YaruRow].
  /// `actionLabel` and `actionDescription` is placed in a row along with the slider.
  ///
  /// For example:
  /// ```dart
  ///   YaruSliderRow(
  ///           actionLabel: "actionLabel",
  ///           value: _sliderValue,
  ///           min: 0,
  ///           max: 100,
  ///           onChanged: (v) {
  ///             setState(() {
  ///               _sliderValue = v;
  ///             });
  ///           },
  ///         ),
  ///
  /// ```
  const YaruSliderRow({
    Key? key,
    this.enabled = true,
    required this.actionLabel,
    this.actionDescription,
    required this.value,
    this.defaultValue,
    required this.min,
    required this.max,
    this.showValue = true,
    this.fractionDigits = 0,
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

  /// Name of the setting
  final String actionLabel;

  /// Optional description of the setting
  final String? actionDescription;

  /// Current value of the setting
  final double? value;

  /// Default value of the setting
  final double? defaultValue;

  /// Minimal value of the setting
  final double min;

  /// Maximum value of the setting
  final double max;

  /// If true, the current [value] is visible as a text next to the slider
  ///
  /// Defaults to true
  final bool showValue;

  /// Number of digits after decimal point for [value] displayed as a text
  ///
  /// Defaults to 0 (no fractional part)
  final int fractionDigits;

  /// Function run when the slider changes its value
  final Function(double) onChanged;

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
    const thumbRadius = 24.0;

    final enabled = this.enabled && value != null;

    return YaruRow(
      width: width,
      enabled: enabled,
      trailingWidget: Text(actionLabel),
      description: actionDescription,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      actionWidget: Expanded(
        flex: 2,
        child: Row(
          children: [
            if (showValue)
              SizedBox(
                width: 40,
                height: 20,
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value?.toStringAsFixed(fractionDigits) ?? '',
                  ),
                ),
              ),
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) => Stack(
                  alignment: Alignment.center,
                  children: [
                    if (defaultValue != null)
                      Positioned(
                        left: thumbRadius +
                            (constraints.maxWidth - thumbRadius * 2) *
                                (defaultValue! - min) /
                                (max - min),
                        child: Container(
                          width: 1,
                          height: 40,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    Slider(
                      label: value?.toStringAsFixed(0),
                      min: min,
                      max: max,
                      value: value ?? min,
                      onChanged: enabled ? onChanged : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
