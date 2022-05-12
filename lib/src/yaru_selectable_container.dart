import 'package:flutter/material.dart';
import 'package:yaru_widgets/src/constants.dart';

class YaruSelectableContainer extends StatelessWidget {
  /// Creates a Image Tile from the image path given in the path property.
  const YaruSelectableContainer({
    Key? key,
    required this.child,
    this.onTap,
    required this.selected,
    this.borderRadius,
    this.radius = kDefaultContainerRadius,
    this.padding,
    this.selectionColor,
  }) : super(key: key);

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
  final EdgeInsets? padding;

  /// Optional custom [Color] which is used for the selection border.
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? const EdgeInsets.all(6);
    final borderRadius = this.borderRadius ?? BorderRadius.circular(radius);
    final innerBorderRadius = BorderRadius.only(
      topLeft: Radius.elliptical(borderRadius.topLeft.x - padding.left / 2,
          borderRadius.topLeft.y - padding.top / 2),
      topRight: Radius.elliptical(borderRadius.topRight.x - padding.right / 2,
          borderRadius.topRight.y - padding.top / 2),
      bottomRight: Radius.elliptical(
          borderRadius.bottomRight.x - padding.right / 2,
          borderRadius.bottomRight.y - padding.bottom / 2),
      bottomLeft: Radius.elliptical(
          borderRadius.bottomLeft.x - padding.left / 2,
          borderRadius.bottomLeft.y - padding.bottom / 2),
    );

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: selected
                ? selectionColor ??
                    Theme.of(context).primaryColor.withOpacity(0.8)
                : Colors.transparent),
        child: Padding(
          padding: padding,
          child: ClipRRect(
            borderRadius: innerBorderRadius,
            child: child,
          ),
        ),
      ),
    );
  }
}
