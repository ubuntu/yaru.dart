import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

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
    this.decoration,
    this.focusDecoration,
    this.padding,
    this.hasFocusBorder,
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

  /// An optional [Decoration] used for the [ListTile].
  final Decoration? decoration;

  /// An optional [Decoration] used when the [ListTile] is focused.
  final Decoration? focusDecoration;

  /// Optional padding for the tile.
  final EdgeInsetsGeometry? padding;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listTileTheme = theme.listTileTheme;
    final scope = YaruMasterTileScope.maybeOf(context);

    final isSelected = selected ?? scope?.selected ?? false;

    final backgroundColor = isSelected
        ? listTileTheme.selectedTileColor
        : listTileTheme.tileColor;

    final foregroundColor = isSelected
        ? listTileTheme.selectedColor
        : listTileTheme.textColor;

    final tile = AnimatedContainer(
      duration: Durations.medium1,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(kYaruButtonRadius),
        ),
        color: backgroundColor,
      ),
      child: ListTile(
        leading: leading,
        title: _titleStyle(title, foregroundColor),
        subtitle: _subTitleStyle(subtitle, foregroundColor),
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
    );

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
        child:
            hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
            ? YaruFocusBorder(
                borderStrokeAlign: BorderSide.strokeAlignInside,
                child: tile,
              )
            : tile,
      ),
    );
  }

  Widget? _titleStyle(Widget? child, Color? color) {
    if (child == null) {
      return child;
    }

    return DefaultTextStyle.merge(
      child: child,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color),
    );
  }

  Widget? _subTitleStyle(Widget? child, Color? color) {
    if (child == null) {
      return child;
    }

    return DefaultTextStyle.merge(
      child: child,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color),
    );
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
