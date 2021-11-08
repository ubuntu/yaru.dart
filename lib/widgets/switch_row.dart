import 'package:flutter/material.dart';
import 'package:yaru_widgets/widgets/yaru_row.dart';

class SwitchRow extends StatelessWidget {
  const SwitchRow({
    Key? key,
    required this.trailingWidget,
    this.actionDescription,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final Widget trailingWidget;
  final String? actionDescription;
  final bool? value;
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
