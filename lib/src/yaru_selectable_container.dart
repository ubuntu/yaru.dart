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
    return InkWell(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
            color: selected
                ? selectionColor ??
                    Theme.of(context).primaryColor.withOpacity(0.8)
                : Colors.transparent),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
            child: child,
          ),
        ),
      ),
    );
  }
}
