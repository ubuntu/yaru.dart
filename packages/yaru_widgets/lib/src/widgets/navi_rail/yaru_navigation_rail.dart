import 'package:flutter/material.dart';

import 'yaru_navigation_page.dart';
import 'yaru_navigation_page_theme.dart';
import 'yaru_navigation_rail_item.dart';

class YaruNavigationRail extends StatelessWidget {
  const YaruNavigationRail({
    super.key,
    required this.length,
    required this.itemBuilder,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.leading,
    this.trailing,
  })  : assert(length >= 2),
        assert(
          selectedIndex == null ||
              (0 <= selectedIndex && selectedIndex < length),
        );

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its navigation rail item.
  final YaruNavigationPageBuilder itemBuilder;

  /// The index into [destinations] for the current selected
  /// item or null if no destination is selected.
  final int? selectedIndex;

  /// Called when one of the [destinations] is selected.
  ///
  /// The stateful widget that creates the navigation rail needs to keep
  /// track of the index of the selected [NavigationRailDestination] and call
  /// `setState` to rebuild the navigation rail with the new [selectedIndex].
  final ValueChanged<int>? onDestinationSelected;

  /// The leading widget in the rail that is placed above the destinations.
  final Widget? leading;

  /// The trailing widget in the rail that is placed below the destinations.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final navigationPageTheme = YaruNavigationPageTheme.of(context);

    return Padding(
      padding: navigationPageTheme.railPadding ?? EdgeInsets.zero,
      child: Column(
        children: [
          if (leading != null)
            Container(
              margin: const EdgeInsets.only(bottom: 1.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
              ),
              child: leading!,
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < length; i += 1)
                    YaruNavigationRailItemScope(
                      index: i,
                      selected: i == selectedIndex,
                      onTap: () => onDestinationSelected?.call(i),
                      child: Builder(
                        builder: (context) => itemBuilder(
                          context,
                          i,
                          i == selectedIndex,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (trailing != null)
            Container(
              margin: const EdgeInsets.only(top: 1.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
              ),
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
