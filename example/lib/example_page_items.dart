import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'pages/banner_page.dart';
import 'pages/carousel_page.dart';
import 'pages/color_disk_page.dart';
import 'pages/draggable_page.dart';
import 'pages/expandable_page.dart';
import 'pages/option_button_page.dart';
import 'pages/progress_indicator_page.dart';
import 'pages/round_toggle_button_page.dart';
import 'pages/section_page.dart';
import 'pages/selectable_container_page.dart';
import 'pages/tabbed_page_page.dart';
import 'pages/tile_page.dart';

final examplePageItems = <YaruPageItem>[
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruBanner'),
    builder: (context) => const BannerPage(),
    icon: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruCarousel'),
    builder: (_) => const CarouselPage(),
    icon: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruColorDisk'),
    builder: (context) => const ColorDiskPage(),
    icon: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruDraggable'),
    builder: (context) => const DraggablePage(),
    icon: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruExpandable'),
    icon: (context, selected) => const Icon(YaruIcons.pan_down),
    builder: (_) => const ExpandablePage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruProgressIndicator'),
    icon: (context, selected) => const Icon(YaruIcons.download),
    builder: (_) => const ProgressIndicatorPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruOptionButton'),
    icon: (context, selected) => const Icon(YaruIcons.settings),
    builder: (_) => const YaruPage(children: [OptionButtonPage()]),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruRoundToggleButton'),
    builder: (context) => const RoundToggleButtonPage(),
    icon: (context, selected) => const Icon(YaruIcons.app_grid),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruSection'),
    icon: (context, selected) => const Icon(YaruIcons.window),
    builder: (_) => const SectionPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) =>
        YaruPageItemTitle.text('YaruSelectableContainer'),
    icon: (context, selected) => const Icon(YaruIcons.selection),
    builder: (_) => const SelectableContainerPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTabbedPage'),
    builder: (_) => const TabbedPagePage(),
    icon: (context, selected) => const Icon(YaruIcons.tab_new),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTile'),
    icon: (context, selected) => const Icon(YaruIcons.format_unordered_list),
    builder: (_) => const TilePage(),
  ),
];
