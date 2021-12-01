import 'package:flutter/material.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/widgets/list_yaru_options.dart';
import 'package:yaru_widgets_example/widgets/yaru_option_card_list.dart';
import 'package:yaru_widgets_example/widgets/yaru_row_list.dart';

class YaruHome extends StatefulWidget {
  const YaruHome({Key? key}) : super(key: key);

  @override
  State<YaruHome> createState() => _YaruHomeState();
}

class _YaruHomeState extends State<YaruHome> {
  bool _extraOptionValue = false;
  bool _isImageSelected = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pageItems = <YaruPageItem>[
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => Column(
          children: const [
            YaruSection(
              headline: 'YaruRow',
              children: [
                YaruRow(
                  trailingWidget: Text('trailingWidget'),
                  actionWidget: Text('actionWidget'),
                  description: 'description',
                )
              ],
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruExtraOptionRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruExtraOptionRow(
          actionLabel: "ActionLabel",
          iconData: YaruIcons.addon,
          onChanged: (c) {
            setState(() {
              _extraOptionValue = c;
            });
          },
          onPressed: () {},
          value: _extraOptionValue,
          actionDescription: "Action Description",
        ),
      ),
      YaruPageItem(
        title: 'ImageTile',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => ImageTile(
          currentlySelected: _isImageSelected,
          onTap: () {
            setState(() {
              if (_isImageSelected) {
                _isImageSelected = false;
              } else {
                _isImageSelected = true;
              }
            });
          },
          path: "assets/ubuntuhero.jpg",
        ),
      ),
      YaruPageItem(
        title: 'YaruOptionButton',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => const YaruOptionsButtonsList(),
      ),
      YaruPageItem(
        title: 'YaruOptionCard',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => const YaruOptionCardList(),
      ),
      YaruPageItem(
        title: 'YaruPageContainer',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => const YaruPageContainer(
          child: Text("Just a Container 🤷‍♂️"),
          width: 200,
        ),
      ),
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => const YaruRowList(),
      ),
      YaruPageItem(
        title: 'YaruSearchAppBar',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruSearchAppBar(
          searchController: _textEditingController,
          onChanged: (v){},
          onEscape: (){},
          searchIconData: YaruIcons.search,
          appBarHeight: 10.0,
          searchHint: "Search...",
        ),
      ),
    ];

    return YaruMasterDetailPage(
      appBarHeight: 48,
      leftPaneWidth: 280,
      previousIconData: YaruIcons.go_previous,
      searchHint: 'Search...',
      searchIconData: YaruIcons.search,
      pageItems: pageItems,

    );
  }
}
