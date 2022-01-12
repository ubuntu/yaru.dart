import 'package:flutter/material.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruOptionCardList extends StatelessWidget {
  const YaruOptionCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: 300,
            height: 300,
            child: YaruOptionCard(
              titleText: 'YaruOptionCard 1',
              bodyText: 'Description...',
              selected: true,
              onSelected: () {},
              okIconData: YaruIcons.camera_photo,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 300,
            height: 300,
            child: YaruOptionCard(
              titleText: 'YaruOptionCard 2',
              bodyText: 'Description...',
              selected: true,
              onSelected: () {},
              okIconData: YaruIcons.camera_photo,
            ),
          ),
        ),
      ],
    );
  }
}
