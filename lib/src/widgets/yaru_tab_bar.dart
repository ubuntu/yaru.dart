import 'package:flutter/material.dart';

import '../../constants.dart';

/// A pre-styled replacement for material [TabBar]
class YaruTabBar extends StatelessWidget {
  const YaruTabBar({
    super.key,
    this.tabController,
    this.onTap,
    required this.tabs,
    this.height,
    this.labelColor,
    this.unselectedLabelColor,
  });

  final TabController? tabController;
  final void Function(int)? onTap;
  final List<Widget> tabs;
  final double? height;
  final Color? labelColor, unselectedLabelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(5),
      height: height ?? kYaruTitleBarItemHeight + 10,
      child: TabBar(
        onTap: onTap,
        dividerColor: Colors.transparent,
        controller: tabController,
        labelColor: labelColor ?? theme.colorScheme.onSurface,
        unselectedLabelColor: unselectedLabelColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(kYaruButtonRadius),
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        splashBorderRadius: BorderRadius.circular(kYaruButtonRadius),
        tabs: [for (final tab in tabs) tab],
      ),
    );
  }
}

class YaruTab extends StatelessWidget {
  const YaruTab({super.key, required this.label, this.icon, this.padding});

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
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );

    return padding != null ? Padding(padding: padding!, child: tab) : tab;
  }
}
