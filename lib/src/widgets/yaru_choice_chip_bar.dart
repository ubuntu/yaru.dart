import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

class YaruChoiceChipBar extends StatefulWidget {
  const YaruChoiceChipBar({
    super.key,
    this.wrapScrollDirection = Axis.horizontal,
    required this.labels,
    required this.onSelected,
    required this.isSelected,
    this.yaruChoiceChipBarStyle = YaruChoiceChipBarStyle.row,
    this.spacing = 10.0,
    this.duration = const Duration(milliseconds: 200),
    this.animationStep = 100.0,
  }) : assert(labels.length == isSelected.length);

  final Axis wrapScrollDirection;
  final YaruChoiceChipBarStyle yaruChoiceChipBarStyle;
  final double spacing;
  final Duration duration;
  final double animationStep;

  final List<Widget> labels;
  final List<bool> isSelected;

  final void Function(int index) onSelected;

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
    final children = [
      for (int index = 0; index < widget.labels.length; index++)
        if (widget.isSelected[index])
          ChoiceChip(
            label: widget.labels[index],
            selected: widget.isSelected[index],
            onSelected: (v) => widget.onSelected(index),
          ),
      for (int index = 0; index < widget.labels.length; index++)
        if (!widget.isSelected[index])
          ChoiceChip(
            label: widget.labels[index],
            selected: widget.isSelected[index],
            onSelected: (v) => widget.onSelected(index),
          )
    ];

    final listView = ListView(
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

    final borderRadius = BorderRadius.circular(8);
    final roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: BorderSide(
        color: theme.colorScheme.outline,
        width: 1,
      ),
    );

    const size = 34.0;

    final goPreviousButton = SizedBox(
      height: size,
      width: size,
      child: Material(
        shape: roundedRectangleBorder,
        child: InkWell(
          customBorder: roundedRectangleBorder,
          onTap: _enableGoPreviousButton
              ? () => _controller.animateTo(
                    _controller.position.pixels - widget.animationStep,
                    duration: widget.duration,
                    curve: Curves.bounceIn,
                  )
              : null,
          child: const Icon(YaruIcons.go_previous),
        ),
      ),
    );

    final goNextButton = SizedBox(
      height: size,
      width: size,
      child: Material(
        shape: roundedRectangleBorder,
        child: InkWell(
          customBorder: roundedRectangleBorder,
          onTap: _enableGoNextButton
              ? () => _controller.animateTo(
                    _controller.position.pixels + widget.animationStep,
                    duration: widget.duration,
                    curve: Curves.bounceIn,
                  )
              : null,
          child: const Icon(YaruIcons.go_next),
        ),
      ),
    );

    if (widget.yaruChoiceChipBarStyle == YaruChoiceChipBarStyle.wrap) {
      return Wrap(
        spacing: widget.spacing,
        runSpacing: widget.spacing,
        direction: widget.wrapScrollDirection,
        children: children,
      );
    } else if (widget.yaruChoiceChipBarStyle == YaruChoiceChipBarStyle.stack) {
      return SizedBox(
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            listView,
            if (_enableGoPreviousButton)
              Positioned(
                left: 0,
                child: goPreviousButton,
              ),
            if (_enableGoNextButton)
              Positioned(
                right: 0,
                child: goNextButton,
              )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 60,
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

enum YaruChoiceChipBarStyle {
  wrap,
  row,
  stack;
}
