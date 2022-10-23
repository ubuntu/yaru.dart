import 'package:flutter/material.dart';

import 'yaru_compact_layout.dart';
import 'yaru_navigation_rail_item.dart';

class YaruNavigationRail extends StatelessWidget {
  const YaruNavigationRail({
    super.key,
    required this.length,
    required this.itemBuilder,
    required this.selectedIndex,
    required this.onDestinationSelected,
  })  : assert(length >= 2),
        assert(
          selectedIndex == null ||
              (0 <= selectedIndex && selectedIndex < length),
        );

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its navigation rail item.
  final YaruCompactLayoutBuilder itemBuilder;

  /// The index into [destinations] for the current selected
  /// item or null if no destination is selected.
  final int? selectedIndex;

  /// Called when one of the [destinations] is selected.
  ///
  /// The stateful widget that creates the navigation rail needs to keep
  /// track of the index of the selected [NavigationRailDestination] and call
  /// `setState` to rebuild the navigation rail with the new [selectedIndex].
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
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
            )
        ],
      ),
    );
  }
}
