import 'package:flutter/material.dart';

const _kAnimationDuration = Duration(milliseconds: 250);
const _kAnimationCurve = Curves.easeInOutCubic;

class YaruExpandable extends StatefulWidget {
  const YaruExpandable({
    Key? key,
    required this.header,
    this.expandIcon,
    required this.child,
    this.collapsedChild,
  }) : super(key: key);

  /// Widget placed in the header, against the expand button
  final Widget header;

  /// Icon used in the expand button
  /// Prefer use a "right arrow" icon
  /// A 25° rotation is used when expanded
  final Widget? expandIcon;

  /// Widget show when expanded
  final Widget child;

  /// Widget show when collapsed
  final Widget? collapsedChild;

  @override
  State<YaruExpandable> createState() => _YaruExpandableState();
}

class _YaruExpandableState extends State<YaruExpandable> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: widget.header),
            IconButton(
                splashRadius: 20,
                onPressed: () => setState(() => isExpanded = !isExpanded),
                icon: AnimatedRotation(
                    turns: isExpanded ? .25 : 0,
                    duration: _kAnimationDuration,
                    curve: _kAnimationCurve,
                    child: widget.expandIcon ?? const Icon(Icons.arrow_right))),
          ],
        ),
        AnimatedCrossFade(
            firstChild: widget.child,
            secondChild: widget.collapsedChild ?? Container(),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            sizeCurve: _kAnimationCurve,
            duration: _kAnimationDuration)
      ],
    );
  }
}
