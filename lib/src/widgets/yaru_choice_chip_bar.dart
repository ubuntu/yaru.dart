import 'package:flutter/material.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/icons.dart';
import 'package:yaru/theme.dart';

/// A list of [ChoiceChipBar]s wrapped either in a controllable [ListView] or [Wrap].
class YaruChoiceChipBar extends StatefulWidget {
  const YaruChoiceChipBar({
    super.key,
    required this.labels,
    this.onSelected,
    required this.isSelected,
    this.yaruChoiceChipBarStyle = YaruChoiceChipBarStyle.row,
    this.spacing = 10.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.navigationStep = 100.0,
    this.animationCurve = Curves.bounceIn,
    this.radius = kYaruTitleBarItemHeight,
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
    this.clearOnSelect = true,
    this.shrinkWrap = true,
    this.showCheckMarks = true,
    this.selectedFirst = true,
    this.borderColor,
    this.chipBackgroundColor,
    this.selectedChipBackgroundColor,
    this.navigationButtonElevation,
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
  final YaruChoiceChipBarStyle yaruChoiceChipBarStyle;

  /// Sets how long the navigation jumps and fade in and out of
  /// the scrolling controls are animated.
  final Duration animationDuration;

  /// Sets how far each scrolling step jumps in the [ListView].
  final double navigationStep;

  /// Sets the easing [Curve] of the animations.
  final Curve animationCurve;

  /// Sets how round the [ChoiceChips] and scrolling control buttons are.
  final double radius;

  /// The optional [Color] of the [BorderSide] of the [ChoiceChips]
  /// Defaults to `Theme.of(context).chipTheme.shape?.side.color ?? Theme.of(context).colorScheme.outline`
  final Color? borderColor;

  /// The optional [Color] of the [ShapeBorder] of the [ChoiceChips]
  /// Defaults to `Theme.of(context).chipTheme.backgroundColor`
  final Color? chipBackgroundColor;

  /// The optional [Color] of the [ShapeBorder] of the [ChoiceChips] if selected.
  /// Defaults to `Theme.of(context).chipTheme.selectedColor`
  final Color? selectedChipBackgroundColor;

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

  @override
  State<YaruChoiceChipBar> createState() => _YaruChoiceChipBarState();
}

class _YaruChoiceChipBarState extends State<YaruChoiceChipBar> {
  late ScrollController _controller;
  bool _enableGoPreviousButton = false;
  bool _enableGoNextButton = true;

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
    final theme = Theme.of(context);

    Widget themedChip(int index) {
      return ChipTheme(
        data: theme.chipTheme.copyWith(
          backgroundColor: widget.chipBackgroundColor,
          selectedColor: widget.selectedChipBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            side: BorderSide(
              color: widget.borderColor ??
                  theme.chipTheme.shape?.side.color ??
                  theme.colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        child: ChoiceChip(
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
        ),
      );
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
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(
                right: widget.spacing,
              ),
              child: e,
            ),
          )
          .toList(),
    );

    final goPreviousButton = _NavigationButton(
      elevation: widget.navigationButtonElevation,
      borderColor: widget.borderColor,
      chipBackgroundColor: widget.chipBackgroundColor,
      radius: widget.radius,
      chipHeight: widget.chipHeight,
      icon: widget.goPreviousIcon ?? const Icon(YaruIcons.go_previous),
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
      borderColor: widget.borderColor,
      chipBackgroundColor: widget.chipBackgroundColor,
      chipHeight: widget.chipHeight,
      radius: widget.radius,
      icon: widget.goNextIcon ?? const Icon(YaruIcons.go_next),
      onTap: _enableGoNextButton
          ? () => _controller.animateTo(
                _controller.position.pixels + widget.navigationStep,
                duration: widget.animationDuration,
                curve: widget.animationCurve,
              )
          : null,
    );

    if (widget.yaruChoiceChipBarStyle == YaruChoiceChipBarStyle.wrap) {
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
    } else if (widget.yaruChoiceChipBarStyle == YaruChoiceChipBarStyle.stack) {
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
              Positioned(
                left: 0,
                child: goPreviousButton,
              ),
            if (_enableGoNextButton)
              Positioned(
                right: 0,
                child: goNextButton,
              ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: widget.chipHeight,
        child: Row(
          children: [
            goPreviousButton,
            SizedBox(
              width: widget.spacing,
            ),
            Expanded(
              child: listView,
            ),
            SizedBox(
              width: widget.spacing,
            ),
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
    required this.radius,
    required this.chipHeight,
    this.borderColor,
    this.chipBackgroundColor,
    this.elevation,
  });

  final Function()? onTap;
  final Widget icon;
  final double radius;
  final double chipHeight;
  final Color? borderColor;
  final Color? chipBackgroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(
        color: borderColor ?? theme.colorScheme.outline,
        width: 1,
      ),
    );

    return SizedBox(
      height: chipHeight,
      width: chipHeight,
      child: Material(
        shape: roundedRectangleBorder,
        color: chipBackgroundColor?.scale(lightness: 0.1),
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

enum YaruChoiceChipBarStyle {
  wrap,
  row,
  stack;
}
