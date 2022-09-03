import 'package:example/src/icon_size_provider.dart';
import 'package:example/src/yaru_icon_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class YaruIconsGrid extends StatelessWidget {
  const YaruIconsGrid({Key? key}) : super(key: key);
  static const _from = 0xf101;
  static const _to = 0xf2bd;

  @override
  Widget build(BuildContext context) {
    return Consumer<IconSizeProvider>(
      builder: (context, iconSizeProvider, _) => GridView.extent(
        padding: const EdgeInsets.all(24),
        maxCrossAxisExtent: iconSizeProvider.size + 48,
        children: List.generate(_to - _from + 1, (index) {
          final code = index + _from;
          return Column(
            children: [
              Icon(YaruIconsData(code), size: iconSizeProvider.size),
              const SizedBox(height: 8),
              Text(
                'ex' + code.toRadixString(16),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          );
        }),
      ),
    );
  }
}
