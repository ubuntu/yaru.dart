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

class PageItem {
  const PageItem({
    required this.titleBuilder,
    required this.pageBuilder,
    required this.iconBuilder,
  });

  final WidgetBuilder titleBuilder;
  final WidgetBuilder pageBuilder;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
}

final examplePageItems = <PageItem>[
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruBanner'),
    pageBuilder: (context) => const BannerPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruCarousel'),
    pageBuilder: (_) => const CarouselPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruColorDisk'),
    pageBuilder: (context) => const ColorDiskPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruDraggable'),
    pageBuilder: (context) => const DraggablePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruExpandable'),
    iconBuilder: (context, selected) => const Icon(YaruIcons.pan_down),
    pageBuilder: (_) => const ExpandablePage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruOptionButton'),
    iconBuilder: (context, selected) => const Icon(YaruIcons.settings),
    pageBuilder: (_) => const OptionButtonPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruProgressIndicator'),
    iconBuilder: (context, selected) => const Icon(YaruIcons.download),
    pageBuilder: (_) => const ProgressIndicatorPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruRoundToggleButton'),
    pageBuilder: (context) => const RoundToggleButtonPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruSection'),
    iconBuilder: (context, selected) => const Icon(YaruIcons.window),
    pageBuilder: (_) => const SectionPage(),
  ),
  PageItem(
    titleBuilder: (context) =>
        YaruPageItemTitle.text('YaruSelectableContainer'),
    iconBuilder: (context, selected) => const Icon(YaruIcons.selection),
    pageBuilder: (_) => const SelectableContainerPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTabbedPage'),
    pageBuilder: (_) => const TabbedPagePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.tab_new),
  ),
  PageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTile'),
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.format_unordered_list),
    pageBuilder: (_) => const TilePage(),
  ),
];
