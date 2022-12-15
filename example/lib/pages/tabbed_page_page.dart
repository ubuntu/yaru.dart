import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class TabbedPagePage extends StatefulWidget {
  const TabbedPagePage({
    super.key,
  });

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
        GridView(
          padding: const EdgeInsets.all(kYaruPagePadding),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 110,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            maxCrossAxisExtent: 550,
          ),
          children: [
            for (int i = 0; i < 20; i++)
              YaruBanner.tile(
                title: Text('YaruBanner $i'),
                subtitle: const Text('Description'),
                icon: Image.asset('assets/ubuntuhero.jpg'),
                onTap: () => showAboutDialog(context: context),
              )
          ],
        ),
        const Center(child: Text('Accessibility')),
        const Center(child: Text('Audio')),
        const Center(child: Text('AddressBook')),
        const Center(child: Text('Television')),
      ],
      tabIcons: const [
        YaruIcons.puzzle_piece,
        YaruIcons.human,
        YaruIcons.music_note,
        YaruIcons.address_book,
        YaruIcons.television
      ].map(Icon.new).toList(),
      tabTitles: const [
        'Addons',
        'Accessibility',
        'Audio',
        'Address Book',
        'Television'
      ],
    );
  }
}
