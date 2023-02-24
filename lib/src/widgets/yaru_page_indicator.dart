import 'package:flutter/material.dart';

import 'yaru_carousel.dart';
import 'yaru_page_indicator_theme.dart';

typedef YaruDotDecorationBuilder = Decoration Function(
  int index,
);

/// A responsive page indicator.
///
/// If there's enough space, it will be rendered into a line of dots,
/// if not, it will be rendered into a text-based indicator.
///
/// See also:
///
///  * [YaruCarousel], display a list of widgets in a carousel view.
class YaruPageIndicator extends StatelessWidget {
  /// Create a [YaruPageIndicator].
  const YaruPageIndicator({
    super.key,
    required this.length,
    required this.page,
    this.animationDuration = Duration.zero,
    this.animationCurve = Curves.linear,
    this.onTap,
    this.dotSize = 12.0,
    this.dotSpacing = 48.0,
    this.dotDecorationBuilder,
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

  /// Size of the dots.
  final double dotSize;

  /// Base length for the space between the dots.
  /// Will be automatically reduced to fit the vertical constraints.
  final double dotSpacing;

  /// Decoration of the dots.
  final YaruDotDecorationBuilder? dotDecorationBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorTheme = YaruPageIndicatorTheme.of(context);

    final dotSize = indicatorTheme?.dotSize ?? this.dotSize;
    final dotSpacing = indicatorTheme?.dotSpacing ?? this.dotSpacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        for (final layout in [
          [dotSpacing, constraints.maxWidth / 2],
          [dotSpacing / 2, constraints.maxWidth / 3 * 2],
          [dotSpacing / 4, constraints.maxWidth / 6 * 5]
        ]) {
          final dotSpacing = layout[0];
          final maxWidth = layout[1];

          if (dotSize * length + dotSpacing * (length - 1) < maxWidth) {
            return _buildDotIndicator(
              theme,
              indicatorTheme,
              dotSize,
              dotSpacing,
            );
          }
        }

        return _buildTextIndicator(theme);
      },
    );
  }

  Widget _buildDotIndicator(
    ThemeData theme,
    YaruPageIndicatorThemeData? indicatorTheme,
    double dotSize,
    double dotSpacing,
  ) {
    final dotDecorationBuilder =
        indicatorTheme?.dotDecorationBuilder ?? this.dotDecorationBuilder;
    final animationDuration =
        indicatorTheme?.animationDuration ?? this.animationDuration;
    final animationCurve =
        indicatorTheme?.animationCurve ?? this.animationCurve;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(length, (index) {
        final dotDecoration = dotDecorationBuilder != null
            ? dotDecorationBuilder.call(index)
            : BoxDecoration(
                color: page == index
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(.3),
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

  Widget _buildTextIndicator(ThemeData theme) {
    return Text(
      '${page + 1}/$length',
      style: theme.textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }
}
