import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'pages/banner_page.dart';
import 'pages/carousel_page.dart';
import 'pages/color_disk_page.dart';
import 'pages/draggable_page.dart';
import 'pages/option_button_page.dart';
import 'pages/round_toggle_button_page.dart';
import 'pages/section_page.dart';
import 'pages/selectable_container_page.dart';
import 'pages/tabbed_page_page.dart';
import 'widgets/tile_list.dart';

const _lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

final examplePageItems = <YaruPageItem>[
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTile'),
    iconData: YaruIcons.format_unordered_list,
    builder: (_) => const YaruPage(children: [TileList()]),
    itemWidget: const SizedBox(
      height: 20,
      child: YaruCircularProgressIndicator(strokeWidth: 2),
    ),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruProgressIndicator'),
    iconData: YaruIcons.download,
    builder: (_) => const YaruPage(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: YaruCircularProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: YaruCircularProgressIndicator(
            value: .75,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: YaruLinearProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: YaruLinearProgressIndicator(
            value: .75,
          ),
        ),
      ],
    ),
  ),
  YaruPageItem(
    titleBuilder: (context) =>
        YaruPageItemTitle.text('YaruSelectableContainer'),
    iconData: YaruIcons.selection,
    builder: (_) => const SelectableContainerPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruOptionButton'),
    iconData: YaruIcons.settings,
    builder: (_) => const YaruPage(children: [OptionButtonPage()]),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruSection'),
    iconData: YaruIcons.window,
    builder: (_) => const SectionPage(),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruTabbedPage'),
    builder: (_) => const TabbedPagePage(),
    iconData: YaruIcons.tab_new,
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruCarousel'),
    builder: (_) => const CarouselPage(),
    iconData: YaruIcons.refresh,
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruColorDisk'),
    builder: (context) => const ColorDiskPage(),
    iconData: YaruIcons.color_select,
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruExpandable'),
    iconData: YaruIcons.pan_down,
    builder: (_) => const YaruPage(
      children: [
        YaruExpandable(
          child: Text(_lorem),
          header: Text(
            'Lorem ipsum dolor sit amet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          expandIcon: Icon(YaruIcons.pan_end),
        ),
        YaruExpandable(
          isExpanded: true,
          collapsedChild: Text(
            _lorem,
            maxLines: 5,
            overflow: TextOverflow.fade,
          ),
          child: Text(_lorem),
          header: Text(
            'Lorem ipsum dolor sit amet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          expandIcon: Icon(YaruIcons.pan_end),
        )
      ],
    ),
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruRoundToggleButton'),
    builder: (context) => const RoundToggleButtonPage(),
    iconData: YaruIcons.app_grid,
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruDraggable'),
    builder: (context) => const DraggablePage(),
    iconData: YaruIcons.drag_handle,
  ),
  YaruPageItem(
    titleBuilder: (context) => YaruPageItemTitle.text('YaruBanner'),
    builder: (context) => const BannerPage(),
    iconData: YaruIcons.image,
  )
];
