import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/widgets/row_list.dart';

class TabbedPagePage extends StatefulWidget {
  const TabbedPagePage({
    Key? key,
  }) : super(key: key);

  @override
  State<TabbedPagePage> createState() => _TabbedPagePageState();
}

class _TabbedPagePageState extends State<TabbedPagePage> {
  int _initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    return YaruTabbedPage(
        onTap: (index) => _initialIndex = index,
        initialIndex: _initialIndex,
        views: [
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
        ],
        tabIcons: [
          YaruIcons.addon,
          YaruIcons.accessibility,
          YaruIcons.audio,
          YaruIcons.address_book,
          YaruIcons.television
        ],
        tabTitles: [
          'Addons',
          'Accessibility',
          'Audio',
          'Address Book',
          'Television'
        ]);
  }
}
