import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/constants.dart';

/// A width responsive widget combining a [TabBar] and a [TabBarView].
///
/// [tabIcons], [views] and [tabTitles] must have the same amount of children. The [width] and [height] must be provided.
/// If there is not enough space only the [tabIcons] are shown.
class YaruTabbedPage extends StatefulWidget {
  const YaruTabbedPage({
    Key? key,
    required this.tabIcons,
    required this.tabTitles,
    required this.views,
    this.width,
  }) : super(key: key);

  /// A list of [IconData] used inside the tabs - must have the same length as [tabTitles] and [views].
  final List<IconData> tabIcons;

  /// The list of titles as [String]s - must have the same length as [tabIcons] and [views].
  final List<String> tabTitles;

  /// The list of [Widget]-views  - must have the same length as [tabTitles] and [tabIcons].
  final List<Widget> views;

  /// The width used for the [TabBarView]
  final double? width;

  @override
  State<YaruTabbedPage> createState() => _YaruTabbedPageState();
}

class _YaruTabbedPageState extends State<YaruTabbedPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: widget.views.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool titlesDoNotFit() {
      final size = MediaQuery.of(context).size;
      var oneTitleTooLong = false;
      var twoTitlesTooLong = false;
      for (var title in widget.tabTitles) {
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
          padding: const EdgeInsets.only(
              top: kDefaultPagePadding,
              right: kDefaultPagePadding,
              left: kDefaultPagePadding),
          child: Container(
            width: widget.width,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultContainerRadius)),
            child: Theme(
              data: ThemeData().copyWith(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                controller: tabController,
                labelColor: Theme.of(context).colorScheme.onSurface,
                indicator: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(kDefaultContainerRadius),
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1)),
                tabs: [
                  for (var i = 0; i < widget.views.length; i++)
                    Tab(
                        text: titlesDoNotFit() ? null : widget.tabTitles[i],
                        icon: Icon(
                          widget.tabIcons[i],
                        ))
                ],
              ),
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
