import 'package:flutter/material.dart';
import '../constants.dart';

/// A width responsive widget combining a [TabBar] and a [TabBarView].
///
/// [tabIcons], [views] and [tabTitles] must have the same amount of children. The [width] and [height] must be provided.
/// If there is not enough space only the [tabIcons] are shown.
class YaruTabbedPage extends StatefulWidget {
  const YaruTabbedPage({
    super.key,
    required this.tabIcons,
    required this.tabTitles,
    required this.views,
    this.width,
    this.padding = const EdgeInsets.only(
      top: kYaruPagePadding,
      right: kYaruPagePadding,
      left: kYaruPagePadding,
    ),
    this.initialIndex = 0,
    this.onTap,
  });

  /// A list of [Widget]s used inside the tabs - must have the same length as [tabTitles] and [views].
  final List<Widget> tabIcons;

  /// The list of titles as [String]s - must have the same length as [tabIcons] and [views].
  final List<String> tabTitles;

  /// The list of [Widget]-views  - must have the same length as [tabTitles] and [tabIcons].
  final List<Widget> views;

  /// The width used for the [TabBarView]
  final double? width;

  /// The padding [EdgeInsets] which defaults to [kDefaultPadding] at top, right and left.
  final EdgeInsetsGeometry padding;

  /// The initialIndex of the [TabController]
  final int initialIndex;

  /// The [Function] used when one of the [Tab] is tapped.
  final Function(int index)? onTap;

  @override
  State<YaruTabbedPage> createState() => _YaruTabbedPageState();
}

class _YaruTabbedPageState extends State<YaruTabbedPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: widget.initialIndex,
      length: widget.views.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool titlesDoNotFit() {
      final size = MediaQuery.of(context).size;
      var oneTitleTooLong = false;
      var twoTitlesTooLong = false;
      for (final title in widget.tabTitles) {
        if (title.length > 6) {
          oneTitleTooLong = true;
          if (oneTitleTooLong && title.length > 6) {
            twoTitlesTooLong = true;
          }
        }
      }
      return ((widget.tabTitles.length > 3 || oneTitleTooLong) ||
              twoTitlesTooLong) &&
          size.width < 750;
    }

    return Column(
      children: [
        Padding(
          padding: widget.padding,
          child: Container(
            width: widget.width,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kYaruContainerRadius),
            ),
            child: TabBar(
              controller: tabController,
              labelColor: Theme.of(context).colorScheme.onSurface,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(kYaruContainerRadius),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              ),
              splashBorderRadius: BorderRadius.circular(kYaruContainerRadius),
              onTap: widget.onTap,
              tabs: [
                for (var i = 0; i < widget.views.length; i++)
                  Tab(
                    text: titlesDoNotFit() ? null : widget.tabTitles[i],
                    icon: widget.tabIcons[i],
                  )
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: widget.views,
          ),
        ),
      ],
    );
  }
}
