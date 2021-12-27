import 'package:flutter/material.dart';

class YaruTabbedPage extends StatefulWidget {
  const YaruTabbedPage(
      {Key? key,
      required this.tabIcons,
      required this.tabTitles,
      required this.views,
      required this.width,
      required this.height})
      : super(key: key);

  final List<IconData> tabIcons;
  final List<String> tabTitles;
  final List<Widget> views;
  final double width;
  final double height;

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
        Container(
          width: widget.width,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Theme(
            data: ThemeData().copyWith(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
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
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            height: widget.height,
            child: TabBarView(
              controller: tabController,
              children: widget.views,
            ),
          ),
        ),
      ],
    );
  }
}
