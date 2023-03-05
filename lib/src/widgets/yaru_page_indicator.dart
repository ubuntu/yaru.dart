import 'package:flutter/material.dart';

import 'yaru_carousel.dart';
import 'yaru_page_indicator_theme.dart';

typedef YaruDotDecorationBuilder = Decoration Function(
  int index,
  int selectedIndex,
  int length,
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
    this.animationDuration,
    this.animationCurve,
    this.onTap,
    this.dotSize,
    this.dotSpacing,
    this.dotDecorationBuilder,
    this.mouseCursor,
  }) : assert(page >= 0 && page <= length - 1);

  /// Determine the number of pages.
  final int length;

  /// Current page index.
  /// This value should be clamped between 0 and [length] - 1
  final int page;

  /// Duration of a transition between two dots.
  /// Use [Duration.zero] (defaults) to disable transition.
  ///
  /// Defaults to [Duration.zero].
  final Duration? animationDuration;

  /// Curve used in a transition between two dots.
  ///
  /// Defaults to [Curves.linear].
  final Curve? animationCurve;

  /// Callback called when tapping a dot.
  /// It passes the tapped page index as parameter.
  final ValueChanged<int>? onTap;

  /// Size of the dots.
  ///
  /// Defaults to 12.0
  final double? dotSize;

  /// Base length for the space between the dots.
  /// Will be automatically reduced to fit the vertical constraints.
  ///
  /// Defaults to 48.0
  final double? dotSpacing;

  /// Decoration of the dots.
  final YaruDotDecorationBuilder? dotDecorationBuilder;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorTheme = YaruPageIndicatorTheme.of(context);

    final dotSize = this.dotSize ?? indicatorTheme?.dotSize ?? 12.0;
    final dotSpacing = this.dotSpacing ?? indicatorTheme?.dotSpacing ?? 48.0;

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
        this.dotDecorationBuilder ?? indicatorTheme?.dotDecorationBuilder;
    final animationDuration = this.animationDuration ??
        indicatorTheme?.animationDuration ??
        Duration.zero;
    final animationCurve =
        this.animationCurve ?? indicatorTheme?.animationCurve ?? Curves.linear;
    final mouseCursor = this.mouseCursor ??
        indicatorTheme?.mouseCursor
            ?.resolve({if (onTap == null) MaterialState.disabled}) ??
        (onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(length, (index) {
        final dotDecoration = dotDecorationBuilder != null
            ? dotDecorationBuilder.call(index, page, length)
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
              cursor: mouseCursor,
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
