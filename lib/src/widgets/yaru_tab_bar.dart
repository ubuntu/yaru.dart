import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruTabBar extends StatelessWidget {
  const YaruTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  final TabController tabController;
  final List<Widget> tabs;

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
        tabs: [for (final tab in tabs) tab],
      ),
    );
  }
}

class YaruTab extends StatelessWidget {
  const YaruTab({
    super.key,
    required this.label,
    this.icon,
    this.padding,
  });

  final String label;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tab = Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: icon,
              ),
            ),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return padding != null
        ? Padding(
            padding: padding!,
            child: tab,
          )
        : tab;
  }
}
