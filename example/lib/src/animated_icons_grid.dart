import 'package:example/src/icon_size_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru_colors/yaru_colors.dart';
import 'package:yaru_icons/yaru_icons.dart';

@immutable
class YaruAnimatedIconsGrid extends StatelessWidget {
  const YaruAnimatedIconsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<IconSizeProvider>(
      builder: (context, iconSizeProvider, _) => GridView.extent(
        padding: const EdgeInsets.all(24),
        maxCrossAxisExtent: iconSizeProvider.size + 48,
        children: [
          YaruAnimatedOkIcon(
            size: iconSizeProvider.size,
            filled: false,
            color: YaruColors.success,
          ),
          YaruAnimatedOkIcon(
            size: iconSizeProvider.size,
            filled: true,
            color: YaruColors.success,
          ),
          YaruAnimatedNoNetworkIcon(
            size: iconSizeProvider.size,
            color: YaruColors.red,
          ),
        ],
      ),
    );
  }
}
