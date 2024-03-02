import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../icon_items.dart';
import '../utils.dart';
import 'icon_usage.dart';

const _iconDialogSizes = [
  16.0,
  24.0,
  32.0,
  48.0,
  64.0,
  128.0,
];
const _dialogContentPaddingValue = 16.0;

class IconDialog extends StatelessWidget {
  const IconDialog({
    super.key,
    required this.iconItem,
  });

  final IconItem iconItem;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding:
          const EdgeInsets.symmetric(vertical: _dialogContentPaddingValue),
      title: YaruDialogTitleBar(
        title: Text(beautifyIconName(iconItem.name)),
      ),
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final size in _iconDialogSizes)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (_iconDialogSizes.last - size) / 10 +
                      _dialogContentPaddingValue / 2,
                ),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size / 10),
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.05),
                      ),
                      child: iconItem.iconBuilder(context, size),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${size.toInt().toString()}px',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const Divider(
          indent: _dialogContentPaddingValue,
          endIndent: _dialogContentPaddingValue,
          height: _dialogContentPaddingValue * 2,
        ),
        IconUsage(
          usage: iconItem.usage,
          label: true,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ],
    );
  }
}
