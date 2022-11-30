import 'package:flutter/material.dart';

/// Defines the look of a [YaruNavigationRailItem]
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
const _kTooltipWaitDuration = Duration(milliseconds: 500);

class YaruNavigationRailItem extends StatefulWidget {
  const YaruNavigationRailItem({
    super.key,
    this.selected,
    required this.icon,
    required this.label,
    this.tooltip,
    this.onTap,
    required this.style,
  });

  /// Whether the related page item is selected in the rail.
  final bool? selected;

  /// Icon widget, displayed beside the [label].
  final Widget icon;

  /// Label widget, displayed beside the [icon].
  final Widget label;

  /// Optional string tooltip.
  /// If not null a tooltip will be displayed on hover.
  /// It should describe the whole tile if possible.
  final String? tooltip;

  /// Callback called when the tile is tapped.
  final VoidCallback? onTap;

  /// Style of this tile, see [YaruNavigationRailStyle].
  final YaruNavigationRailStyle style;

  @override
  State<YaruNavigationRailItem> createState() => _YaruNavigationRailItemState();
}

class _YaruNavigationRailItemState extends State<YaruNavigationRailItem> {
  YaruNavigationRailStyle? oldStyle;

  @override
  void didUpdateWidget(YaruNavigationRailItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style != oldWidget.style) {
      oldStyle = oldWidget.style;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildSizedContainer(
      _maybeBuildTooltip(
        Material(
          child: InkWell(
            onTap: () {
              final scope = YaruNavigationRailItemScope.maybeOf(context);
              scope?.onTap();
              widget.onTap?.call();
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
      ),
    );
  }

  bool get _selected {
    return widget.selected ??
        YaruNavigationRailItemScope.maybeOf(context)?.selected == true;
  }

  Alignment get _alignment {
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
      alignment: _alignment,
      child: Align(
        alignment: _alignment,
        child: SizedBox(
          width: _width,
          child: child,
        ),
      ),
    );
  }

  Widget _maybeBuildTooltip(Widget child) {
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        waitDuration: _kTooltipWaitDuration,
        child: child,
      );
    }

    return child;
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
        color: _selected
            ? Theme.of(context).colorScheme.onSurface.withOpacity(.1)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 10,
        ),
        child: widget.icon,
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
    final label = DefaultTextStyle.merge(
      child: widget.label,
      style: TextStyle(
        fontSize:
            widget.style == YaruNavigationRailStyle.labelledExtended ? 13 : 12,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: widget.style == YaruNavigationRailStyle.labelledExtended
          ? null
          : TextAlign.center,
      maxLines: 1,
    );

    return widget.style == YaruNavigationRailStyle.labelledExtended
        ? Expanded(child: label)
        : label;
  }
}

class YaruNavigationRailItemScope extends InheritedWidget {
  const YaruNavigationRailItemScope({
    super.key,
    required super.child,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final bool selected;
  final VoidCallback onTap;

  static YaruNavigationRailItemScope of(BuildContext context) {
    return maybeOf(context)!;
  }

  static YaruNavigationRailItemScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<YaruNavigationRailItemScope>();
  }

  @override
  bool updateShouldNotify(YaruNavigationRailItemScope oldWidget) {
    return selected != oldWidget.selected || index != oldWidget.index;
  }
}
