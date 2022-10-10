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
        mainAxisExtent: 110,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        maxCrossAxisExtent: 550,
      ),
      children: [
        for (int i = 0; i < 20; i++)
          YaruBanner(
            name: Text('YaruBanner $i'),
            subtitleWidget: const Text('Description'),
            icon: Image.asset('assets/ubuntuhero.jpg'),
            onTap: () => showAboutDialog(context: context),
          )
      ],
    );
  }
}
