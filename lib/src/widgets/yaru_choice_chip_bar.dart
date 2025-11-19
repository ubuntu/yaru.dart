import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// A list of [ChoiceChipBar]s wrapped either in a controllable [ListView] or [Wrap].
class YaruChoiceChipBar extends StatefulWidget {
  const YaruChoiceChipBar({
    super.key,
    required this.labels,
    this.onSelected,
    required this.isSelected,
    this.style = YaruChoiceChipBarStyle.row,
    this.spacing = 10.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.navigationStep = 100.0,
    this.animationCurve = Curves.bounceIn,
    this.chipHeight = kYaruTitleBarItemHeight,
    this.wrapScrollDirection = Axis.horizontal,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 10.0,
    this.wrapCrossAlignment = WrapCrossAlignment.start,
    this.wrapVerticalDirection = VerticalDirection.down,
    this.wrapClipBehavior = Clip.none,
    this.wrapTextDirection,
    this.goPreviousIcon,
    this.goNextIcon,
    this.goPreviousIconSemanticLabel,
    this.goNextIconSemanticLabel,
    this.clearOnSelect = true,
    this.shrinkWrap = true,
    this.showCheckMarks = true,
    this.selectedFirst = true,
    this.navigationButtonElevation,
    this.chipHasFocusBorder,
  }) : assert(labels.length == isSelected.length);

  /// The [List] of [Widget]'s used to generate a [List] of [ChoiceChip]s
  /// in which they are placed.
  /// The length of [labels] mus be equal to [isSelected]!
  final List<Widget> labels;

  /// The [List] of [bool] used to determine if the assigned
  /// [ChoiceChip] is selected.
  /// The length of [isSelected] must be equal to [labels]!
  final List<bool> isSelected;

  /// The [Function] called when a [ChoiceChip] with given `index` is selected.
  /// If [onSelected] is null, the whole [YaruChoiceChipBar] is disabled.
  final void Function(int index)? onSelected;

  /// Determines weither the [ChoiceChip]s should be put into a [ListView]
  /// or a [Wrap] or a [ListView] but with the scrolling controls
  /// put into a [Stack] on top of the [ListView].
  final YaruChoiceChipBarStyle style;

  /// Sets how long the navigation jumps and fade in and out of
  /// the scrolling controls are animated.
  final Duration animationDuration;

  /// Sets how far each scrolling step jumps in the [ListView].
  final double navigationStep;

  /// Sets the easing [Curve] of the animations.
  final Curve animationCurve;

  /// The optional elevation of the navigation buttons. Defaults to 0.
  final double? navigationButtonElevation;

  /// Sets how high the whole bar is.
  final double chipHeight;

  /// The spacing of [ChoiceChip]s inside the [Wrap] or the [ListView]
  final double spacing;

  /// The spacing of the [ChoiceChip]s when the [Wrap] places them
  ///  in another row.
  final double wrapRunSpacing;

  /// The alignment of the [ChoiceChip]s when the [Wrap] places them
  /// in another row.
  final Axis wrapScrollDirection;

  /// The [WrapAlignment] of the [ChoiceChip]s with `YaruChoiceChipStyle.wrap`.
  final WrapAlignment wrapAlignment;

  /// The [WrapCrossAlignment] of the [ChoiceChip]s with `YaruChoiceChipStyle.wrap`
  final WrapCrossAlignment wrapCrossAlignment;

  ///  of the [ChoiceChip]s with `YaruChoiceChipStyle.wrap`
  final Clip wrapClipBehavior;

  /// The [WrapAlignment] of the [ChoiceChip]s with with `YaruChoiceChipStyle.wrap`
  final WrapAlignment wrapRunAlignment;

  /// The [TextDirection] of the [ChoiceChip]s with with `YaruChoiceChipStyle.wrap`
  final TextDirection? wrapTextDirection;

  /// The [VerticalDirection] of the [ChoiceChip]s with `YaruChoiceChipStyle.wrap`
  final VerticalDirection wrapVerticalDirection;

  /// The [Widget] shown inside the left navigation button.
  final Widget? goPreviousIcon;

  /// The [Widget] shown inside the right navigation button.
  final Widget? goNextIcon;

  /// Optional semantic label to add to the previous button icon.
  final String? goPreviousIconSemanticLabel;

  /// Optional semantic label to add to the next button icon.
  final String? goNextIconSemanticLabel;

  /// Flag to select if the scroll view should to back to the start on selection.
  /// Defaults to `true`.
  final bool clearOnSelect;

  /// Forwards this to the internal [ListView] if [YaruChoiceChipBarStyle.row]
  /// or [YaruChoiceChipBarStyle.wrap] are used. The default is `false`
  final bool shrinkWrap;

  /// Defines if the [ChoiceChip]s inside should show the checkmark.
  /// The default is `true`.
  final bool showCheckMarks;

  /// Defines if the selected [ChoiceChip]s should be always placed first.
  final bool selectedFirst;

  /// Whether the chips display the default focus border when focused.
  final bool? chipHasFocusBorder;

  @override
  State<YaruChoiceChipBar> createState() => _YaruChoiceChipBarState();
}

