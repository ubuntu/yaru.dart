import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/icon_size_provider.dart';
import 'icon_dialog.dart';
import 'icon_item.dart';

class ClickableIcon extends StatelessWidget {
  const ClickableIcon({
    super.key,
    required this.iconItem,
  });

  final IconItem iconItem;

  @override
  Widget build(BuildContext context) {
    final iconViewProvider = Provider.of<IconViewProvider>(context);

    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => IconDialog(
            iconItem: iconItem,
          ),
        ),
        child: Center(
          child: iconItem.iconBuilder(
            context,
            iconViewProvider.iconSize,
          ),
        ),
      ),
    );
  }
}
