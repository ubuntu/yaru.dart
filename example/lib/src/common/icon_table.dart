import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/icon_size_provider.dart';
import '../utils.dart';
import 'clickable_icon.dart';
import 'icon_item.dart';
import 'icon_usage.dart';

@immutable
class IconTable extends StatelessWidget {
  const IconTable({
    super.key,
    required this.iconItems,
  });

  final List<IconItem> iconItems;

  @override
  Widget build(BuildContext context) {
    final iconViewProvider = Provider.of<IconViewProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: iconItems.length,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: iconViewProvider.iconSize * 1.5,
                child: ClickableIcon(iconItem: iconItems[index]),
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
      ),
    );
  }
}