class _YaruChoiceChipBarState extends State<YaruChoiceChipBar> {
  late ScrollController _controller;
  bool _enableGoPreviousButton = false;
  bool _enableGoNextButton = false;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.atEdge) {
          final isLeft = _controller.position.pixels == 0;
          setState(() {
            if (isLeft) {
              _enableGoNextButton = true;
              _enableGoPreviousButton = false;
            } else {
              _enableGoNextButton = false;
              _enableGoPreviousButton = true;
            }
          });
        } else {
          setState(() {
            _enableGoPreviousButton = true;
            _enableGoNextButton = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget themedChip(int index) {
      final chip = ChoiceChip(
        showCheckmark: widget.showCheckMarks,
        label: widget.labels[index],
        selected: widget.isSelected[index],
        onSelected: widget.onSelected == null
            ? null
            : (v) {
                widget.onSelected!(index);
                if (widget.clearOnSelect) {
                  _controller.jumpTo(
                    _controller.position.minScrollExtent - widget.chipHeight,
                  );
                }
              },
      );
      return widget.chipHasFocusBorder ??
              YaruTheme.maybeOf(context)?.focusBorders == true
          ? YaruFocusBorder.primary(
              borderStrokeAlign: BorderSide.strokeAlignInside,
              borderRadius: BorderRadius.circular(100),
              child: chip,
            )
          : chip;
    }

    final children = widget.selectedFirst
        ? [
            for (int index = 0; index < widget.labels.length; index++)
              if (widget.isSelected[index]) themedChip(index),
            for (int index = 0; index < widget.labels.length; index++)
              if (!widget.isSelected[index]) themedChip(index),
          ]
        : [
            for (int index = 0; index < widget.labels.length; index++)
              themedChip(index),
          ];

    final listView = ListView(
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: Axis.horizontal,
      controller: _controller,
      children: children
          .expand((item) sync* {
            yield SizedBox(width: widget.spacing);
            yield item;
          })
          .skip(1)
          .toList(),
    );

    final goPreviousButton = _NavigationButton(
      elevation: widget.navigationButtonElevation,
      chipHeight: widget.chipHeight,
      icon:
          widget.goPreviousIcon ??
          Icon(
            YaruIcons.go_previous,
            semanticLabel: widget.goPreviousIconSemanticLabel,
          ),
      onTap: _enableGoPreviousButton
          ? () => _controller.animateTo(
              _controller.position.pixels - widget.navigationStep,
              duration: widget.animationDuration,
              curve: widget.animationCurve,
            )
          : null,
    );

    final goNextButton = _NavigationButton(
      elevation: widget.navigationButtonElevation,
      chipHeight: widget.chipHeight,
      icon:
          widget.goNextIcon ??
          Icon(
            YaruIcons.go_next,
            semanticLabel: widget.goNextIconSemanticLabel,
          ),
      onTap: _enableGoNextButton
          ? () => _controller.animateTo(
              _controller.position.pixels + widget.navigationStep,
              duration: widget.animationDuration,
              curve: widget.animationCurve,
            )
          : null,
    );

    if (widget.style == YaruChoiceChipBarStyle.wrap) {
      return Wrap(
        alignment: widget.wrapAlignment,
        clipBehavior: widget.wrapClipBehavior,
        crossAxisAlignment: widget.wrapCrossAlignment,
        runAlignment: widget.wrapRunAlignment,
        textDirection: widget.wrapTextDirection,
        verticalDirection: widget.wrapVerticalDirection,
        spacing: widget.spacing,
        runSpacing: widget.spacing,
        direction: widget.wrapScrollDirection,
        children: children,
      );
    } else if (widget.style == YaruChoiceChipBarStyle.stack) {
      return SizedBox(
        height: widget.chipHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  _enableGoPreviousButton ? widget.chipHeight : 0.0,
                ),
                bottomLeft: Radius.circular(
                  _enableGoPreviousButton ? widget.chipHeight : 0.0,
                ),
                topRight: Radius.circular(
                  _enableGoNextButton ? widget.chipHeight : 0.0,
                ),
                bottomRight: Radius.circular(
                  _enableGoNextButton ? widget.chipHeight : 0.0,
                ),
              ),
              child: listView,
            ),
            if (_enableGoPreviousButton)
              Positioned(left: 0, child: goPreviousButton),
            if (_enableGoNextButton) Positioned(right: 0, child: goNextButton),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: widget.chipHeight,
        child: Row(
          children: [
            goPreviousButton,
            SizedBox(width: widget.spacing),
            Expanded(child: listView),
            SizedBox(width: widget.spacing),
            goNextButton,
          ],
        ),
      );
    }
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    this.onTap,
    required this.icon,
    required this.chipHeight,
    this.elevation,
  });

  final Function()? onTap;
  final Widget icon;
  final double chipHeight;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(chipHeight / 2),
      side: BorderSide(
        strokeAlign: -1,
        color: (theme.colorScheme.isHighContrast == true
            ? theme.colorScheme.outlineVariant
            : theme.colorScheme.outline),
        width: 1,
      ),
    );

    return SizedBox.square(
      dimension: chipHeight - 2,
      child: Material(
        shape: roundedRectangleBorder,
        elevation: elevation ?? 0.0,
        child: InkWell(
          customBorder: roundedRectangleBorder,
          onTap: onTap,
          child: icon,
        ),
      ),
    );
  }
}

enum YaruChoiceChipBarStyle { wrap, row, stack }
