import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

enum _YaruSplitButtonVariant { elevated, filled, outlined }

class YaruSplitButton extends StatelessWidget {
  const YaruSplitButton({
    super.key,
    required this.items,
    this.onPressed,
    this.child,
    this.onOptionsPressed,
    this.icon,
    this.radius,
    this.menuWidth = menuDefaultWidth,
  }) : _variant = _YaruSplitButtonVariant.elevated;

  const YaruSplitButton.filled({
    super.key,
    this.items,
    this.onPressed,
    this.child,
    this.onOptionsPressed,
    this.icon,
    this.radius,
    this.menuWidth = menuDefaultWidth,
  }) : _variant = _YaruSplitButtonVariant.filled;

  const YaruSplitButton.outlined({
    super.key,
    required this.items,
    this.onPressed,
    this.child,
    this.onOptionsPressed,
    this.icon,
    this.radius,
    this.menuWidth = menuDefaultWidth,
  }) : _variant = _YaruSplitButtonVariant.outlined;

  final _YaruSplitButtonVariant _variant;
  final void Function()? onPressed;
  final void Function()? onOptionsPressed;
  final Widget? child;
  final Widget? icon;
  final List<PopupMenuEntry<Object?>>? items;
  final double? radius;
  final double menuWidth;

  static const menuDefaultWidth = 148.0;

  @override
  Widget build(BuildContext context) {
    assert(
      items?.isNotEmpty == true && onOptionsPressed == null ||
          items == null && onOptionsPressed != null,
    );

    // TODO: fix common_themes to use a fixed size for buttons instead of fiddling around with padding
    // then we can rely on this size here
    const size = Size.square(36);
    const dropdownPadding = EdgeInsets.only(top: 16, bottom: 16);

    final defaultRadius = Radius.circular(radius ?? kYaruButtonRadius);

    final mainActionShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: defaultRadius,
        bottomLeft: defaultRadius,
      ),
    );

    final dropdownShape = switch (_variant) {
      _YaruSplitButtonVariant.outlined =>
        const NonUniformRoundedRectangleBorder(hideLeftSide: true),
      _ => RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: defaultRadius,
            bottomRight: defaultRadius,
          ),
        ),
    };

    final onDropdownPressed = onOptionsPressed ??
        (items?.isNotEmpty == true
            ? () => showMenu(
                  context: context,
                  position: _menuPosition(context),
                  items: items!,
                  menuPadding: EdgeInsets.symmetric(vertical: defaultRadius.x),
                  constraints: BoxConstraints(
                    minWidth: menuWidth,
                    maxWidth: menuWidth,
                  ),
                )
            : null);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (_variant) {
          _YaruSplitButtonVariant.elevated => ElevatedButton(
              style: ElevatedButton.styleFrom(shape: mainActionShape),
              onPressed: onPressed,
              child: child,
            ),
          _YaruSplitButtonVariant.filled => FilledButton(
              style: FilledButton.styleFrom(shape: mainActionShape),
              onPressed: onPressed,
              child: child,
            ),
          _YaruSplitButtonVariant.outlined => OutlinedButton(
              style: OutlinedButton.styleFrom(shape: mainActionShape),
              onPressed: onPressed,
              child: child,
            ),
        },
        switch (_variant) {
          _YaruSplitButtonVariant.elevated => ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: size,
                minimumSize: size,
                maximumSize: size,
                padding: dropdownPadding,
                shape: dropdownShape,
              ),
              onPressed: onDropdownPressed,
              child: icon ?? const Icon(YaruIcons.pan_down),
            ),
          _YaruSplitButtonVariant.filled => FilledButton(
              style: FilledButton.styleFrom(
                fixedSize: size,
                minimumSize: size,
                maximumSize: size,
                padding: dropdownPadding,
                shape: dropdownShape,
              ),
              onPressed: onDropdownPressed,
              child: icon ?? const Icon(YaruIcons.pan_down),
            ),
          _YaruSplitButtonVariant.outlined => OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: size,
                minimumSize: size,
                maximumSize: size,
                padding: dropdownPadding,
                shape: dropdownShape,
              ),
              onPressed: onDropdownPressed,
              child: icon ?? const Icon(YaruIcons.pan_down),
            ),
        },
      ],
    );
  }

  RelativeRect _menuPosition(BuildContext context) {
    final bar = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    const offset = Offset.zero;

    return RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(
          bar.size.bottomCenter(offset),
          ancestor: overlay,
        ),
        bar.localToGlobal(
          bar.size.bottomLeft(offset),
          ancestor: overlay,
        ),
      ),
      offset & overlay.size,
    );
  }
}
