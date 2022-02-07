import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/pages/check_box_row_page.dart';
import 'package:yaru_widgets_example/pages/color_picker_page.dart';
import 'package:yaru_widgets_example/pages/extra_option_row_page.dart';
import 'package:yaru_widgets_example/pages/section_page.dart';
import 'package:yaru_widgets_example/pages/selectable_container_page.dart';
import 'package:yaru_widgets_example/pages/slider_page.dart';
import 'package:yaru_widgets_example/pages/switch_row_page.dart';
import 'package:yaru_widgets_example/pages/tabbed_page_page.dart';
import 'package:yaru_widgets_example/pages/toggle_buttons_row_page.dart';
import 'package:yaru_widgets_example/widgets/option_button_list.dart';
import 'package:yaru_widgets_example/widgets/card_list.dart';
import 'package:yaru_widgets_example/widgets/row_list.dart';

final examplePageItems = <YaruPageItem>[
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
    builder: (_) => ExtraOptionRowPage(),
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
    builder: (_) => SelectableContainerPage(),
  ),
  YaruPageItem(
    title: 'YaruOptionButton',
    iconData: YaruIcons.emote_plain,
    builder: (_) => YaruPage(children: [OptionButtonList()]),
  ),
  YaruPageItem(
    title: 'YaruOptionCard',
    iconData: YaruIcons.emote_worried,
    builder: (_) => YaruPage(children: [CardList()]),
  ),
  YaruPageItem(
    title: 'YaruRow',
    iconData: YaruIcons.emote_cool,
    builder: (_) => YaruPage(children: [RowList()]),
  ),
  YaruPageItem(
    title: 'YaruSearchAppBar',
    iconData: YaruIcons.emote_angel,
    builder: (_) => YaruPage(
      children: [
        YaruSearchAppBar(
          automaticallyImplyLeading: false,
          searchController: TextEditingController(),
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
    builder: (_) => SectionPage(),
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
    builder: (_) => SliderPage(),
  ),
  YaruPageItem(
    title: 'YaruSwitchRow',
    iconData: YaruIcons.emote_raspberry,
    builder: (_) => SwitchRowPage(),
  ),
  YaruPageItem(
    title: 'YaruToggleButtonsRow',
    iconData: YaruIcons.emote_shutmouth,
    builder: (_) => ToggleButtonsRowPage(),
  ),
  YaruPageItem(
    title: 'YaruCheckboxRow',
    iconData: YaruIcons.emote_plain,
    builder: (_) => CheckBoxRowPage(),
  ),
  YaruPageItem(
      title: 'YaruTabbedPage',
      builder: (_) => TabbedPagePage(),
      iconData: YaruIcons.tab_new),
  YaruPageItem(
      title: 'Color picker button',
      builder: (_) => ColorPickerPage(),
      iconData: YaruIcons.color_select)
];
