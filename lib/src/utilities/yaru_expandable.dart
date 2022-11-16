import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import '../../yaru_widgets.dart';

const _kAnimationDuration = Duration(milliseconds: 250);
const _kAnimationCurve = Curves.easeInOutCubic;

class YaruExpandable extends StatefulWidget {
  const YaruExpandable({
    super.key,
    required this.header,
    this.expandIcon,
    required this.child,
    this.collapsedChild,
    this.gapHeight = 4.0,
    this.isExpanded = false,
    this.onChange,
  });

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

  final double gapHeight;

  /// Optional initial value.
  final bool isExpanded;

  /// Callback called on expand or collapse
  final void Function(
    bool isExpanded,
  )? onChange;

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
            Flexible(
              child: GestureDetector(onTap: _onTap, child: widget.header),
            ),
            YaruIconButton(
              iconSize: 36,
              padding: EdgeInsets.zero,
              onPressed: _onTap,
              icon: AnimatedRotation(
                turns: _isExpanded ? .25 : 0,
                duration: _kAnimationDuration,
                curve: _kAnimationCurve,
                child: widget.expandIcon ?? const Icon(YaruIcons.pan_end),
              ),
            ),
          ],
        ),
        AnimatedCrossFade(
          firstChild: _buildChild(widget.child),
          secondChild: widget.collapsedChild != null
              ? _buildChild(widget.collapsedChild!)
              : Container(),
          crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          sizeCurve: _kAnimationCurve,
          duration: _kAnimationDuration,
        )
      ],
    );
  }

  void _onTap() {
    setState(() => _isExpanded = !_isExpanded);

    widget.onChange?.call(_isExpanded);
  }

  Widget _buildChild(Widget child) {
    return Column(
      children: [
        SizedBox(height: widget.gapHeight),
        child,
      ],
    );
  }
}
