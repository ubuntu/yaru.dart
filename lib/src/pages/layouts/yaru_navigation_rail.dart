import 'package:flutter/material.dart';
import '../../../yaru_widgets.dart';

enum YaruNavigationRailStyle {
  compact,
  labelled,
  labelledExtended,
}

class YaruNavigationRail extends StatelessWidget {
  const YaruNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.style = YaruNavigationRailStyle.compact,
  });

  // TODO: add comments
  final List<YaruPageItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final YaruNavigationRailStyle style;

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
              style,
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
    this.style,
  );

  final int index;
  final bool selected;
  final YaruPageItem destination;
  final ValueChanged<int> onSelected;
  final YaruNavigationRailStyle style;

  @override
  State<StatefulWidget> createState() => _YaruNavigationRailItemState();
}

class _YaruNavigationRailItemState extends State<_YaruNavigationRailItem> {
  YaruNavigationRailStyle? oldStyle;

  @override
  void didUpdateWidget(_YaruNavigationRailItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style != oldWidget.style) {
      oldStyle = oldWidget.style;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _sizedContainer(
      Material(
        child: InkWell(
          onTap: () => widget.onSelected(widget.index),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    widget.style == YaruNavigationRailStyle.labelledExtended
                        ? 10
                        : 5,
                horizontal:
                    widget.style == YaruNavigationRailStyle.labelledExtended
                        ? 8
                        : 5,
              ),
              child: _columnOrRow([
                _buildIcon(context),
                if (widget.style != YaruNavigationRailStyle.compact) ...[
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

  Alignment get _alignement {
    return widget.style == YaruNavigationRailStyle.labelledExtended ||
            oldStyle == YaruNavigationRailStyle.labelledExtended
        ? Alignment.centerLeft
        : Alignment.topCenter;
  }

  double get _width {
    switch (widget.style) {
      case YaruNavigationRailStyle.labelledExtended:
        return 250;
      case YaruNavigationRailStyle.labelled:
        return 100;
      case YaruNavigationRailStyle.compact:
        return 60;
    }
  }

  Widget _sizedContainer(Widget child) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: _alignement,
      child: Align(
        alignment: _alignement,
        child: SizedBox(
          width: _width,
          child: child,
        ),
      ),
    );
  }

  Widget _columnOrRow(List<Widget> children) {
    const mainAxisAlignment = MainAxisAlignment.start;

    if (widget.style == YaruNavigationRailStyle.labelledExtended) {
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

  Widget _buildIcon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: widget.selected
            ? Theme.of(context).colorScheme.onSurface.withOpacity(.1)
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
    );
  }

  Widget _gap() {
    if (widget.style == YaruNavigationRailStyle.labelledExtended) {
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
          fontSize: widget.style == YaruNavigationRailStyle.labelledExtended
              ? 13
              : 12,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        textAlign: widget.style == YaruNavigationRailStyle.labelledExtended
            ? TextAlign.left
            : TextAlign.center,
        maxLines: 1,
      );
    }

    return widget.style == YaruNavigationRailStyle.labelledExtended
        ? Expanded(child: label)
        : label;
  }
}
