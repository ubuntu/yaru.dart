import 'package:flutter/material.dart';

import 'yaru_carousel.dart';
import 'yaru_page_indicator_layout_delegate.dart';
import 'yaru_page_indicator_theme.dart';

typedef YaruPageIndicatorItemBuilder<T> = T Function(
  int index,
  int selectedIndex,
  int length,
);

typedef YaruPageIndicatorTextBuilder = Widget Function(
  int page,
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
  YaruPageIndicator({
    super.key,
    required this.length,
    required this.page,
    this.onTap,
    this.mouseCursor,
    this.textBuilder,
    this.textStyle,
    double? dotSize,
    double? dotSpacing,
    this.animationDuration,
    this.animationCurve,
  })  : assert(page >= 0 && page <= length - 1),
        itemBuilder = null {
    itemSizeBuilder =
        dotSize != null ? (_, __, ___) => Size.square(dotSize) : null;
    layoutDelegate = dotSpacing != null
        ? YaruPageIndicatorSteppedDelegate(baseItemSpacing: dotSpacing)
        : null;
  }

  /// Create a [YaruPageIndicator].
  // ignore: prefer_const_constructors_in_immutables
  YaruPageIndicator.builder({
    super.key,
    required this.length,
    required this.page,
    this.onTap,
    this.itemSizeBuilder,
    this.itemBuilder,
    this.mouseCursor,
    this.textBuilder,
    this.textStyle,
    this.layoutDelegate,
    this.animationDuration,
    this.animationCurve,
  }) : assert(page >= 0 && page <= length - 1);

  /// Determine the number of pages.
  final int length;

  /// Current page index.
  /// This value should be clamped between 0 and [length] - 1
  final int page;

  /// Callback called when tapping a dot.
  /// It passes the tapped page index as parameter.
  final ValueChanged<int>? onTap;

  /// Returns the [Size] of a given item.
  /// These values are used to compute the layout using [layoutDelegate].
  /// If you want an animated items size, just return the largest bounds.
  ///
  /// Defaults to a constant 12.0 square.
  late final YaruPageIndicatorItemBuilder<Size>? itemSizeBuilder;

  /// Returns the [Widget] of a given item.
  ///
  /// Defaults to [YaruPageIndicatorItem].
  final YaruPageIndicatorItemBuilder<Widget>? itemBuilder;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  /// Returns the [Widget] of the text based indicator.
  /// Be careful to use something small enough to fit in a small vertical constraints.
  ///
  /// Defaults to a basic [Text] like "2/12".
  /// You can custimize the text style with [textStyle].
  final YaruPageIndicatorTextBuilder? textBuilder;

  /// Text style used to customize the default text based indicator.
  /// Useless if you set a custom [textBuilder];
  ///
  /// Defaults to [TextTheme.bodySmall].
  final TextStyle? textStyle;

  /// Controls the items spacing, depending on the vertical constraints.
  ///
  /// Defaults to [YaruPageIndicatorSteppedDelegate].
  late final YaruPageIndicatorLayoutDelegate? layoutDelegate;

  /// Duration of a size transition between two items.
  /// Use [Duration.zero] to disable transition.
  ///
  /// Defaults to [Duration.zero].
  final Duration? animationDuration;

  /// Curve used in a size transition between two items.
  ///
  /// Defaults to [Curves.linear].
  final Curve? animationCurve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorTheme = YaruPageIndicatorTheme.of(context);

    final layoutDelegate = this.layoutDelegate ??
        indicatorTheme?.layoutDelegate ??
        YaruPageIndicatorSteppedDelegate();
    final itemSizeBuilder = this.itemSizeBuilder ??
        indicatorTheme?.itemSizeBuilder ??
        (_, __, ___) => const Size.square(12.0);
    final itemBuilder = this.itemBuilder ??
        indicatorTheme?.itemBuilder ??
        (index, selectedIndex, _) =>
            YaruPageIndicatorItem(selected: selectedIndex == index);
    final states = {
      if (onTap == null) WidgetState.disabled,
    };
    final mouseCursor =
        WidgetStateProperty.resolveAs(this.mouseCursor, states) ??
            indicatorTheme?.mouseCursor?.resolve(states) ??
            WidgetStateMouseCursor.clickable.resolve(states);
    final textStyle = this.textStyle ??
        indicatorTheme?.textStyle ??
        theme.textTheme.bodySmall;
    final textBuilder = this.textBuilder ??
        indicatorTheme?.textBuilder ??
        (page, length) => Text(
              '$page/$length',
              style: textStyle,
              textAlign: TextAlign.center,
            );

    final itemSizes = <Size>[];
    var maxHeight = 0.0;
    var maxWidth = 0.0;

    for (var i = 0; i < length; i++) {
      itemSizes.add(itemSizeBuilder(i, page, length));

      maxWidth = itemSizes[i].width > maxWidth ? itemSizes[i].width : maxWidth;
      maxHeight =
          itemSizes[i].height > maxHeight ? itemSizes[i].height : maxHeight;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemSpacing = layoutDelegate.calculateItemsSpacing(
          allItemsWidth: maxWidth * length,
          length: length,
          availableWidth: constraints.maxWidth,
        );

        if (null == itemSpacing) {
          return textBuilder(page + 1, length);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(length, (index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(
                start: index != 0 ? itemSpacing : 0,
              ),
              child: _buildSizedContainer(
                width: itemSizes[index].width,
                height: itemSizes[index].height,
                child: Center(
                  child: GestureDetector(
                    onTap: onTap == null ? null : () => onTap!(index),
                    child: MouseRegion(
                      cursor: mouseCursor,
                      child: itemBuilder(index, page, length),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSizedContainer({
    required double width,
    required double height,
    required Widget child,
  }) {
    final animationDuration = this.animationDuration ?? Duration.zero;
    final animationCurve = this.animationCurve ?? Curves.linear;
    return animationDuration != Duration.zero
        ? AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            width: width,
            height: height,
            child: child,
          )
        : SizedBox(
            width: width,
            height: height,
            child: child,
          );
  }
}

/// Default item used in [YaruPageIndicator.itemBuilder].
/// Looks like a simple dot grey when unselected, and accented when selected.
class YaruPageIndicatorItem extends StatelessWidget {
  /// Default item used in [YaruPageIndicator.itemBuilder].
  /// Looks like a simple dot grey when unselected, and accented when selected.
  const YaruPageIndicatorItem({
    super.key,
    required this.selected,
    this.size,
    this.animationDuration,
    this.animationCurve,
    this.borderRadius,
  });

  /// Define if this is a selected item.
  final bool selected;

  /// Optionnal item size.
  final Size? size;

  /// Duration of a transition between two items.
  /// Use [Duration.zero] to disable transition.
  ///
  /// Defaults to [Duration.zero].
  final Duration? animationDuration;

  /// Curve used in a transition between two items.
  ///
  /// Defaults to [Curves.linear].
  final Curve? animationCurve;

  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final decoration = BoxDecoration(
      color: selected
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface.withOpacity(.3),
      shape: borderRadius == null ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: borderRadius,
    );
    final animationDuration = this.animationDuration ?? Duration.zero;
    final animationCurve = this.animationCurve ?? Curves.linear;

    return animationDuration != Duration.zero
        ? AnimatedContainer(
            width: size?.width,
            height: size?.height,
            duration: animationDuration,
            curve: animationCurve,
            decoration: decoration,
          )
        : Container(
            width: size?.width,
            height: size?.height,
            decoration: decoration,
          );
  }
}
