import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class BannerPage extends StatelessWidget {
  const BannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        GridView(
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
                name: 'YaruBanner $i',
                summary: 'Description',
                icon: Image.asset('assets/ubuntuhero.jpg'),
                onTap: () => showAboutDialog(context: context),
              )
          ],
        ),
      ],
    );
  }
}
