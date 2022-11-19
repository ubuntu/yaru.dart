import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'pages/banner_page.dart';
import 'pages/carousel_page.dart';
import 'pages/check_button_page.dart';
import 'pages/color_disk_page.dart';
import 'pages/controls_page.dart';
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
import 'pages/switch_button_page.dart';
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
    titleBuilder: (context) => YaruOneLineText('Controls'),
    tooltipMessage: 'Controls',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/controls_page.dart',
    pageBuilder: (context) => const ControlsPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.games),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruBanner'),
    tooltipMessage: 'YaruBanner',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/banner_page.dart',
    pageBuilder: (context) => const BannerPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.image_filled)
        : const Icon(YaruIcons.image),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruCarousel'),
    tooltipMessage: 'YaruCarousel',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/carousel_page.dart',
    pageBuilder: (_) => const CarouselPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.refresh),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruCheckButton'),
    tooltipMessage: 'YaruCheckButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/check_button_page.dart',
    pageBuilder: (context) => const CheckButtonPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.checkbox_button_checked_filled)
        : const Icon(YaruIcons.checkbox_button_checked),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruColorDisk'),
    tooltipMessage: 'YaruColorDisk',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/color_disk_page.dart',
    pageBuilder: (context) => const ColorDiskPage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.color_select),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruDraggable'),
    tooltipMessage: 'YaruDraggable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/draffable_page.dart',
    pageBuilder: (context) => const DraggablePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.drag_handle),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruExpandable'),
    tooltipMessage: 'YaruExpandable',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/expandable_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.pan_down),
    pageBuilder: (_) => const ExpandablePage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruIconButton'),
    tooltipMessage: 'YaruIconButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/icon_button_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
    pageBuilder: (_) => const IconButtonPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruOptionButton'),
    tooltipMessage: 'YaruOptionButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/option_button_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.settings_filled)
        : const Icon(YaruIcons.settings),
    pageBuilder: (_) => const OptionButtonPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruPopupMenuButton'),
    tooltipMessage: 'YaruPopupMenuButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/option_button_page.dart',
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.media_playback_stop),
    pageBuilder: (_) => const PopupPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruProgressIndicator'),
    tooltipMessage: 'YaruProgressIndicator',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/progress_indicator_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.download),
    pageBuilder: (_) => const ProgressIndicatorPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruRadioButton'),
    tooltipMessage: 'YaruRadioButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/radio_button_page.dart',
    pageBuilder: (context) => const RadioButtonPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.radio_button_checked_filled)
        : const Icon(YaruIcons.radio_button_checked),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruSection'),
    tooltipMessage: 'YaruSection',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/section_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.window),
    pageBuilder: (_) => const SectionPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruSelectableContainer'),
    tooltipMessage: 'YaruSelectableContainer',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/selectable_container_page.dart',
    iconBuilder: (context, selected) => const Icon(YaruIcons.selection),
    pageBuilder: (_) => const SelectableContainerPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruSwitchButton'),
    tooltipMessage: 'YaruSwitchButton',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/switch_button_page.dart',
    pageBuilder: (context) => const SwitchButtonPage(),
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.switch_button_checked_filled)
        : const Icon(YaruIcons.switch_button),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruTabbedPage'),
    tooltipMessage: 'YaruTabbedPage',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/tabbed_page_page.dart',
    pageBuilder: (_) => const TabbedPagePage(),
    iconBuilder: (context, selected) => const Icon(YaruIcons.tab_new),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruTile'),
    tooltipMessage: 'YaruTile',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/tile_page.dart',
    iconBuilder: (context, selected) =>
        const Icon(YaruIcons.format_unordered_list),
    pageBuilder: (_) => const TilePage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruTitleBar'),
    tooltipMessage: 'YaruTitleBar',
    snippetUrl:
        'https://raw.githubusercontent.com/ubuntu/yaru_widgets.dart/main/example/lib/pages/dialog_page.dart',
    iconBuilder: (context, selected) => selected
        ? const Icon(YaruIcons.information_filled)
        : const Icon(YaruIcons.information),
    pageBuilder: (_) => const DialogPage(),
  ),
  PageItem(
    titleBuilder: (context) => YaruOneLineText('YaruWindowControl'),
    tooltipMessage: 'YaruWindowControl',
    iconBuilder: (context, selected) => const Icon(YaruIcons.window_top_bar),
    pageBuilder: (_) => const WindowControlsPage(),
  ),
];
