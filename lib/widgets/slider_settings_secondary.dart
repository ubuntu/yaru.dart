import 'package:flutter/material.dart';
import 'package:yaru_widgets/widgets/slider_value_marker.dart';

class SliderSettingsSecondary extends StatelessWidget {
  const SliderSettingsSecondary({
    Key? key,
    required this.label,
    required this.enabled,
    required this.value,
    this.defaultValue,
    required this.min,
    required this.max,
    this.showValue = true,
    this.fractionDigits = 0,
    required this.onChanged,
  }) : super(key: key);

  /// Name of the setting
  final String label;

  /// Whether or not we can interact with the setting slider
  final bool? enabled;

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

  @override
  Widget build(BuildContext context) {
    const thumbRadius = 24.0;
    final enabled = this.enabled;
    final value = this.value;

    if (value == null || enabled == null) {
      return const SizedBox();
    }

    return SizedBox(
      width: 500,
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: enabled
                  ? null
                  : TextStyle(color: Theme.of(context).disabledColor),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (showValue)
                  Text(
                    value.toStringAsFixed(fractionDigits),
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
                            child: const SliderValueMarker(),
                          ),
                        Slider(
                          label: value.toStringAsFixed(0),
                          min: min,
                          max: max,
                          value: value,
                          onChanged: enabled ? onChanged : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
