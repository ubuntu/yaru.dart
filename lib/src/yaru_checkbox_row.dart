import 'package:flutter/material.dart';

class YaruCheckboxRow extends StatelessWidget {
  const YaruCheckboxRow({
    Key? key,
    required this.enabled,
    required this.value,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  final bool? enabled;
  final bool? value;
  final Function(bool?) onChanged;
  final String text;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled;
    final value = this.value;

    if (enabled == null || value == null) {
      return const SizedBox();
    }

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
