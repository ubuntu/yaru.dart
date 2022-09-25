import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class OptionButtonPage extends StatefulWidget {
  const OptionButtonPage({Key? key}) : super(key: key);

  @override
  _OptionButtonPageState createState() => _OptionButtonPageState();
}

class _OptionButtonPageState extends State<OptionButtonPage> {
  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        Row(
          children: [
            YaruOptionButton(
              onPressed: () {},
              child: Icon(YaruIcons.search),
            ),
            const SizedBox(
              width: 10.0,
            ),
            YaruOptionButton(
              onPressed: () {},
              child: Icon(YaruIcons.audio),
            ),
            const SizedBox(
              width: 10.0,
            ),
            YaruOptionButton(
              onPressed: () {},
              child: Icon(YaruIcons.address_book),
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
  }
}
