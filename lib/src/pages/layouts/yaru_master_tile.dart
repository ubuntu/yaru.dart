import 'package:flutter/material.dart';

import '../../constants.dart';

const double _kScrollbarThickness = 8.0;
const double _kScrollbarMargin = 2.0;

class YaruMasterTile extends StatelessWidget {
  const YaruMasterTile({
    super.key,
    this.selected,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final bool? selected;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final scope = YaruMasterTileScope.maybeOf(context);
    final isSelected = selected ?? scope?.selected ?? false;
    final scrollbarThicknessWithTrack =
        _calcScrollbarThicknessWithTrack(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scrollbarThicknessWithTrack),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(kYaruButtonRadius)),
          color: isSelected
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.07)
              : null,
        ),
        child: ListTile(
          textColor: Theme.of(context).colorScheme.onSurface,
          selectedColor: Theme.of(context).colorScheme.onSurface,
          iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kYaruButtonRadius)),
          ),
          leading: leading,
          title: _buildChild(title),
          subtitle: _buildChild(subtitle),
          trailing: trailing,
          selected: isSelected,
          onTap: () {
            final scope = YaruMasterTileScope.maybeOf(context);
            scope?.onTap();
            onTap?.call();
          },
        ),
      ),
    );
  }

  Widget? _buildChild(Widget? child) {
    if (child == null) {
      return child;
    }

    return DefaultTextStyle.merge(
      child: child,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  double _calcScrollbarThicknessWithTrack(final BuildContext context) {
    final scrollbarTheme = Theme.of(context).scrollbarTheme;

    final doubleMarginWidth = scrollbarTheme.crossAxisMargin != null
        ? scrollbarTheme.crossAxisMargin! * 2
        : _kScrollbarMargin * 2;

    final scrollBarThumbThikness =
        scrollbarTheme.thickness?.resolve({MaterialState.hovered}) ??
            _kScrollbarThickness;

    return doubleMarginWidth + scrollBarThumbThikness;
  }
}

class YaruMasterTileScope extends InheritedWidget {
  const YaruMasterTileScope({
    super.key,
    required super.child,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final bool selected;
  final VoidCallback onTap;

  static YaruMasterTileScope of(BuildContext context) {
    return maybeOf(context)!;
  }

  static YaruMasterTileScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<YaruMasterTileScope>();
  }

  @override
  bool updateShouldNotify(YaruMasterTileScope oldWidget) {
    return selected != oldWidget.selected || index != oldWidget.index;
  }
}
