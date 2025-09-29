import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

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
    this.decoration,
    this.focusDecoration,
    this.padding,
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
        child: _YaruMasterTileFocus(
          selected: selected,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
          decoration: decoration,
          focusDecoration: focusDecoration,
        ),
      ),
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

class _YaruMasterTileFocus extends StatefulWidget {
  const _YaruMasterTileFocus({
    this.selected,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.decoration,
    this.focusDecoration,
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

  @override
  State<_YaruMasterTileFocus> createState() => _YaruMasterTileFocusState();
}

class _YaruMasterTileFocusState extends State<_YaruMasterTileFocus> {
  Decoration? _decoration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listTileTheme = theme.listTileTheme;
    final scope = YaruMasterTileScope.maybeOf(context);

    final isSelected = widget.selected ?? scope?.selected ?? false;

    final backgroundColor = isSelected
        ? listTileTheme.selectedTileColor
        : listTileTheme.tileColor;

    final foregroundColor = isSelected
        ? listTileTheme.selectedColor
        : listTileTheme.textColor;

    final decoration =
        widget.decoration ??
        BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(kYaruButtonRadius),
          ),
          color: backgroundColor,
        );

    return AnimatedContainer(
      duration: _kSelectedTileAnimationDuration,
      decoration: _decoration ?? decoration,
      child: ListTile(
        onFocusChange: (hasFocus) => setState(() {
          _decoration = hasFocus
              ? widget.focusDecoration ?? decoration
              : decoration;
        }),
        leading: widget.leading,
        title: _titleStyle(widget.title, foregroundColor),
        subtitle: _subTitleStyle(widget.subtitle, foregroundColor),
        trailing: widget.trailing,
        selected: isSelected,
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!.call();
          } else {
            scope?.onTap();
          }
        },
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
