import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

const _kAnimationDuration = Duration(milliseconds: 250);
const _kAnimationCurve = Curves.easeInOutCubic;

class YaruExpandable extends StatefulWidget {
  const YaruExpandable({
    Key? key,
    required this.header,
    this.expandIcon,
    required this.child,
    this.collapsedChild,
    this.isExpanded = false,
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

  /// Optional initial value.
  final bool isExpanded;

  @override
  State<YaruExpandable> createState() => _YaruExpandableState();
}

class _YaruExpandableState extends State<YaruExpandable> {
  late bool _isExpanded;

  @override
  void initState() {
    _isExpanded = widget.isExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: widget.header),
            YaruRoundIconButton(
              size: 32,
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: AnimatedRotation(
                turns: _isExpanded ? .25 : 0,
                duration: _kAnimationDuration,
                curve: _kAnimationCurve,
                child: widget.expandIcon ?? const Icon(Icons.arrow_right),
              ),
            ),
          ],
        ),
        AnimatedCrossFade(
            firstChild: widget.child,
            secondChild: widget.collapsedChild ?? Container(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            sizeCurve: _kAnimationCurve,
            duration: _kAnimationDuration)
      ],
    );
  }
}
