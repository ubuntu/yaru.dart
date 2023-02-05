import 'package:flutter/widgets.dart';

/// A translucent watermark rendered on top of its child.
///
/// ```dart
/// YaruWatermark(
///   watermark: Icon(Icons.cloud)
///   child: YaruBanner(
///     ...
///   ),
/// )
/// ```
class YaruWatermark extends StatelessWidget {
  const YaruWatermark({
    super.key,
    required this.watermark,
    required this.child,
    this.alignment = AlignmentDirectional.centerEnd,
    this.padding = const EdgeInsets.all(20),
    this.opacity = 0.1,
  });

  /// The watermark to display in front.
  final Widget watermark;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The alignment of the [watermark]. Defaults to [AlignmentDirectional.centerEnd].
  final AlignmentGeometry alignment;

  /// The amount of space by which to inset the [watermark]. Defaults to
  /// `EdgeInsets.all(20)`.
  final EdgeInsetsGeometry padding;

  /// The opacity of the watermark. Defaults to 0.1.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Padding(
          padding: padding,
          child: Align(
            alignment: alignment,
            child: Opacity(
              opacity: opacity,
              child: watermark,
            ),
          ),
        ),
      ],
    );
  }
}
