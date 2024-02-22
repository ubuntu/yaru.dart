import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const int kIndeterminateAnimationDuration = 8000;
const Curve kIndeterminateAnimationCurve =
    Cubic(.35, .75, .65, .25); // Kind of `Curves.slowMiddle` curve
const double kDefaultStrokeWidth = 6;

abstract class YaruProgressIndicator extends StatefulWidget {
  /// Creates a Yaru progress indicator.
  ///
  /// {@template yaru.widget.YaruProgressIndicator.YaruProgressIndicator}
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  ///
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be used
  /// for determinate progress indicators to indicate how much progress has been made.
  /// {@endtemplate}
  const YaruProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.valueColor,
    this.trackColor,
    this.trackValueColor,
    this.strokeWidth,
    this.trackStrokeWidth,
    this.semanticsLabel,
    this.semanticsValue,
  })  : assert(strokeWidth == null || strokeWidth > 0),
        assert(trackStrokeWidth == null || trackStrokeWidth > 0);

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// {@template yaru.widget.YaruProgressIndicator.color}
  /// The progress indicator's color.
  ///
  /// This is only used if [valueColor] is null.
  /// If [color] is also null, then the ambient
  /// [YaruProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  /// {@endtemplate}
  final Color? color;

  /// {@template yaru.widget.YaruProgressIndicator.valueColor}
  /// The progress indicator's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [color]. If that is null,
  /// then it will use the ambient [YaruProgressIndicatorThemeData.color]. If that
  /// is also null then it defaults to the current theme's [ColorScheme.primary].
  /// {@endtemplate}
  final Animation<Color?>? valueColor;

  /// {@template yaru.widget.YaruProgressIndicator.trackColor}
  /// The progress indicator track's color.
  ///
  /// This is only used if [trackValueColor] is null.
  /// If [trackColor] is also null, then the ambient
  /// [YaruProgressIndicatorThemeData.trackColor] will be used. If that
  /// is null then it defaults to a translucent version of the resolved [color] value.
  /// {@endtemplate}
  final Color? trackColor;

  /// {@template yaru.widget.YaruProgressIndicator.trackValueColor}
  /// The progress indicator track's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [trackColor]. If that is null,
  /// then it will use the ambient [YaruProgressIndicatorThemeData.trackColor]. If that
  /// is null then it defaults to a translucent version of the resolved [color] value.
  /// {@endtemplate}
  final Animation<Color?>? trackValueColor;

  /// {@template yaru.widget.YaruProgressIndicator.strokeWidth}
  /// The thickness of the line used to draw the value indicator (default: 6.0).
  /// {@endtemplate}
  final double? strokeWidth;

  /// {@template yaru.widget.YaruProgressIndicator.trackStrokeWidth}
  /// The thickness of the line drawn below the value indicator line.
  /// Defaults to a slightly smaller value than [strokeWidth].
  /// See: [computeDefaultTrackSize].
  /// {@endtemplate}
  final double? trackStrokeWidth;

  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  final String? semanticsLabel;

  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  final String? semanticsValue;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      PercentProperty(
        'value',
        value,
        showName: false,
        ifNull: '<indeterminate>',
      ),
    );
  }

  Widget buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    var expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }

  double computeDefaultTrackSize(double size) {
    final candidateTrackHeight = (size / 3 * 2).truncate();
    return (candidateTrackHeight + (candidateTrackHeight.isEven ? 0 : 1))
        .toDouble();
  }
}

abstract class YaruProgressIndicatorThemeData<
    T extends YaruProgressIndicatorThemeData<T>> extends ThemeExtension<T> {
  YaruProgressIndicatorThemeData(
    this.color,
    this.trackColor,
    this.strokeWidth,
    this.trackStrokeWidth,
  );

  /// {@macro yaru.widget.YaruProgressIndicator.color}
  final Color? color;

  /// {@macro yaru.widget.YaruProgressIndicator.trackColor}
  final Color? trackColor;

  /// {@macro yaru.widget.YaruProgressIndicator.strokeWidth}
  final double? strokeWidth;

  /// {@macro yaru.widget.YaruProgressIndicator.trackStrokeWidth}
  final double? trackStrokeWidth;
}
