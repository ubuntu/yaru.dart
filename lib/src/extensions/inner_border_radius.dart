import 'package:flutter/widgets.dart';

extension InnerBorderRadius on BorderRadius {
  /// Computer an inner border radius from a given padding
  BorderRadius inner(EdgeInsets padding) {
    return BorderRadius.only(
      topLeft: Radius.elliptical(
        topLeft.x - padding.left / 2,
        topLeft.y - padding.top / 2,
      ),
      topRight: Radius.elliptical(
        topRight.x - padding.right / 2,
        topRight.y - padding.top / 2,
      ),
      bottomRight: Radius.elliptical(
        bottomRight.x - padding.right / 2,
        bottomRight.y - padding.bottom / 2,
      ),
      bottomLeft: Radius.elliptical(
        bottomLeft.x - padding.left / 2,
        bottomLeft.y - padding.bottom / 2,
      ),
    );
  }
}
