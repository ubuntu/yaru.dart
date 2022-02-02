import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
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
  bool _isOvalSelected = false;
  bool _isTextSelected = false;
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
              children: [
                YaruRow(
                  enabled: true,
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
        iconData: YaruIcons.emote_angry,
        builder: (_) => YaruPage(
          children: [
            YaruExtraOptionRow(
              actionLabel: "YaruSimpleDialog",
              iconData: YaruIcons.information,
              onChanged: (c) {
                setState(() {
                  _extraOptionValue = c;
                });
              },
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => YaruSimpleDialog(
                        titleTextAlign: TextAlign.center,
                        width: 500,
                        title: 'Test',
                        closeIconData: YaruIcons.window_close,
                        children: [
                          Text(
                            'Hello YaruSimpleDialog22',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 100,
                            child: YaruSliderRow(
                                // width: 500,
                                actionLabel: 'actionLabel',
                                value: 0,
                                min: 0,
                                max: 10,
                                onChanged: (v) {}),
                          )
                        ],
                      )),
              value: _extraOptionValue,
              actionDescription: "Action Description",
            ),
            YaruExtraOptionRow(
              actionLabel: "YaruDialogTitle",
              iconData: YaruIcons.warning,
              onChanged: (c) {
                setState(() {
                  _extraOptionValue = c;
                });
              },
              onPressed: () => showDialog(
                context: context,
                builder: (_) => YaruAlertDialog(
                  closeIconData: YaruIcons.window_close,
                  title: 'YaruAlertDialog Title',
                  children: [
                    for (var i = 0; i < 20; i++)
                      YaruSingleInfoRow(
                          infoLabel: 'infoLabel', infoValue: 'infoValue')
                  ],
                  actions: [
                    OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel')),
                    ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('OK!')));
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                  width: 500,
                  height: 400,
                ),
              ),
              value: _extraOptionValue,
              actionDescription: "Action Description",
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruLinearProgressIndicator',
        iconData: YaruIcons.emote_monkey,
        builder: (_) => YaruPage(
          children: [
            YaruLinearProgressIndicator(
              value: 50 / 100,
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruSelectableContainer',
        iconData: YaruIcons.emote_devilish,
        builder: (_) => YaruPage(
          children: [
            YaruSelectableContainer(
              selected: _isImageSelected,
              onTap: () => setState(() => _isImageSelected = !_isImageSelected),
              child: kIsWeb
                  ? Image.network('assets/ubuntuhero.jpg',
                      filterQuality: FilterQuality.low, fit: BoxFit.fill)
                  : Image.file(File('assets/ubuntuhero.jpg'),
                      filterQuality: FilterQuality.low, fit: BoxFit.fill),
            ),
            SizedBox(
              height: 20,
            ),
            YaruSelectableContainer(
              selected: _isTextSelected,
              onTap: () => setState(() => _isTextSelected = !_isTextSelected),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('This is just text but can be selected!'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            YaruSelectableContainer(
              borderRadius: BorderRadius.circular(100.0),
              selected: _isOvalSelected,
              onTap: () => setState(() => _isOvalSelected = !_isOvalSelected),
              child: ClipOval(
                child: Material(
                  color: Colors.amber, // Button color
                  child: SizedBox(
                      width: 56, height: 56, child: Icon(YaruIcons.heart)),
                ),
              ),
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruOptionButton',
        iconData: YaruIcons.emote_plain,
        builder: (_) => YaruPage(children: [YaruOptionsButtonsList()]),
      ),
      YaruPageItem(
        title: 'YaruOptionCard',
        iconData: YaruIcons.emote_worried,
        builder: (_) => YaruPage(children: [YaruOptionCardList()]),
      ),
      YaruPageItem(
        title: 'YaruRow',
        iconData: YaruIcons.emote_cool,
        builder: (_) => YaruPage(children: [YaruRowList()]),
      ),
      YaruPageItem(
        title: 'YaruSearchAppBar',
        iconData: YaruIcons.emote_angel,
        builder: (_) => YaruPage(
          children: [
            YaruSearchAppBar(
              automaticallyImplyLeading: false,
              searchController: _textEditingController,
              onChanged: (v) {},
              onEscape: () {},
              searchIconData: YaruIcons.search,
              searchHint: "Search...",
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruSection',
        iconData: YaruIcons.emote_glasses,
        builder: (_) => YaruPage(
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
              // width: 400,
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
                            width: 200,
                            title: 'Test',
                            closeIconData: YaruIcons.window_close,
                            children: [
                              Text(
                                'Hello YaruSimpleDialog',
                                textAlign: TextAlign.center,
                              ),
                              YaruSliderRow(
                                  actionLabel: 'actionLabel',
                                  value: 0,
                                  min: 0,
                                  max: 10,
                                  onChanged: (v) {})
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
      YaruPageItem(
        title: 'YaruSingleInfoRow',
        iconData: YaruIcons.emote_embarrassed,
        builder: (_) => YaruPage(
          children: [
            YaruSection(headline: "YaruSingleInfoRow", children: [
              YaruSingleInfoRow(
                infoLabel: "Info Label",
                infoValue: "Info Value",
              ),
              YaruSingleInfoRow(
                infoLabel: "Info Label",
                infoValue: "Info Value",
              )
            ])
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruSliderRow',
        iconData: YaruIcons.emote_uncertain,
        builder: (_) => YaruPage(
          children: [
            YaruSliderRow(
              actionLabel: "actionLabel",
              value: _sliderValue,
              min: 0,
              max: 100,
              onChanged: (v) {
                setState(() {
                  _sliderValue = v;
                });
              },
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruSwitchRow',
        iconData: YaruIcons.emote_raspberry,
        builder: (_) => YaruPage(
          children: [
            YaruSwitchRow(
              value: _yaruSwitchEnabled,
              onChanged: (v) {
                setState(() {
                  _yaruSwitchEnabled = v;
                });
              },
              trailingWidget: Text("Trailing Widget"),
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruToggleButtonsRow',
        iconData: YaruIcons.emote_shutmouth,
        builder: (_) => YaruPage(
          children: [
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
            )
          ],
        ),
      ),
      YaruPageItem(
        title: 'YaruCheckboxRow',
        iconData: YaruIcons.emote_plain,
        builder: (_) => YaruPage(
          children: [
            YaruCheckboxRow(
              value: _isCheckBoxSelected,
              text: "Text",
              onChanged: (v) {
                setState(() {
                  _isCheckBoxSelected = v!;
                });
              },
            )
          ],
        ),
      ),
      YaruPageItem(
          title: 'YaruTabbedPage',
          builder: (_) => YaruTabbedPage(views: [
                YaruPage(
                  children: [YaruRowList()],
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
              ]),
          iconData: YaruIcons.tab_new),
      YaruPageItem(
          title: 'Color picker button',
          builder: (_) => YaruPage(
                children: [
                  Center(
                    child: YaruColorPickerButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {}),
                  )
                ],
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
