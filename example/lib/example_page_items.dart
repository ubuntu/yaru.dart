import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/pages/carousel_page.dart';
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
import 'package:yaru_widgets_example/widgets/row_list.dart';

final examplePageItems = <YaruPageItem>[
  YaruPageItem(
    titleBuilder: (context) => Text('YaruRow'),
    iconData: YaruIcons.format_unordered_list,
    builder: (_) => YaruPage(children: [RowList()]),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruExtraOptionRow'),
    iconData: YaruIcons.settings_filled,
    builder: (_) => ExtraOptionRowPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruLinearProgressIndicator'),
    iconData: YaruIcons.download,
    builder: (_) => YaruPage(
      children: [
        YaruLinearProgressIndicator(
          value: 50 / 100,
        )
      ],
    ),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruSelectableContainer'),
    iconData: YaruIcons.selection,
    builder: (_) => SelectableContainerPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruOptionButton'),
    iconData: YaruIcons.settings,
    builder: (_) => YaruPage(children: [OptionButtonList()]),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruSearchAppBar'),
    iconData: YaruIcons.folder_search,
    builder: (_) => YaruPage(
      children: [
        YaruSearchAppBar(
          appBarHeight: kToolbarHeight,
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
    titleBuilder: (context) => Text('YaruSection'),
    iconData: YaruIcons.window,
    builder: (_) => SectionPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruSingleInfoRow'),
    iconData: YaruIcons.format_ordered_list,
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
    titleBuilder: (context) => Text('YaruSliderRow'),
    iconData: YaruIcons.speaker_volume_medium,
    builder: (_) => SliderPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruSwitchRow'),
    iconData: YaruIcons.radio_button_filled,
    builder: (_) => SwitchRowPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => Text('YaruToggleButtonsRow'),
    iconData: YaruIcons.object_flip_horizontal,
    builder: (_) => ToggleButtonsRowPage(),
  ),
  YaruPageItem(
      titleBuilder: (context) => Text('YaruCheckboxRow'),
      iconData: YaruIcons.checkbox_button_checked,
      builder: (_) => CheckBoxRowPage(),
      searchMatches: CheckBoxRowPage.searchMatches),
  YaruPageItem(
      titleBuilder: (context) => Text('YaruTabbedPage'),
      builder: (_) => TabbedPagePage(),
      iconData: YaruIcons.tab_new),
  YaruPageItem(
      titleBuilder: (context) => Text('Color picker button'),
      builder: (_) => ColorPickerPage(),
      iconData: YaruIcons.color_select),
  YaruPageItem(
      titleBuilder: (context) => Text('YaruCarousel'),
      builder: (_) => CarouselPage(),
      iconData: YaruIcons.refresh)
];
