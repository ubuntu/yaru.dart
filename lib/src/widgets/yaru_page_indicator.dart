import 'package:flutter/material.dart';

/// A Yaru page indicator.
///
/// If there's enough space, it will be rendered into a line of dots,
/// if not, it will be rendered into a text-based indicator.
class YaruPageIndicator extends StatelessWidget {
  /// Create a [YaruPageIndicator].
  const YaruPageIndicator({
    super.key,
    required this.length,
    required this.page,
    this.animationDuration = Duration.zero,
    this.animationCurve = Curves.linear,
    this.onTap,
  }) : assert(page >= 0 && page <= length - 1);

  /// Determine the number of pages.
  final int length;

  /// Current page index.
  /// This value should be clamped between 0 and [length] - 1
  final int page;

  /// Duration of a transition between two dots.
  /// Use [Duration.zero] (defaults) to disable transition.
  final Duration animationDuration;

  /// Curve used in a transition between two dots.
  final Curve animationCurve;

  /// Callback called when tapping a dot.
  /// It passes the tapped page index as parameter.
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dotSize = 12.0;

        for (final layout in [
          [48.0, constraints.maxWidth / 2],
          [24.0, constraints.maxWidth / 3 * 2],
          [12.0, constraints.maxWidth / 6 * 5]
        ]) {
          final dotSpacing = layout[0];
          final maxWidth = layout[1];

          if (dotSize * length + dotSpacing * (length - 1) < maxWidth) {
            return _buildDotIndicator(context, dotSize, dotSpacing);
          }
        }

        return _buildTextIndicator(context);
      },
    );
  }

  Widget _buildDotIndicator(
    BuildContext context,
    double dotSize,
    double dotSpacing,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(length, (index) {
        final dotDecoration = BoxDecoration(
          color: page == index
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(.3),
          shape: BoxShape.circle,
        );

        return GestureDetector(
          onTap: onTap == null ? null : () => onTap!(index),
          child: Padding(
            padding: EdgeInsets.only(left: index != 0 ? dotSpacing : 0),
            child: MouseRegion(
              cursor: onTap == null
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              child: animationDuration == Duration.zero
                  ? Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: dotDecoration,
                    )
                  : AnimatedContainer(
                      duration: animationDuration,
                      curve: animationCurve,
                      width: dotSize,
                      height: dotSize,
                      decoration: dotDecoration,
                    ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextIndicator(BuildContext context) {
    return Text(
      '${page + 1}/$length',
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }
}
