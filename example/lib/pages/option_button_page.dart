import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class OptionButtonPage extends StatefulWidget {
  const OptionButtonPage({super.key});

  @override
  State<OptionButtonPage> createState() => _OptionButtonPageState();
}

class _OptionButtonPageState extends State<OptionButtonPage> {
  @override
  Widget build(BuildContext context) {
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          children: [
            Row(
              children: [
                YaruOptionButton(
                  onPressed: () {},
                  child: const Icon(YaruIcons.search),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                YaruOptionButton(
                  onPressed: () {},
                  child: const Icon(YaruIcons.music_note),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                YaruOptionButton(
                  onPressed: () {},
                  child: const Icon(YaruIcons.address_book),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                YaruOptionButton.color(
                  onPressed: () {},
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
