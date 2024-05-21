import 'package:flutter/material.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/theme.dart';

const double _kScrollbarThickness = 8.0;
const double _kScrollbarMargin = 2.0;
const Duration _kSelectedTileAnimationDuration = Duration(milliseconds: 250);

/// Provides the recommended layout for [YaruMasterDetailPage.tileBuilder].
///
/// This widget is structurally similar to [ListTile].
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

  /// See [ListTile.selected].
  final bool? selected;

  /// See [ListTile.leading].
  final Widget? leading;

  /// See [ListTile.title].
  final Widget? title;

  /// See [ListTile.subtitle].
  final Widget? subtitle;

  /// See [ListTile.trailing].
  final Widget? trailing;

  /// An optional [VoidCallback] forwarded to the internal [ListTile]
  /// If not provided [YaruMasterTileScope] `onTap` will be called.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scope = YaruMasterTileScope.maybeOf(context);

    final isSelected = selected ?? scope?.selected ?? false;
    final scrollbarThicknessWithTrack =
        _calcScrollbarThicknessWithTrack(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scrollbarThicknessWithTrack),
      child: AnimatedContainer(
        duration: _kSelectedTileAnimationDuration,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(kYaruButtonRadius)),
          color:
              isSelected ? theme.colorScheme.onSurface.withOpacity(0.07) : null,
        ),
        child: ListTile(
          selectedColor: theme.colorScheme.onSurface,
          iconColor: theme.colorScheme.onSurface.withOpacity(0.8),
          minVerticalPadding: 6,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          shape: RoundedRectangleBorder(
            borderRadius:
                const BorderRadius.all(Radius.circular(kYaruButtonRadius)),
            side: theme.colorScheme.isHighContrast && isSelected
                ? BorderSide(
                    color: theme.colorScheme.outlineVariant,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )
                : BorderSide.none,
          ),
          leading: leading,
          title: _titleStyle(context, title),
          subtitle: _subTitleStyle(context, subtitle),
          trailing: trailing,
          selected: isSelected,
          onTap: () {
            if (onTap != null) {
              onTap!.call();
            } else {
              scope?.onTap();
            }
          },
        ),
      ),
    );
  }

  Widget? _titleStyle(BuildContext context, Widget? child) {
    if (child == null) {
      return child;
    }

    return DefaultTextStyle.merge(
      child: child,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  Widget? _subTitleStyle(BuildContext context, Widget? child) {
    if (child == null) {
      return child;
    }

    return DefaultTextStyle.merge(
      child: child,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
    );
  }

  double _calcScrollbarThicknessWithTrack(final BuildContext context) {
    final scrollbarTheme = Theme.of(context).scrollbarTheme;

    final doubleMarginWidth = scrollbarTheme.crossAxisMargin != null
        ? scrollbarTheme.crossAxisMargin! * 2
        : _kScrollbarMargin * 2;

    final scrollBarThumbThikness =
        scrollbarTheme.thickness?.resolve({WidgetState.hovered}) ??
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
