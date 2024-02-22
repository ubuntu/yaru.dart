import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/widgets/navi_rail/yaru_navigation_page_theme.dart';

import '../../../constants.dart';

/// Defines the look of a [YaruNavigationRailItem]
enum YaruNavigationRailStyle {
  /// Will only show icons.
  /// Default width: 60
  compact,

  /// Will show both icons and labels vertically.
  /// Default width: 100
  labelled,

  /// Will show both icons and labels horizontally.
  /// Default width: 250
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
    this.label,
    this.tooltip,
    this.onTap,
    required this.style,
    this.extendedSelectedIndicator = false,
    this.borderRadius,
    this.width,
  }) : assert(style == YaruNavigationRailStyle.compact || label != null);

  /// Whether the related page item is selected in the rail.
  final bool? selected;

  /// Icon widget, displayed beside the [label].
  final Widget icon;

  /// Label widget, displayed beside the [icon].
  /// If [style] is [YaruNavigationRailStyle.compact], this property can be left null.
  final Widget? label;

  /// Optional string tooltip.
  /// If not null a tooltip will be displayed on hover.
  /// It should describe the whole tile if possible.
  final String? tooltip;

  /// Callback called when the tile is tapped.
  final VoidCallback? onTap;

  /// Style of this tile, see [YaruNavigationRailStyle].
  final YaruNavigationRailStyle style;

  /// If true, the selected background indicator will wrap the [icon] and the [label].
  /// If false, it will only wrap the [icon].
  final bool extendedSelectedIndicator;

  /// Border radius of the selected background indicator.
  final BorderRadiusGeometry? borderRadius;

  /// Defines the width of this tile.
  /// If null, it will use default values, see [YaruNavigationRailStyle].
  final double? width;

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
    final theme = YaruNavigationPageTheme.of(context);

    return _buildSizedBox(
      child: _maybeBuildTooltip(
        child: _buildContainer(
          context: context,
          theme: theme,
          child: _buildColumnOrRow(
            children: [
              _buildIcon(context),
              if (widget.style != YaruNavigationRailStyle.compact) ...[
                _buildGap(),
                _buildLabel(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _selected {
    return widget.selected ??
        YaruNavigationRailItemScope.maybeOf(context)?.selected == true;
  }

  bool get _labelledExtended =>
      widget.style == YaruNavigationRailStyle.labelledExtended;

  bool get _extendedSelectedIndicator {
    return widget.extendedSelectedIndicator &&
        widget.style != YaruNavigationRailStyle.compact;
  }

  Alignment get _alignment {
    return _labelledExtended ||
            oldStyle == YaruNavigationRailStyle.labelledExtended
        ? Alignment.centerLeft
        : Alignment.topCenter;
  }

  double get _width {
    if (widget.width != null) {
      return widget.width!;
    }

    switch (widget.style) {
      case YaruNavigationRailStyle.labelledExtended:
        return 250;
      case YaruNavigationRailStyle.labelled:
        return 100;
      case YaruNavigationRailStyle.compact:
        return 60;
    }
  }

  Color _selectedIndicatorColor(ThemeData theme) {
    return theme.colorScheme.onSurface.withOpacity(.1);
  }

  Widget _buildSizedBox({required Widget child}) {
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

  Widget _maybeBuildTooltip({required Widget child}) {
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        waitDuration: _kTooltipWaitDuration,
        child: child,
      );
    }

    return child;
  }

  Widget _buildContainer({
    required BuildContext context,
    required YaruNavigationPageThemeData theme,
    required Widget child,
  }) {
    if (_extendedSelectedIndicator) {
      child = AnimatedContainer(
        duration: _kSelectedIconAnimationDuration,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ??
              const BorderRadius.all(
                Radius.circular(kYaruButtonRadius),
              ),
          color: _selected ? _selectedIndicatorColor(Theme.of(context)) : null,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: _labelledExtended ? 5 : 2,
              horizontal: 2,
            ),
            child: child,
          ),
        ),
      );
    }

    return Material(
      color: theme.sideBarColor,
      child: InkWell(
        onTap: () {
          final scope = YaruNavigationRailItemScope.maybeOf(context);
          scope?.onTap();
          widget.onTap?.call();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: _labelledExtended && !_extendedSelectedIndicator ? 10 : 5,
            horizontal:
                _labelledExtended && !_extendedSelectedIndicator ? 8 : 5,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildColumnOrRow({required List<Widget> children}) {
    const mainAxisAlignment = MainAxisAlignment.start;

    if (_labelledExtended) {
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
    final icon = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 10,
      ),
      child: widget.icon,
    );

    if (!_extendedSelectedIndicator) {
      return AnimatedContainer(
        duration: _kSelectedIconAnimationDuration,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(100),
          color: _selected ? _selectedIndicatorColor(Theme.of(context)) : null,
        ),
        child: icon,
      );
    } else {
      return icon;
    }
  }

  Widget _buildGap() {
    if (_labelledExtended) {
      return const SizedBox(width: 10);
    }

    return const SizedBox(height: 5);
  }

  Widget _buildLabel(BuildContext context) {
    final label = DefaultTextStyle.merge(
      child: widget.label!,
      style: TextStyle(
        fontSize: _labelledExtended ? 13 : 12,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: _labelledExtended ? null : TextAlign.center,
      maxLines: 1,
    );

    return _labelledExtended ? Expanded(child: label) : label;
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
