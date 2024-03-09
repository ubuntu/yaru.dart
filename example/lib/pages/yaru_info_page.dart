import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(kYaruPagePadding),
      itemCount: YaruInfoType.values.length,
      itemBuilder: (context, index) {
        final info = YaruInfoType.values[index];
        return YaruInfoBox(
          yaruInfoType: info,
          title: info.name.capitalize(),
          subtitle: 'Subtitle',
        );
      },
      separatorBuilder: (context, index) {
        final info = YaruInfoType.values[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: kYaruPagePadding),
          child: Row(
            children: [
              YaruInfoBadge(
                yaruInfoType: info,
                title: info.name.capitalize(),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension _StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
