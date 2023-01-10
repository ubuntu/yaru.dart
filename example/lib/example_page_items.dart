import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import 'pages/banner_page.dart';
import 'pages/carousel_page.dart';
import 'pages/checkbox_page.dart';
import 'pages/color_disk_page.dart';
import 'pages/dialog_page.dart';
import 'pages/draggable_page.dart';
import 'pages/expandable_page.dart';
import 'pages/icon_button_page.dart';
import 'pages/navigation_page.dart';
import 'pages/option_button_page.dart';
import 'pages/popup_page.dart';
import 'pages/progress_indicator_page.dart';
import 'pages/radio_page.dart';
import 'pages/section_page.dart';
import 'pages/selectable_container_page.dart';
import 'pages/switch_page.dart';
import 'pages/tabbed_page_page.dart';
import 'pages/tile_page.dart';
import 'pages/window_controls_page.dart';

class PageItem {
  const PageItem({
    required this.titleBuilder,
    required this.tooltipMessage,
    required this.pageBuilder,
    required this.iconBuilder,
    this.snippetUrl,
  });

  final WidgetBuilder titleBuilder;
  final String tooltipMessage;
  final WidgetBuilder pageBuilder;
  final String? snippetUrl;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
}

final examplePageItems = <PageItem>[
  PageItem(
    titleBuilder: (context) => const Text('YaruBanner'),
    tooltipMessage: 'YaruBanner',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/banner_page.dart',
    pageBuilder: (context) => const BannerPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruCarousel'),
    tooltipMessage: 'YaruCarousel',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/carousel_page.dart',
    pageBuilder: (_) => const CarouselPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruCheckbox'),
    tooltipMessage: 'YaruCheckbox',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/checkbox_page.dart',
    pageBuilder: (context) => const CheckboxPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.checkbox_checked_filled)
        : const Icon(YaruIcons.checkbox_checked),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruColorDisk'),
    tooltipMessage: 'YaruColorDisk',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/color_disk_page.dart',
    pageBuilder: (context) => const ColorDiskPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruDraggable'),
    tooltipMessage: 'YaruDraggable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/draffable_page.dart',
    pageBuilder: (context) => const DraggablePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruExpandable'),
    tooltipMessage: 'YaruExpandable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/expandable_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.pan_down),
    pageBuilder: (_) => const ExpandablePage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruIconButton'),
    tooltipMessage: 'YaruIconButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/icon_button_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
    pageBuilder: (_) => const IconButtonPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('NavigationPage'),
    tooltipMessage: 'YaruNavigationPage',
    iconBuilder: (context, selected) => const Icon(YaruIcons.compass),
    pageBuilder: (_) => const NavigationPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruOptionButton'),
    tooltipMessage: 'YaruOptionButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/option_button_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.gear_filled)
        : const Icon(YaruIcons.gear),
    pageBuilder: (_) => const OptionButtonPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruPopupMenuButton'),
    tooltipMessage: 'YaruPopupMenuButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/option_button_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.stop),
    pageBuilder: (_) => const PopupPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruProgressIndicator'),
    tooltipMessage: 'YaruProgressIndicator',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/progress_indicator_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.download),
    pageBuilder: (_) => const ProgressIndicatorPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruRadio'),
    tooltipMessage: 'YaruRadio',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/radio_page.dart',
    pageBuilder: (context) => const RadioPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.radiobox_checked_filled)
        : const Icon(YaruIcons.radiobox_checked),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruSection'),
    tooltipMessage: 'YaruSection',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/section_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.window),
    pageBuilder: (_) => const SectionPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruSelectableContainer'),
    tooltipMessage: 'YaruSelectableContainer',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/selectable_container_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.selection),
    pageBuilder: (_) => const SelectableContainerPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruSwitch'),
    tooltipMessage: 'YaruSwitch',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/switch_page.dart',
    pageBuilder: (context) => const SwitchPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.switchbox_checked_filled)
        : const Icon(YaruIcons.switchbox),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruTabbedPage'),
    tooltipMessage: 'YaruTabbedPage',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/tabbed_page_page.dart',
    pageBuilder: (_) => const TabbedPagePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.tab_new),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruTile'),
    tooltipMessage: 'YaruTile',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/tile_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.unordered_list),
    pageBuilder: (_) => const TilePage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruDialogTitleBar'),
    tooltipMessage: 'YaruDialogTitleBar',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/dialog_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.information_filled)
        : const Icon(YaruIcons.information),
    pageBuilder: (_) => const DialogPage(),
  ),
  PageItem(
    titleBuilder: (context) => const Text('YaruWindowControl'),
    tooltipMessage: 'YaruWindowControl',
    iconBuilder: (context, selected) => const Icon(YaruIcons.window_top_bar),
    pageBuilder: (_) => const WindowControlsPage(),
  ),
];
