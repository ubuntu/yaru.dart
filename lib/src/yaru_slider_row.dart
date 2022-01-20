import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_row.dart';
import 'package:yaru_widgets/src/yaru_slider_value_marker.dart';

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

  @override
  Widget build(BuildContext context) {
    const thumbRadius = 24.0;

    final enabled = this.enabled && value != null;

    return YaruRow(
      width: width,
      enabled: enabled,
      trailingWidget: Text(actionLabel),
      description: actionDescription,
      actionWidget: Expanded(
        flex: 2,
        child: Row(
          children: [
            if (showValue)
              Text(
                value?.toStringAsFixed(fractionDigits) ?? '',
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
                        child: const YaruSliderValueMarker(),
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
