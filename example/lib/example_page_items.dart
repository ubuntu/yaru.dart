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
  YaruPageItem.titleFromLabel(
    label: 'YaruBanner',
    builder: (context) => const BannerPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruCarousel',
    builder: (_) => const CarouselPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruColorDisk',
    builder: (context) => const ColorDiskPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruDraggable',
    builder: (context) => const DraggablePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruExpandable',
    iconBuilder: (context, selected) => const Icon(YaruIcons.pan_down),
    builder: (_) => const ExpandablePage(),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruProgressIndicator',
    iconBuilder: (context, selected) => const Icon(YaruIcons.download),
    builder: (_) => const ProgressIndicatorPage(),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruOptionButton',
    iconBuilder: (context, selected) => const Icon(YaruIcons.settings),
    builder: (_) => const YaruPage(children: [OptionButtonPage()]),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruRoundToggleButton',
    builder: (context) => const RoundToggleButtonPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruSection',
    iconBuilder: (context, selected) => const Icon(YaruIcons.window),
    builder: (_) => const SectionPage(),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruSelectableContainer',
    iconBuilder: (context, selected) => const Icon(YaruIcons.selection),
    builder: (_) => const SelectableContainerPage(),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruTabbedPage',
    builder: (_) => const TabbedPagePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.tab_new),
  ),
  YaruPageItem.titleFromLabel(
    label: 'YaruTile',
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.format_unordered_list),
    builder: (_) => const TilePage(),
  ),
];
