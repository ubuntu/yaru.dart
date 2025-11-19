import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

const _kAnimationDuration = Duration(milliseconds: 250);

class YaruSelectableContainer extends StatelessWidget {
  /// Creates a Image Tile from the image path given in the path property.
  const YaruSelectableContainer({
    super.key,
    required this.child,
    this.onTap,
    required this.selected,
    this.borderRadius,
    this.radius = kYaruContainerRadius,
    this.padding,
    this.selectionColor,
    this.mouseCursor,
    this.hasFocusBorder,
  });

  // The child which will be selected with [onTap]
  final Widget child;

  /// Current Value of the imageTile.
  /// Based on the this value selection of the image can be managed.
  /// If this value is `true` [Container] border will have color from [Theme.of(context).primaryColor]
  /// else if the value is `false` the border color will be [Colors.transparent].
  final bool selected;

  /// Callback triggered when the [YaruSelectableContainer] is clicked.
  final VoidCallback? onTap;

  /// Optional custom radius for the corners which defaults to a 8.0 [BorderRadius]
  final BorderRadius? borderRadius;

  /// Optional double value used for a symmetric circular [BorderRadius] if [borderRadius]
  /// is not specified.
  final double radius;

  /// Optional custom padding for the child which defaults to 6.0 on all sides.
  final EdgeInsetsGeometry? padding;

  /// Optional custom [Color] which is used for the selection border.
  final Color? selectionColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  /// Whether to display the default focus border on focus or not.
  final bool? hasFocusBorder;

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? const EdgeInsets.all(6);
    final borderRadius = this.borderRadius ?? BorderRadius.circular(radius);

    final content = InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      mouseCursor: mouseCursor,
      child: AnimatedContainer(
        duration: _kAnimationDuration,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: selected
              ? selectionColor ??
                    Theme.of(context).primaryColor.withValues(alpha: 0.8)
              : Colors.transparent,
        ),
        child: Padding(
          padding: padding,
          child: ClipRRect(
            borderRadius: borderRadius.inner(
              padding.resolve(Directionality.of(context)),
            ),
            child: child,
          ),
        ),
      ),
    );

    return hasFocusBorder ?? YaruTheme.maybeOf(context)?.focusBorders == true
        ? YaruFocusBorder.primary(child: content)
        : content;
  }
}
