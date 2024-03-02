import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'pages/autocomplete_page.dart';
import 'pages/banner_page.dart';
import 'pages/carousel_page.dart';
import 'pages/checkbox_page.dart';
import 'pages/choice_chip_bar_page.dart';
import 'pages/clip_page.dart';
import 'pages/color_disk_page.dart';
import 'pages/dialog_page.dart';
import 'pages/draggable_page.dart';
import 'pages/expandable_page.dart';
import 'pages/expansion_panel_page.dart';
import 'pages/icon_button_page.dart';
import 'pages/icons_page/icons_page.dart';
import 'pages/navigation_page.dart';
import 'pages/option_button_page.dart';
import 'pages/page_indicator.dart';
import 'pages/popup_page.dart';
import 'pages/progress_indicator_page.dart';
import 'pages/radio_page.dart';
import 'pages/search_field_page.dart';
import 'pages/section_page.dart';
import 'pages/selectable_container_page.dart';
import 'pages/switch_page.dart';
import 'pages/tab_bar_page.dart';
import 'pages/theme_page/theme_page.dart';
import 'pages/tile_page.dart';
import 'pages/window_controls_page.dart';

class PageItem {
  const PageItem({
    required this.title,
    this.titleBuilder,
    required this.pageBuilder,
    required this.iconBuilder,
    this.snippetUrl,
    this.supportedLayouts = const {YaruMasterDetailPage, YaruNavigationPage},
  });

  final String title;
  final WidgetBuilder? titleBuilder;
  final WidgetBuilder pageBuilder;
  final String? snippetUrl;
  final Widget Function(BuildContext context, bool selected) iconBuilder;
  final Set<Type> supportedLayouts;
}

final examplePageItems = <PageItem>[
  PageItem(
    title: 'YaruAutocomplete',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/autocomplete_page.dart',
    pageBuilder: (context) => const AutocompletePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.question),
  ),
  PageItem(
    title: 'YaruBanner',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/banner_page.dart',
    pageBuilder: (context) => const BannerPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  PageItem(
    title: 'YaruCarousel',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/carousel_page.dart',
    pageBuilder: (_) => const CarouselPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  PageItem(
    title: 'YaruCheckbox',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/checkbox_page.dart',
    pageBuilder: (context) => const CheckboxPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.checkbox_checked_filled)
        : const Icon(YaruIcons.checkbox_checked),
  ),
  PageItem(
    title: 'YaruChoiceChipBar',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/choice_chip_bar_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.paper_clip),
    pageBuilder: (_) => const ChoiceChipBarPage(),
  ),
  PageItem(
    title: 'YaruClip',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/clip_page.dart',
    pageBuilder: (context) => const ClipPage(),
    iconBuilder: (context, selected) => Transform.scale(
      scaleX: -1,
      child: selected
          ? const Icon(YaruIcons.network_cellular_signal_excellent)
          : const Icon(YaruIcons.network_cellular_signal_none),
    ),
  ),
  PageItem(
    title: 'YaruColorDisk',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/color_disk_page.dart',
    pageBuilder: (context) => const ColorDiskPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  PageItem(
    title: 'YaruDraggable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/draffable_page.dart',
    pageBuilder: (context) => const DraggablePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  PageItem(
    title: 'YaruExpandable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/expandable_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.pan_down),
    pageBuilder: (_) => const ExpandablePage(),
  ),
  PageItem(
    title: 'YaruExpansionPanel',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/expansion_panel_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.ordered_list_new),
    pageBuilder: (_) => const ExpansionPanelPage(),
  ),
  PageItem(
    title: 'YaruIconButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/icon_button_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
    pageBuilder: (_) => const IconButtonPage(),
  ),
  PageItem(
    title: 'YaruNavigationPage',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.compass_filled)
        : const Icon(YaruIcons.compass),
    pageBuilder: (_) => const NavigationPage(),
    supportedLayouts: {YaruMasterDetailPage},
  ),
  PageItem(
    title: 'YaruOptionButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/option_button_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.gear_filled)
        : const Icon(YaruIcons.gear),
    pageBuilder: (_) => const OptionButtonPage(),
  ),
  PageItem(
    title: 'YaruPageIndicator',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/page_indicator.dart',
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.view_more_horizontal),
    pageBuilder: (_) => const PageIndicatorPage(),
  ),
  PageItem(
    title: 'YaruPopupMenuButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/popup_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.stop),
    pageBuilder: (_) => const PopupPage(),
  ),
  PageItem(
    title: 'YaruProgressIndicator',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/progress_indicator_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.download_filled)
        : const Icon(YaruIcons.download),
    pageBuilder: (_) => const ProgressIndicatorPage(),
  ),
  PageItem(
    title: 'YaruRadio',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/radio_page.dart',
    pageBuilder: (context) => const RadioPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.radiobox_checked_filled)
        : const Icon(YaruIcons.radiobox_checked),
  ),
  PageItem(
    title: 'YaruSearchField',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/search_field_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.search_filled)
        : const Icon(YaruIcons.search),
    pageBuilder: (_) => const SearchFieldPage(),
  ),
  PageItem(
    title: 'YaruSection',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/section_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.window_filled)
        : const Icon(YaruIcons.window),
    pageBuilder: (_) => const SectionPage(),
  ),
  PageItem(
    title: 'YaruSelectableContainer',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/selectable_container_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.selection),
    pageBuilder: (_) => const SelectableContainerPage(),
  ),
  PageItem(
    title: 'YaruSwitch',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/switch_page.dart',
    pageBuilder: (context) => const SwitchPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.switchbox_checked_filled)
        : const Icon(YaruIcons.switchbox),
  ),
  PageItem(
    title: 'YaruTabBar',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/tab_bar_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.tab_new),
    pageBuilder: (_) => const TabBarPage(),
  ),
  PageItem(
    title: 'YaruTile',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/tile_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.unordered_list),
    pageBuilder: (_) => const TilePage(),
  ),
  PageItem(
    title: 'YaruDialogTitleBar',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru.dart/main/example/lib/pages/dialog_page.dart',
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
  PageItem(
    title: 'YaruIcons',
    titleBuilder: createIconsPageAppBar,
    pageBuilder: (context) {
      return const IconsPage();
    },
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.placeholder_icon_filled)
        : const Icon(YaruIcons.placeholder_icon),
  ),
  PageItem(
    title: 'YaruTheme',
    pageBuilder: (context) {
      return const ThemePage();
    },
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.colors_filled)
        : const Icon(YaruIcons.colors),
  ),
].sortedBy((page) => page.title);
