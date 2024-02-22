import 'package:flutter/widgets.dart';

/// Describe the position of a diagonal clip.
enum YaruDiagonalClip {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// A widget that clips its child using a custom clipper.
///
/// ## Diagonal clip
///
/// ```dart
/// Container(
///   color: Colors.red,
///   child: YaruClip.diagonal(
///     position: YaruDiagonalClip.bottomLeft,
///     child: Container(color: Colors.green),
///   ),
/// )
/// ```
abstract class YaruClip extends StatelessWidget {
  const YaruClip._({super.key, this.child});

  /// Clips the [child] using a diagonal path at the specified [position].
  const factory YaruClip.diagonal({
    Key? key,
    Widget? child,
    required YaruDiagonalClip position,
  }) = _YaruDiagonalClip;

  final Widget? child;
  CustomClipper<Path> get clipper;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: clipper,
      child: child,
    );
  }
}

class _YaruDiagonalClip extends YaruClip {
  const _YaruDiagonalClip({super.key, super.child, required this.position})
      : super._();

  final YaruDiagonalClip position;

  @override
  CustomClipper<Path> get clipper => _DiagonalClipper(position);
}

class _DiagonalClipper extends CustomClipper<Path> {
  const _DiagonalClipper(this.position);

  final YaruDiagonalClip position;

  @override
  Path getClip(Size size) {
    switch (position) {
      case YaruDiagonalClip.topLeft:
        return Path()
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height)
          ..close();
      case YaruDiagonalClip.topRight:
        return Path()
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..close();
      case YaruDiagonalClip.bottomLeft:
        return Path()
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
      case YaruDiagonalClip.bottomRight:
        return Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
    }
  }

  @override
  bool shouldReclip(_DiagonalClipper oldClipper) {
    return position != oldClipper.position;
  }
}
