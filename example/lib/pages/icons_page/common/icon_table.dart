import 'package:flutter/material.dart';

import '../icon_items.dart';
import '../utils.dart';
import 'clickable_icon.dart';
import 'icon_usage.dart';

@immutable
class IconTable extends StatelessWidget {
  const IconTable({
    super.key,
    required this.iconItems,
    required this.iconSize,
  });

  final List<IconItem> iconItems;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: iconItems.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox.square(
                  dimension: iconSize * 1.5,
                  child: ClickableIcon(
                    iconItem: iconItems[index],
                    iconSize: iconSize,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: SelectableText(
                    beautifyIconName(iconItems[index].name),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: IconUsage(
                    usage: iconItems[index].usage,
                    label: false,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                ),
              ],
            ),
            if (index < iconItems.length - 1) const Divider(),
          ],
        );
      },
    );
  }
}
