import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/widgets/row_list.dart';

class TabbedPagePage extends StatelessWidget {
  const TabbedPagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YaruTabbedPage(views: [
      YaruPage(
        children: [RowList()],
      ),
      YaruPage(children: [
        YaruSection(
          headline: 'Accessibility',
          children: [Text('accessibility')],
        )
      ]),
      YaruPage(children: [Text('Audio')]),
      YaruPage(children: [Text('AddressBook')]),
      YaruPage(children: [Text('Television')])
    ], tabIcons: [
      YaruIcons.addon,
      YaruIcons.accessibility,
      YaruIcons.audio,
      YaruIcons.address_book,
      YaruIcons.television
    ], tabTitles: [
      'Addons',
      'Accessability',
      'Audio',
      'Address Book',
      'Television'
    ]);
  }
}
