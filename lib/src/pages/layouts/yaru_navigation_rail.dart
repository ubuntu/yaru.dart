import 'package:flutter/material.dart';
import '../../../yaru_widgets.dart';

class YaruNavigationRail extends StatelessWidget {
  const YaruNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.showLabels = false,
    this.extended = false,
  });

  // TODO: add comments
  final List<YaruPageItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool showLabels;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < destinations.length; i += 1)
          _YaruNavigationRailItem(
            i,
            i == selectedIndex,
            destinations[i],
            onDestinationSelected,
            showLabels,
            showLabels && extended,
          )
      ],
    );
  }
}

class _YaruNavigationRailItem extends StatelessWidget {
  const _YaruNavigationRailItem(
    this.index,
    this.selected,
    this.destination,
    this.onSelected,
    this.showLabel,
    this.extended,
  );

  final int index;
  final bool selected;
  final YaruPageItem destination;
  final ValueChanged<int> onSelected;
  final bool showLabel;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: extended
          ? 250
          : showLabel
              ? 85
              : 60,
      child: Material(
        child: InkWell(
          onTap: () => onSelected(index),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: extended ? 10 : 7,
                horizontal: extended ? 8 : 5,
              ),
              child: _columnOrRow([
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: selected
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.1)
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    child: Icon(destination.iconData),
                  ),
                ),
                if (showLabel) ...[
                  _gap(),
                  _buildLabel(context),
                ]
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _columnOrRow(List<Widget> children) {
    const mainAxisAlignment = MainAxisAlignment.start;

    if (extended) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      );
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }

  Widget _gap() {
    if (extended) {
      return const SizedBox(width: 10);
    }

    return const SizedBox(height: 2);
  }

  Widget _buildLabel(BuildContext context) {
    var label = destination.titleBuilder(context);

    if (label is YaruPageItemTitle) {
      label = DefaultTextStyle.merge(
        child: label,
        style: TextStyle(fontSize: extended ? 13 : 11),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        textAlign: extended ? TextAlign.left : TextAlign.center,
        maxLines: extended ? 1 : 3,
      );
    }

    return extended ? Expanded(child: label) : label;
  }
}
