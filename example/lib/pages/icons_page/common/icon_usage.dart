import 'package:flutter/material.dart';

class IconUsage extends StatelessWidget {
  const IconUsage({
    super.key,
    required this.usage,
    required this.label,
    required this.mainAxisAlignment,
  });

  final String usage;
  final bool label;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final usageTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontFamily: 'Monospace',
        );

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (label) ...[
          Text(
            'Usage: ',
            style: usageTextStyle,
          ),
          const SizedBox(
            width: 8,
          ),
        ],
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).highlightColor,
              ),
              child: SelectableText(
                usage,
                style: usageTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
