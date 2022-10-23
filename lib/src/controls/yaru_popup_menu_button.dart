import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import '../constants.dart';

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
    this.position = PopupMenuPosition.under,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.childPadding = const EdgeInsets.symmetric(horizontal: 5),
    this.enabled = true,
  });

  final T? initialValue;
  final Widget child;
  final Function(T)? onSelected;
  final Function()? onCanceled;
  final String? tooltip;
  final PopupMenuPosition position;
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final EdgeInsets padding;
  final EdgeInsets childPadding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kYaruButtonRadius),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton(
          enabled: enabled,
          position: position,
          padding: EdgeInsets.zero,
          initialValue: initialValue,
          onSelected: onSelected,
          onCanceled: onCanceled,
          tooltip: tooltip,
          itemBuilder: itemBuilder,
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
  final EdgeInsets padding;
  final EdgeInsets childPadding;

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
    super.padding,
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
  @override
  Widget buildChild() {
    return IgnorePointer(
      child: ListTile(
        minLeadingWidth: 18,
        enabled: widget.enabled,
        leading: _YaruCheckMark(
          checked: widget.checked,
        ),
        title: widget.child,
      ),
    );
  }
}

class _YaruCheckMark extends StatelessWidget {
  const _YaruCheckMark({
    // ignore: unused_element
    super.key,
    required this.checked,
  });

  final bool checked;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.onSurface.withOpacity(
          Theme.of(context).brightness == Brightness.light ? 0.4 : 1,
        );
    const size = 18.0;
    const duration = 200;
    return checked
        ? AnimatedContainer(
            height: size,
            width: size,
            duration: const Duration(
              milliseconds: duration,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: size,
            ),
          )
        : AnimatedContainer(
            height: size,
            width: size,
            duration: const Duration(
              milliseconds: duration,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
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
    super.padding,
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
      child: ListTile(
        minLeadingWidth: 18,
        enabled: widget.enabled,
        leading: _YaruCheckMark(checked: _checked),
        title: widget.child,
      ),
    );
  }
}
