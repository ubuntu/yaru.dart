import 'package:collection/collection.dart';
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
    required this.title,
    this.titleBuilder,
    required this.pageBuilder,
    required this.iconBuilder,
    this.snippetUrl,
  });

  final String title;
  final WidgetBuilder? titleBuilder;
  final WidgetBuilder pageBuilder;
  final String? snippetUrl;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
}

final examplePageItems = <PageItem>[
  PageItem(
    title: 'YaruBanner',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/banner_page.dart',
    pageBuilder: (context) => const BannerPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  PageItem(
    title: 'YaruCarousel',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/carousel_page.dart',
    pageBuilder: (_) => const CarouselPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  PageItem(
    title: 'YaruCheckbox',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/checkbox_page.dart',
    pageBuilder: (context) => const CheckboxPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.checkbox_checked_filled)
        : const Icon(YaruIcons.checkbox_checked),
  ),
  PageItem(
    title: 'YaruColorDisk',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/color_disk_page.dart',
    pageBuilder: (context) => const ColorDiskPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  PageItem(
    title: 'YaruDraggable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/draffable_page.dart',
    pageBuilder: (context) => const DraggablePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  PageItem(
    title: 'YaruExpandable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/expandable_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.pan_down),
    pageBuilder: (_) => const ExpandablePage(),
  ),
  PageItem(
    title: 'YaruIconButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/icon_button_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
    pageBuilder: (_) => const IconButtonPage(),
  ),
  PageItem(
    title: 'YaruNavigationPage',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.compass_filled)
        : const Icon(YaruIcons.compass),
    pageBuilder: (_) => const NavigationPage(),
  ),
  PageItem(
    title: 'YaruOptionButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/option_button_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.gear_filled)
        : const Icon(YaruIcons.gear),
    pageBuilder: (_) => const OptionButtonPage(),
  ),
  PageItem(
    title: 'YaruPopupMenuButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/option_button_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.stop),
    pageBuilder: (_) => const PopupPage(),
  ),
  PageItem(
    title: 'YaruProgressIndicator',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/progress_indicator_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.download_filled)
        : const Icon(YaruIcons.download),
    pageBuilder: (_) => const ProgressIndicatorPage(),
  ),
  PageItem(
    title: 'YaruRadio',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/radio_page.dart',
    pageBuilder: (context) => const RadioPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.radiobox_checked_filled)
        : const Icon(YaruIcons.radiobox_checked),
  ),
  PageItem(
    title: 'YaruSection',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/section_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.window_filled)
        : const Icon(YaruIcons.window),
    pageBuilder: (_) => const SectionPage(),
  ),
  PageItem(
    title: 'YaruSelectableContainer',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/selectable_container_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.selection),
    pageBuilder: (_) => const SelectableContainerPage(),
  ),
  PageItem(
    title: 'YaruSwitch',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/switch_page.dart',
    pageBuilder: (context) => const SwitchPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.switchbox_checked_filled)
        : const Icon(YaruIcons.switchbox),
  ),
  PageItem(
    title: 'YaruTabbedPage',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/tabbed_page_page.dart',
    pageBuilder: (_) => const TabbedPagePage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.tab_new_filled)
        : const Icon(YaruIcons.tab_new),
  ),
  PageItem(
    title: 'YaruTile',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/tile_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.unordered_list),
    pageBuilder: (_) => const TilePage(),
  ),
  PageItem(
    title: 'YaruDialogTitleBar',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/dialog_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.information_filled)
        : const Icon(YaruIcons.information),
    pageBuilder: (_) => const DialogPage(),
  ),
  PageItem(
    title: 'YaruWindowControl',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.window_top_bar_filled)
        : const Icon(YaruIcons.window_top_bar),
    pageBuilder: (_) => const WindowControlsPage(),
  ),
].sortedBy((page) => page.title);
