import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_row.dart';

class YaruToggleButtonsRow extends StatelessWidget {
  const YaruToggleButtonsRow({
    Key? key,
    required this.actionLabel,
    this.actionDescription,
    required this.labels,
    required this.selectedValues,
    required this.onPressed,
  }) : super(key: key);

  final String actionLabel;
  final String? actionDescription;
  final List<String> labels;
  final List<bool>? selectedValues;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    final selectedValues = this.selectedValues;

    if (selectedValues == null) {
      return const SizedBox();
    }

    return YaruRow(
      trailingWidget: Text(actionLabel),
      description: actionDescription,
      actionWidget: ToggleButtons(
        constraints: const BoxConstraints(minHeight: 40.0),
        isSelected: selectedValues,
        children: labels
            .map(
              (label) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(label),
              ),
            )
            .toList(),
        onPressed: onPressed,
      ),
    );
  }
}
