import 'package:flutter/widgets.dart';

extension YaruBorderRadiusExtension on BorderRadius {
  /// Compute an inner border radius from a given padding
  BorderRadius inner(EdgeInsets padding) {
    final topLeftX = topLeft.x - padding.left / 2;
    final topLeftY = topLeft.y - padding.top / 2;
    final topRightX = topRight.x - padding.right / 2;
    final topRightY = topRight.y - padding.top / 2;
    final bottomLeftX = bottomLeft.x - padding.left / 2;
    final bottomLeftY = bottomLeft.y - padding.bottom / 2;
    final bottomRightX = bottomRight.x - padding.right / 2;
    final bottomRightY = bottomRight.y - padding.bottom / 2;

    return BorderRadius.only(
      topLeft: Radius.elliptical(
        topLeftX < 0 ? 0 : topLeftX,
        topLeftY < 0 ? 0 : topLeftY,
      ),
      topRight: Radius.elliptical(
        topRightX < 0 ? 0 : topRightX,
        topRightY < 0 ? 0 : topRightY,
      ),
      bottomRight: Radius.elliptical(
        bottomRightX < 0 ? 0 : bottomRightX,
        bottomRightY < 0 ? 0 : bottomRightY,
      ),
      bottomLeft: Radius.elliptical(
        bottomLeftX < 0 ? 0 : bottomLeftX,
        bottomLeftY < 0 ? 0 : bottomLeftY,
      ),
    );
  }

  /// Compute an outer border radius from a given margin
  BorderRadius outer(EdgeInsets margin) {
    return BorderRadius.only(
      topLeft: Radius.elliptical(
        topLeft.x + margin.left / 2,
        topLeft.y + margin.top / 2,
      ),
      topRight: Radius.elliptical(
        topRight.x + margin.right / 2,
        topRight.y + margin.top / 2,
      ),
      bottomRight: Radius.elliptical(
        bottomRight.x + margin.right / 2,
        bottomRight.y + margin.bottom / 2,
      ),
      bottomLeft: Radius.elliptical(
        bottomLeft.x + margin.left / 2,
        bottomLeft.y + margin.bottom / 2,
      ),
    );
  }
}
