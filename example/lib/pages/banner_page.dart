import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class BannerPage extends StatelessWidget {
  const BannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: 200,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        maxCrossAxisExtent: 550,
      ),
      children: [
        for (int i = 0; i < 20; i++)
          YaruBanner(
            title: Text('YaruBanner $i'),
            subtitle: const Text('Description'),
            thirdTitle: const Text('Third line'),
            icon: Icon(
              Icons.air_sharp,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            watermark: true,
            onTap: () => showAboutDialog(context: context),
            // surfaceTintColor: Colors.pink,
          )
      ],
    );
  }
}
