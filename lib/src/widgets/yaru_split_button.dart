import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

enum _YaruSplitButtonVariant { elevated, filled, outlined }

class YaruSplitButton extends StatelessWidget {
  const YaruSplitButton({
    super.key,
    this.items,
    this.onPressed,
    this.child,
    this.onOptionsPressed,
    this.icon,
    this.radius,
    this.menuWidth,
  }) : _variant = _YaruSplitButtonVariant.elevated;

  const YaruSplitButton.filled({
    super.key,
    this.items,
    this.onPressed,
    this.child,
    this.onOptionsPressed,
    this.icon,
    this.radius,
    this.menuWidth,
  }) : _variant = _YaruSplitButtonVariant.filled;

  const YaruSplitButton.outlined({
    super.key,
    this.items,
    this.onPressed,
    this.child,
    this.onOptionsPressed,
    this.icon,
    this.radius,
    this.menuWidth,
  }) : _variant = _YaruSplitButtonVariant.outlined;

  final _YaruSplitButtonVariant _variant;
  final void Function()? onPressed;
  final void Function()? onOptionsPressed;
  final Widget? child;
  final Widget? icon;
  final List<PopupMenuEntry<Object?>>? items;
  final double? radius;
  final double? menuWidth;

  @override
  Widget build(BuildContext context) {
    // TODO: fix common_themes to use a fixed size for buttons instead of fiddling around with padding
    // then we can rely on this size here
    const size = Size.square(36);
    const dropdownPadding = EdgeInsets.only(top: 16, bottom: 16);

    final defaultRadius = Radius.circular(radius ?? kYaruButtonRadius);

    final dropdownShape = switch (_variant) {
      _YaruSplitButtonVariant.outlined => NonUniformRoundedRectangleBorder(
          hideLeftSide: true,
          borderRadius: BorderRadius.all(
            defaultRadius,
          ),
        ),
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
                  constraints: menuWidth == null
                      ? null
                      : BoxConstraints(
                          minWidth: menuWidth!,
                          maxWidth: menuWidth!,
                        ),
                )
            : null);

    final mainActionShape = RoundedRectangleBorder(
      borderRadius: onDropdownPressed == null
          ? BorderRadius.all(defaultRadius)
          : BorderRadius.only(
              topLeft: defaultRadius,
              bottomLeft: defaultRadius,
            ),
    );

    final dropdownIcon = icon ?? const Icon(YaruIcons.pan_down);

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
        if (onDropdownPressed != null)
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
                child: dropdownIcon,
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
                child: dropdownIcon,
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
                child: dropdownIcon,
              ),
          },
      ],
    );
  }

  RelativeRect _menuPosition(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    const offset = Offset.zero;

    return RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(
          box.size.bottomRight(offset),
          ancestor: overlay,
        ),
        box.localToGlobal(
          box.size.bottomRight(offset),
          ancestor: overlay,
        ),
      ),
      offset & overlay.size,
    );
  }
}
