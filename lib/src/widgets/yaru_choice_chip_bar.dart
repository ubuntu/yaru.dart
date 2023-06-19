import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruChoiceChipBar extends StatefulWidget {
  const YaruChoiceChipBar({
    super.key,
    this.wrapScrollDirection = Axis.horizontal,
    required this.labels,
    required this.onSelected,
    required this.isSelected,
    this.wrap = false,
    this.spacing = 10.0,
    this.duration = const Duration(milliseconds: 200),
    this.animationStep = 100.0,
  }) : assert(labels.length == isSelected.length);

  final Axis wrapScrollDirection;
  final bool wrap;
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

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    if (widget.wrap) {
      return Wrap(
        spacing: widget.spacing,
        runSpacing: widget.spacing,
        direction: widget.wrapScrollDirection,
        children: children,
      );
    } else {
      return SizedBox(
        height: 60,
        child: Row(
          children: [
            YaruIconButton(
              icon: const Icon(YaruIcons.go_previous),
              onPressed: () => _controller.animateTo(
                _controller.position.pixels - widget.animationStep,
                duration: widget.duration,
                curve: Curves.bounceIn,
              ),
            ),
            SizedBox(
              width: widget.spacing,
            ),
            Expanded(
              child: ListView(
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
              ),
            ),
            SizedBox(
              width: widget.spacing,
            ),
            YaruIconButton(
              icon: const Icon(YaruIcons.go_next),
              onPressed: () => _controller.animateTo(
                _controller.position.pixels + widget.animationStep,
                duration: widget.duration,
                curve: Curves.bounceIn,
              ),
            ),
          ],
        ),
      );
    }
  }
}
