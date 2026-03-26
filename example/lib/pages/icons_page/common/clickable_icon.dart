import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../icon_items.dart';
import 'icon_dialog.dart';

class ClickableIcon extends StatelessWidget {
  const ClickableIcon({
    super.key,
    required this.iconItem,
    required this.iconSize,
  });

  final IconItem iconItem;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: YaruFocusBorder.primary(
        child: InkWell(
          borderRadius: BorderRadius.circular(kYaruButtonRadius),
          onTap: () => showDialog(
            context: context,
            builder: (context) => IconDialog(iconItem: iconItem),
          ),
          child: Center(child: iconItem.iconBuilder(context, iconSize)),
        ),
      ),
    );
  }
}
