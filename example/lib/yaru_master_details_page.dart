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
  double _sliderValue = 0;
  bool _yaruSwitchEnabled = false;
  @override
  Widget build(BuildContext context) {
    final pageItems = <YaruPageItem>[
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => Column(
          children: const [
            YaruRow(
              trailingWidget: Text('trailingWidget'),
              actionWidget: Text('actionWidget'),
              description: 'description',
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
        builder: (_) => YaruOptionsButtonsList(),
      ),
      YaruPageItem(
        title: 'YaruOptionCard',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruOptionCardList(),
      ),
      YaruPageItem(
        title: 'YaruPageContainer',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruPageContainer(
          child: Text("Just a Container 🤷‍♂️"),
          width: 200,
        ),
      ),
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruRowList(),
      ),
      YaruPageItem(
        title: 'YaruSearchAppBar',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruSearchAppBar(
          searchController: _textEditingController,
          onChanged: (v) {},
          onEscape: () {},
          searchIconData: YaruIcons.search,
          appBarHeight: 10.0,
          searchHint: "Search...",
        ),
      ),
      YaruPageItem(
        title: 'YaruSection',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruSection(
          headline: 'Headline',
          children: [
            YaruRow(
              trailingWidget: Text("Trailing Widget"),
              actionWidget: Text("Action Widget"),
              description: "Description",
            ),
          ],
          width: 300,
        ),
      ),
      YaruPageItem(
        title: 'YaruSingleInfoRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruSection(headline: "YaruSingleInfoRow", children: [
          YaruSingleInfoRow(
            infoLabel: "Info Label",
            infoValue: "Info Value",
          ),
          YaruSingleInfoRow(
            infoLabel: "Info Label",
            infoValue: "Info Value",
          )
        ]),
      ),
      YaruPageItem(
        title: 'YaruSliderRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruSliderRow(
          actionLabel: "actionLabel",
          value: _sliderValue,
          min: 0,
          max: 100,
          onChanged: (v) {
            setState(() {
              _sliderValue = v;
            });
          },
        ),
      ),
      YaruPageItem(
        title: 'YaruSliderSecondary',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruSliderSecondary(
          label: "Label",
          value: _sliderValue,
          min: 0,
          max: 100,
          onChanged: (v) {
            setState(() {
              _sliderValue = v;
            });
          },
          enabled: true,
        ),
      ),
      YaruPageItem(
        title: 'YaruSwitchRow',
        iconData: YaruIcons.checkbox_button_filled,
        builder: (_) => YaruSwitchRow(
          value: _yaruSwitchEnabled,
          onChanged: (v) {
            setState(() {
              _yaruSwitchEnabled = v;
            });
          },
          trailingWidget: Text("Trailing Widget"),
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
