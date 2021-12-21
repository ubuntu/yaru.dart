import 'package:flutter/material.dart';

class YaruTabbedPage extends StatefulWidget {
  const YaruTabbedPage(
      {Key? key,
      required this.tabIcons,
      required this.tabTitles,
      required this.views,
      required this.width})
      : super(key: key);

  final List<IconData> tabIcons;
  final List<String> tabTitles;
  final List<Widget> views;
  final double width;

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
    return Column(
      children: [
        Container(
          width: widget.width,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
            tabs: [
              for (var i = 0; i < widget.views.length; i++)
                Tab(
                    text: widget.tabTitles[i],
                    icon: Icon(
                      widget.tabIcons[i],
                    ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.8,
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
