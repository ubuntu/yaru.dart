import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruTabBar extends StatelessWidget {
  const YaruTabBar({
    super.key,
    required this.tabController,
    this.icons,
    required this.labels,
  }) : assert(icons == null || icons.length == labels.length);

  final TabController tabController;
  final List<Widget>? icons;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: kYaruTitleBarItemHeight + 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kYaruContainerRadius),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: tabController,
        labelColor: Theme.of(context).colorScheme.onSurface,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(kYaruContainerRadius),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
        splashBorderRadius: BorderRadius.circular(kYaruContainerRadius),
        tabs: [
          for (int i = 0; i < labels.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icons != null)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: icons![i],
                        ),
                      ),
                    Flexible(
                      child: Text(
                        labels[i],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
