import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'pages/banner_page.dart';
import 'pages/carousel_page.dart';
import 'pages/check_button_page.dart';
import 'pages/color_disk_page.dart';
import 'pages/dialog_page.dart';
import 'pages/draggable_page.dart';
import 'pages/expandable_page.dart';
import 'pages/icon_button_page.dart';
import 'pages/option_button_page.dart';
import 'pages/popup_page.dart';
import 'pages/progress_indicator_page.dart';
import 'pages/radio_button_page.dart';
import 'pages/section_page.dart';
import 'pages/selectable_container_page.dart';
import 'pages/tabbed_page_page.dart';
import 'pages/tile_page.dart';

class PageItem {
  const PageItem({
    required this.titleBuilder,
    required this.tooltipMessage,
    required this.pageBuilder,
    required this.iconBuilder,
  });

  final WidgetBuilder titleBuilder;
  final String tooltipMessage;
  final WidgetBuilder pageBuilder;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
}

final examplePageItems = <PageItem>[
  PageItem(
    titleBuilder: (context) => const Text('YaruBanner'),
    tooltipMessage: 'YaruBanner',
    pageBuilder: (context) => const BannerPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruCarousel'),
    tooltipMessage: 'YaruCarousel',
    pageBuilder: (_) => const CarouselPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruCheckButton'),
    tooltipMessage: 'YaruCheckButton',
    pageBuilder: (context) => const CheckButtonPage(),
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.checkbox_button_checked),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruColorDisk'),
    tooltipMessage: 'YaruColorDisk',
    pageBuilder: (context) => const ColorDiskPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruDraggable'),
    tooltipMessage: 'YaruDraggable',
    pageBuilder: (context) => const DraggablePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruExpandable'),
    tooltipMessage: 'YaruExpandable',
    iconBuilder: (context, selected) => const Icon(YaruIcons.pan_down),
    pageBuilder: (_) => const ExpandablePage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruIconButton'),
    tooltipMessage: 'YaruIconButton',
    iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
    pageBuilder: (_) => const IconButtonPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruOptionButton'),
    tooltipMessage: 'YaruOptionButton',
    iconBuilder: (context, selected) => const Icon(YaruIcons.settings),
    pageBuilder: (_) => const OptionButtonPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruPopupMenuButton'),
    tooltipMessage: 'YaruPopupMenuButton',
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.media_playback_stop),
    pageBuilder: (_) => const PopupPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruProgressIndicator'),
    tooltipMessage: 'YaruProgressIndicator',
    iconBuilder: (context, selected) => const Icon(YaruIcons.download),
    pageBuilder: (_) => const ProgressIndicatorPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruRadioButton'),
    tooltipMessage: 'YaruRadioButton',
    pageBuilder: (context) => const RadioButtonPage(),
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.radio_button_checked),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruSection'),
    tooltipMessage: 'YaruSection',
    iconBuilder: (context, selected) => const Icon(YaruIcons.window),
    pageBuilder: (_) => const SectionPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruSelectableContainer'),
    tooltipMessage: 'YaruSelectableContainer',
    iconBuilder: (context, selected) => const Icon(YaruIcons.selection),
    pageBuilder: (_) => const SelectableContainerPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruTabbedPage'),
    tooltipMessage: 'YaruTabbedPage',
    pageBuilder: (_) => const TabbedPagePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.tab_new),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruTile'),
    tooltipMessage: 'YaruTile',
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.format_unordered_list),
    pageBuilder: (_) => const TilePage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruTitleBar'),
    tooltipMessage: 'YaruTitleBar',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.information_filled)
        : const Icon(YaruIcons.information),
    pageBuilder: (_) => const DialogPage(),
  ),
];
