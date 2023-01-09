import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import '../../yaru_widgets.dart';

/// A generic wrapper around [PopupMenuButton] that is visually more consistent
/// to buttons and dialogs than [DropdownButton]
class YaruPopupMenuButton<T> extends StatelessWidget {
  const YaruPopupMenuButton({
    super.key,
    this.initialValue,
    required this.child,
    required this.itemBuilder,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.position = PopupMenuPosition.over,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.childPadding = const EdgeInsets.symmetric(horizontal: 5),
    this.enabled = true,
    this.offset = const Offset(0, 40),
    this.enableFeedback,
    this.constraints,
    this.elevation,
  });

  final T? initialValue;
  final Widget child;
  final Function(T)? onSelected;
  final Function()? onCanceled;
  final String? tooltip;
  final PopupMenuPosition position;
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry childPadding;
  final bool enabled;
  final Offset offset;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kYaruButtonRadius),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton(
          enabled: enabled,
          elevation: elevation,
          position: position,
          padding: EdgeInsets.zero,
          initialValue: initialValue,
          onSelected: onSelected,
          onCanceled: onCanceled,
          tooltip: tooltip,
          itemBuilder: itemBuilder,
          offset: offset,
          enableFeedback: enableFeedback,
          constraints: constraints,
          child: _YaruPopupDecoration(
            child: child,
            padding: padding,
            childPadding: childPadding,
          ),
        ),
      ),
    );
  }
}

class _YaruPopupDecoration extends StatelessWidget {
  const _YaruPopupDecoration({
    // ignore: unused_element
    super.key,
    required this.child,
    required this.padding,
    required this.childPadding,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry childPadding;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      child: Container(
        padding: childPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kYaruButtonRadius),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: padding,
              child: child,
            ),
            const SizedBox(
              height: 40,
              child: Icon(
                YaruIcons.pan_down,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YaruCheckedPopupMenuItem<T> extends PopupMenuItem<T> {
  /// Creates a popup menu item with a checkmark.
  ///
  /// By default, the menu item is [enabled] but unchecked. To mark the item as
  /// checked, set [checked] to true.
  ///
  /// The `checked` and `enabled` arguments must not be null.
  const YaruCheckedPopupMenuItem({
    super.key,
    super.value,
    this.checked = false,
    super.enabled,
    super.padding = EdgeInsets.zero,
    super.height,
    super.mouseCursor,
    super.child,
  });

  final bool checked;

  @override
  PopupMenuItemState<T, YaruCheckedPopupMenuItem<T>> createState() =>
      _YaruCheckedPopupMenuItemState<T>();
}

class _YaruCheckedPopupMenuItemState<T>
    extends PopupMenuItemState<T, YaruCheckedPopupMenuItem<T>> {
  var _checked = false;

  @override
  void handleTap() {
    super.handleTap();
    setState(() => _checked = !_checked);
  }

  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  Widget buildChild() {
    return IgnorePointer(
      child: Padding(
        // Same as [ListTile.padding] default
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: YaruCheckButton(
          value: _checked,
          onChanged: widget.enabled ? (_) {} : null,
          title: widget.child ?? Container(),
        ),
      ),
    );
  }
}

class YaruMultiSelectPopupMenuItem<T> extends PopupMenuItem<T> {
  /// Creates a popup menu item with a checkmark that does not close on tap.
  ///
  /// By default, the menu item is [enabled] but unchecked. To mark the item as
  /// checked, set [checked] to true.
  ///
  /// The `checked` and `enabled` arguments must not be null.
  const YaruMultiSelectPopupMenuItem({
    super.key,
    super.value,
    this.checked = false,
    super.enabled,
    super.padding = EdgeInsets.zero,
    super.height,
    super.mouseCursor,
    super.child,
    this.onChanged,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  PopupMenuItemState<T, YaruMultiSelectPopupMenuItem<T>> createState() =>
      _YaruMultiSelectPopupMenuItemState<T>();
}

class _YaruMultiSelectPopupMenuItemState<T>
    extends PopupMenuItemState<T, YaruMultiSelectPopupMenuItem<T>> {
  var _checked = false;

  @override
  void handleTap() {
    setState(() => _checked = !_checked);
    widget.onChanged?.call(_checked);
  }

  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  Widget buildChild() {
    return IgnorePointer(
      child: Padding(
        // Same as [ListTile.padding] default
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: YaruCheckButton(
          value: _checked,
          onChanged: widget.enabled ? (_) {} : null,
          title: widget.child ?? Container(),
        ),
      ),
    );
  }
}
