import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

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
            children: [
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
              )
            ],
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
