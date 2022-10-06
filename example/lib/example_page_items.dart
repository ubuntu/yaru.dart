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
    icon: const Icon(YaruIcons.image),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruCarousel'),
    builder: (_) => const CarouselPage(),
    icon: const Icon(YaruIcons.refresh),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruColorDisk'),
    builder: (context) => const ColorDiskPage(),
    icon: const Icon(YaruIcons.color_select),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruDraggable'),
    builder: (context) => const DraggablePage(),
    icon: const Icon(YaruIcons.drag_handle),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruExpandable'),
    icon: const Icon(YaruIcons.pan_down),
    builder: (_) => const ExpandablePage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruProgressIndicator'),
    icon: const Icon(YaruIcons.download),
    builder: (_) => const ProgressIndicatorPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruOptionButton'),
    icon: const Icon(YaruIcons.settings),
    builder: (_) => const YaruPage(children: [OptionButtonPage()]),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruRoundToggleButton'),
    builder: (context) => const RoundToggleButtonPage(),
    icon: const Icon(YaruIcons.app_grid),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruSection'),
    icon: const Icon(YaruIcons.window),
    builder: (_) => const SectionPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) =>
        YaruPageItemTitle.text('YaruSelectableContainer'),
    icon: const Icon(YaruIcons.selection),
    builder: (_) => const SelectableContainerPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTabbedPage'),
    builder: (_) => const TabbedPagePage(),
    icon: const Icon(YaruIcons.tab_new),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTile'),
    icon: const Icon(YaruIcons.format_unordered_list),
    builder: (_) => const TilePage(),
    selectedIcon: const SizedBox(
      height: 20,
      child: YaruCircularProgressIndicator(strokeWidth: 2),
    ),
  ),
];
