import 'package:flutter/material.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/widgets/list_yaru_options.dart';
import 'package:yaru_widgets_example/widgets/yaru_option_card_list.dart';
import 'package:yaru_widgets_example/widgets/yaru_row_list.dart';

const kMinSectionWidth = 400.0;

class YaruHome extends StatefulWidget {
  const YaruHome({Key? key}) : super(key: key);

  @override
  State<YaruHome> createState() => _YaruHomeState();
}

class _YaruHomeState extends State<YaruHome> {
  bool _extraOptionValue = false;
  bool _isImageSelected = false;
  final _textEditingController = TextEditingController();
  double _sliderValue = 0;

  double sectionWidth = kMinSectionWidth;
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
            YaruPage(
              child: YaruRow(
                enabled: true,
                trailingWidget: Text('trailingWidget'),
                actionWidget: Text('actionWidget'),
                description: 'description',
              ),
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruExtraOptionRow',
        iconData: YaruIcons.emote_angry,
        builder: (_) => YaruPage(
          child: YaruExtraOptionRow(
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
      ),
      YaruPageItem(
        title: 'YaruLinearProgressIndicator',
        iconData: YaruIcons.emote_monkey,
        builder: (_) => YaruPage(
          child: YaruLinearProgressIndicator(
            value: 50 / 100,
          ),
        ),
      ),
      YaruPageItem(
        title: 'ImageTile',
        iconData: YaruIcons.emote_devilish,
        builder: (_) => YaruPage(
          child: ImageTile(
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
      ),
      YaruPageItem(
        title: 'YaruOptionButton',
        iconData: YaruIcons.emote_plain,
        builder: (_) => YaruPage(child: YaruOptionsButtonsList()),
      ),
      YaruPageItem(
        title: 'YaruOptionCard',
        iconData: YaruIcons.emote_worried,
        builder: (_) => YaruPage(child: YaruOptionCardList()),
      ),
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.emote_cool,
        builder: (_) => YaruPage(child: YaruRowList()),
      ),
      YaruPageItem(
        title: 'YaruSearchAppBar',
        iconData: YaruIcons.emote_angel,
        builder: (_) => YaruPage(
          child: YaruSearchAppBar(
            automaticallyImplyLeading: false,
            searchController: _textEditingController,
            onChanged: (v) {},
            onEscape: () {},
            searchIconData: YaruIcons.search,
            searchHint: "Search...",
          ),
        ),
      ),
      YaruPageItem(
        title: 'YaruSection',
        iconData: YaruIcons.emote_glasses,
        builder: (_) => YaruPage(
          child: Column(
            children: [
              YaruSection(
                headline: 'Headline',
                headerWidget: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,
                ),
                children: [
                  YaruRow(
                    enabled: true,
                    trailingWidget: Text("Trailing Widget"),
                    actionWidget: Text("Action Widget"),
                    description: "Description",
                  ),
                ],
                width: 400,
              ),
              YaruSection(
                headline: 'Headline',
                headerWidget: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,
                ),
                children: [
                  YaruRow(
                    enabled: true,
                    trailingWidget: Text("Trailing Widget"),
                    actionWidget: Text("Action Widget"),
                    description: "Description",
                  ),
                ],
                width: 300,
              ),
              YaruSection(
                width: sectionWidth,
                headline: 'Headline',
                headerWidget: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,
                ),
                children: [
                  YaruRow(
                    enabled: true,
                    trailingWidget: Text("Trailing Widget"),
                    actionWidget: Text("Action Widget"),
                    description: "Description",
                  ),
                  YaruSliderRow(
                    actionLabel: "YaruSection width",
                    value: sectionWidth,
                    min: kMinSectionWidth,
                    max: 1000,
                    onChanged: (v) {
                      setState(() {
                        sectionWidth = v;
                      });
                    },
                  ),
                  YaruSwitchRow(
                    value: _yaruSwitchEnabled,
                    onChanged: (v) {
                      setState(() {
                        _yaruSwitchEnabled = v;
                      });
                    },
                    trailingWidget: Text("Trailing Widget"),
                  ),
                  YaruSingleInfoRow(
                    infoLabel: "Info Label",
                    infoValue: "Info Value",
                  ),
                  YaruToggleButtonsRow(
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
                  YaruExtraOptionRow(
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
                ],
                // width: 800,
              )
            ],
          ),
        ),
      ),
      YaruPageItem(
        title: 'YaruSingleInfoRow',
        iconData: YaruIcons.emote_embarrassed,
        builder: (_) => YaruPage(
          child: YaruSection(headline: "YaruSingleInfoRow", children: [
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
      ),
      YaruPageItem(
        title: 'YaruSliderRow',
        iconData: YaruIcons.emote_uncertain,
        builder: (_) => YaruPage(
          child: YaruSliderRow(
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
      ),
      YaruPageItem(
        title: 'YaruSwitchRow',
        iconData: YaruIcons.emote_raspberry,
        builder: (_) => YaruPage(
          child: YaruSwitchRow(
            value: _yaruSwitchEnabled,
            onChanged: (v) {
              setState(() {
                _yaruSwitchEnabled = v;
              });
            },
            trailingWidget: Text("Trailing Widget"),
          ),
        ),
      ),
      YaruPageItem(
        title: 'YaruToggleButtonsRow',
        iconData: YaruIcons.emote_shutmouth,
        builder: (_) => YaruPage(
          child: YaruToggleButtonsRow(
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
      ),
      YaruPageItem(
        title: 'YaruCheckboxRow',
        iconData: YaruIcons.emote_plain,
        builder: (_) => YaruPage(
          child: YaruCheckboxRow(
            value: _isCheckBoxSelected,
            text: "Text",
            onChanged: (v) {
              setState(() {
                _isCheckBoxSelected = v!;
              });
            },
          ),
        ),
      ),
      YaruPageItem(
          title: 'YaruTabbedPage',
          builder: (_) => YaruTabbedPage(views: [
                YaruPage(
                  child: YaruRowList(),
                ),
                YaruPage(
                    child: YaruSection(
                  headline: 'Accessibility',
                  children: [Text('accessibility')],
                )),
                YaruPage(child: Text('Audio')),
                YaruPage(child: Text('AddressBook')),
                YaruPage(child: Text('Television'))
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
              ]),
          iconData: YaruIcons.tab_new),
      YaruPageItem(
          title: 'Color picker button',
          builder: (_) => YaruPage(
                child: Center(
                  child: YaruColorPickerButton(
                      color: Theme.of(context).primaryColor, onPressed: () {}),
                ),
              ),
          iconData: YaruIcons.color_select)
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
