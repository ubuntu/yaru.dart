import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class OptionButtonList extends StatelessWidget {
  const OptionButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
