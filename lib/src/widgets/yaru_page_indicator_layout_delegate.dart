import 'yaru_page_indicator.dart';

/// Layout delegate interface which controls a [YaruPageIndicator] items spacing.
abstract class YaruPageIndicatorLayoutDelegate {
  double? calculateItemsSpacing({
    required double allItemsWidth,
    required int length,
    required double availableWidth,
  });
}

/// Controls a [YaruPageIndicator] items spacing in a stepped way.
class YaruPageIndicatorSteppedDelegate extends YaruPageIndicatorLayoutDelegate {
  /// Controls a [YaruPageIndicator] items spacing in a stepped way.
  YaruPageIndicatorSteppedDelegate({this.baseItemSpacing});

  /// Base length for the space between the items.
  /// Will be automatically reduced to fit the vertical constraints.
  ///
  /// Defaults to 48.0
  final double? baseItemSpacing;

  @override
  double? calculateItemsSpacing({
    required double allItemsWidth,
    required int length,
    required double availableWidth,
  }) {
    final baseItemSpacing = this.baseItemSpacing ?? 48.0;

    for (final layout in [
      [baseItemSpacing, availableWidth / 2],
      [baseItemSpacing / 2, availableWidth / 3 * 2],
      [baseItemSpacing / 4, availableWidth / 6 * 5],
    ]) {
      final baseItemSpacing = layout[0];
      final maxWidth = layout[1];

      if (allItemsWidth + baseItemSpacing * (length - 1) < maxWidth) {
        return baseItemSpacing;
      }
    }

    return null;
  }
}

/// Controls a [YaruPageIndicator] items spacing in a fixed way.
class YaruPageIndicatorFixedDelegate extends YaruPageIndicatorLayoutDelegate {
  /// Controls a [YaruPageIndicator] items spacing in a fixed way.
  YaruPageIndicatorFixedDelegate({this.itemSpacing});

  /// Length for the space between the items.
  ///
  /// Defaults to 24.0
  final double? itemSpacing;

  @override
  double? calculateItemsSpacing({
    required double allItemsWidth,
    required int length,
    required double availableWidth,
  }) {
    final itemSpacing = this.itemSpacing ?? 24.0;

    if (allItemsWidth + itemSpacing * (length - 1) < availableWidth) {
      return itemSpacing;
    }

    return null;
  }
}

/// Controls a [YaruPageIndicator] items spacing in a boudnded way.
class YaruPageIndicatorBoundedDelegate extends YaruPageIndicatorLayoutDelegate {
  /// Controls a [YaruPageIndicator] items spacing in a boudnded way.
  YaruPageIndicatorBoundedDelegate({
    this.maxItemSpacing,
    this.minItemSpacing,
  });

  /// Max length for the space between the items.
  ///
  /// Defaults to 48.0
  final double? maxItemSpacing;

  /// Min length for the space between the items.
  ///
  /// Defaults to 16.0
  final double? minItemSpacing;

  @override
  double? calculateItemsSpacing({
    required double allItemsWidth,
    required int length,
    required double availableWidth,
  }) {
    final maxItemSpacing = this.maxItemSpacing ?? 48.0;
    final minItemSpacing = this.minItemSpacing ?? 16.0;

    if (allItemsWidth + maxItemSpacing * (length - 1) < availableWidth) {
      return maxItemSpacing;
    } else if (allItemsWidth + minItemSpacing * (length - 1) > availableWidth) {
      return null;
    }

    return (availableWidth - allItemsWidth) / (length - 1);
  }
}
