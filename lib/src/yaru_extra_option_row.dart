import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/yaru_option_button.dart';
import 'package:yaru_widgets/src/yaru_row.dart';

class YaruExtraOptionRow extends StatelessWidget {
  const YaruExtraOptionRow({
    Key? key,
    required this.actionLabel,
    this.actionDescription,
    required this.value,
    required this.onChanged,
    required this.onPressed,
    required this.iconData,
  }) : super(key: key);

  final String actionLabel;
  final String? actionDescription;
  final bool? value;
  final Function(bool) onChanged;
  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final value = this.value;

    if (value == null) {
      return const SizedBox();
    }

    return YaruRow(
      trailingWidget: Text(actionLabel),
      description: actionDescription,
      actionWidget: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
          ),
          const SizedBox(width: 8.0),
          YaruOptionButton(
            onPressed: onPressed,
            iconData: iconData,
          ),
        ],
      ),
    );
  }
}
