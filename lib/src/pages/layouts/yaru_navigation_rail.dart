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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
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
      ),
    );
  }
}

class _YaruNavigationRailItem extends StatefulWidget {
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
  State<StatefulWidget> createState() => _YaruNavigationRailItemState();
}

class _YaruNavigationRailItemState extends State<_YaruNavigationRailItem> {
  bool? oldExtended;

  @override
  void didUpdateWidget(_YaruNavigationRailItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.extended != oldWidget.extended ||
        widget.showLabel != oldWidget.showLabel) {
      oldExtended = oldWidget.extended;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: _alignement,
      child: Align(
        alignment: _alignement,
        child: SizedBox(
          width: widget.extended
              ? 250
              : widget.showLabel
                  ? 100
                  : 60,
          child: Material(
            child: InkWell(
              onTap: () => widget.onSelected(widget.index),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: widget.extended ? 10 : 5,
                    horizontal: widget.extended ? 8 : 5,
                  ),
                  child: _columnOrRow([
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: widget.selected
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
                        child: widget.destination.iconBuilder(
                          context,
                          widget.selected,
                        ),
                      ),
                    ),
                    if (widget.showLabel) ...[
                      _gap(),
                      _buildLabel(context),
                    ]
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment get _alignement {
    return widget.extended || oldExtended == true
        ? Alignment.centerLeft
        : Alignment.topCenter;
  }

  Widget _columnOrRow(List<Widget> children) {
    const mainAxisAlignment = MainAxisAlignment.start;

    if (widget.extended) {
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
    if (widget.extended) {
      return const SizedBox(width: 10);
    }

    return const SizedBox(height: 5);
  }

  Widget _buildLabel(BuildContext context) {
    var label = widget.destination.titleBuilder(context);

    if (label is YaruPageItemTitle) {
      label = DefaultTextStyle.merge(
        child: label,
        style: TextStyle(
          fontSize: widget.extended ? 13 : 12,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        textAlign: widget.extended ? TextAlign.left : TextAlign.center,
        maxLines: 1,
      );
    }

    return widget.extended ? Expanded(child: label) : label;
  }
}
