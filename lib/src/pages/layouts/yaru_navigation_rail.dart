import 'package:flutter/material.dart';
import '../../../yaru_widgets.dart';

/// Defines the look of a [YaruNavigationRail]
enum YaruNavigationRailStyle {
  /// Will only show icons
  compact,

  /// Will show both icons and labels vertically
  labelled,

  /// Will show both icons and labels horizontally
  labelledExtended,
}

const _kSizeAnimationDuration = Duration(milliseconds: 200);
const _kSelectedIconAnimationDuration = Duration(milliseconds: 250);

class YaruNavigationRail extends StatelessWidget {
  const YaruNavigationRail({
    super.key,
    required this.length,
    required this.iconBuilder,
    required this.titleBuilder,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.style = YaruNavigationRailStyle.compact,
  })  : assert(length >= 2),
        assert(
          selectedIndex == null ||
              (0 <= selectedIndex && selectedIndex < length),
        );

  /// The total number of pages.
  final int length;

  /// A builder that is called for each page to build its icon.
  final YaruCompactLayoutBuilder iconBuilder;

  /// A builder that is called for each page to build its title.
  final YaruCompactLayoutBuilder titleBuilder;

  /// The index into [destinations] for the current selected
  /// [YaruPageItem] or null if no destination is selected.
  final int? selectedIndex;

  /// Called when one of the [destinations] is selected.
  ///
  /// The stateful widget that creates the navigation rail needs to keep
  /// track of the index of the selected [NavigationRailDestination] and call
  /// `setState` to rebuild the navigation rail with the new [selectedIndex].
  final ValueChanged<int>? onDestinationSelected;

  /// Define the navigation rail style, see [YaruNavigationRailStyle]
  final YaruNavigationRailStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < length; i += 1)
            _YaruNavigationRailItem(
              i,
              i == selectedIndex,
              iconBuilder,
              titleBuilder,
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
    this.iconBuilder,
    this.titleBuilder,
    this.onDestinationSelected,
    this.style,
  );

  final int index;
  final bool selected;
  final YaruCompactLayoutBuilder iconBuilder;
  final YaruCompactLayoutBuilder titleBuilder;
  final ValueChanged<int>? onDestinationSelected;
  final YaruNavigationRailStyle style;

  @override
  State<_YaruNavigationRailItem> createState() =>
      _YaruNavigationRailItemState();
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
    return _buildSizedContainer(
      Material(
        child: InkWell(
          onTap: () {
            if (widget.onDestinationSelected != null) {
              widget.onDestinationSelected!.call(widget.index);
            }
          },
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
              child: _buildColumnOrRow([
                _buildIcon(context),
                if (widget.style != YaruNavigationRailStyle.compact) ...[
                  _buildGap(),
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

  Widget _buildSizedContainer(Widget child) {
    return AnimatedSize(
      duration: _kSizeAnimationDuration,
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

  Widget _buildColumnOrRow(List<Widget> children) {
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
    return AnimatedContainer(
      duration: _kSelectedIconAnimationDuration,
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
        child: widget.iconBuilder(
          context,
          widget.index,
          widget.selected,
        ),
      ),
    );
  }

  Widget _buildGap() {
    if (widget.style == YaruNavigationRailStyle.labelledExtended) {
      return const SizedBox(width: 10);
    }

    return const SizedBox(height: 5);
  }

  Widget _buildLabel(BuildContext context) {
    var label = widget.titleBuilder(context, widget.index, widget.selected);

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
