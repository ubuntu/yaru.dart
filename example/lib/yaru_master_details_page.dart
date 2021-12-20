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
  final TextEditingController _textEditingController = TextEditingController();
  double _sliderValue = 0;
  bool _yaruSwitchEnabled = false;
  final List<bool> _selectedValues = [false, false];
  bool _isCheckBoxSelected = false;
  @override
  Widget build(BuildContext context) {
    final pageItems = <YaruPageItem>[
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.emote_wink,
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
        iconData: YaruIcons.emote_angry,
        builder: (_) => YaruExtraOptionRow(
          actionLabel: "ActionLabel",
          iconData: YaruIcons.addon,
          onChanged: (c) {
            setState(() {
              _extraOptionValue = c;
            });
          },
          onPressed: () => showDialog(
              context: context,
              builder: (_) => YaruSimpleDialog(
                    title: 'Test',
                    closeIconData: YaruIcons.window_close,
                    children: [
                      Text(
                        'Hello YaruSimpleDialog',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
          value: _extraOptionValue,
          actionDescription: "Action Description",
        ),
      ),
      YaruPageItem(
        title: 'YaruLinearProgressIndicator',
        iconData: YaruIcons.emote_monkey,
        builder: (_) => YaruLinearProgressIndicator(
          value: 50 / 100,
        ),
      ),
      YaruPageItem(
        title: 'ImageTile',
        iconData: YaruIcons.emote_devilish,
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
        iconData: YaruIcons.emote_plain,
        builder: (_) => YaruOptionsButtonsList(),
      ),
      YaruPageItem(
        title: 'YaruOptionCard',
        iconData: YaruIcons.emote_worried,
        builder: (_) => YaruOptionCardList(),
      ),
      YaruPageItem(
        title: 'YaruPageContainer',
        iconData: YaruIcons.emote_laugh,
        builder: (_) => YaruPageContainer(
          child: Text("Just a Container 🤷‍♂️"),
          width: 200,
        ),
      ),
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.emote_cool,
        builder: (_) => YaruRowList(),
      ),
      YaruPageItem(
        title: 'YaruSearchAppBar',
        iconData: YaruIcons.emote_angel,
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
        iconData: YaruIcons.emote_glasses,
        builder: (_) => YaruSection(
          headline: 'Headline',
          headerWidget: SizedBox(
            child: CircularProgressIndicator(),
            height: 20,
            width: 20,
          ),
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
        iconData: YaruIcons.emote_embarrassed,
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
        iconData: YaruIcons.emote_uncertain,
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
        iconData: YaruIcons.emote_tired,
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
        iconData: YaruIcons.emote_raspberry,
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
      YaruPageItem(
        title: 'YaruToggleButtonsRow',
        iconData: YaruIcons.emote_shutmouth,
        builder: (_) => YaruToggleButtonsRow(
          actionLabel: "Action Label",
          labels: ["label1", "label2"],
          onPressed: (v) {
            setState(() {
              _selectedValues[v] = !_selectedValues[v];
            });
          },
          selectedValues: _selectedValues,
          actionDescription: "Action Description",
        ),
      ),
      YaruPageItem(
        title: 'YaruCheckboxRow',
        iconData: YaruIcons.emote_plain,
        builder: (_) => YaruCheckboxRow(
          value: _isCheckBoxSelected,
          text: "Text",
          enabled: true,
          onChanged: (v) {
            setState(() {
              _isCheckBoxSelected = v!;
            });
          },
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
