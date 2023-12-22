import 'package:flutter/material.dart';

import 'package:yaru_widgets/constants.dart';
import 'package:yaru_widgets/widgets.dart';

class YaruExpansionPanel extends StatefulWidget {
  const YaruExpansionPanel({
    super.key,
    required this.children,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(kYaruContainerRadius)),
    required this.headers,
    this.width,
    this.height,
    this.padding,
    this.expandIconPadding = const EdgeInsets.all(10),
    this.headerPadding = const EdgeInsets.only(left: 20),
    this.color,
    this.placeDividers = true,
    this.expandIcon,
    this.scrollable = true,
    this.shrinkWrap = true,
  });

  final List<Widget> children;
  final List<Widget> headers;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry expandIconPadding;
  final EdgeInsetsGeometry headerPadding;
  final Color? color;
  final bool placeDividers;
  final Widget? expandIcon;
  final bool scrollable;
  final bool shrinkWrap;

  @override
  State<YaruExpansionPanel> createState() => _YaruExpansionPanelState();
}

class _YaruExpansionPanelState extends State<YaruExpansionPanel> {
  late List<bool> _expandedStore;

  @override
  void initState() {
    super.initState();
    _expandedStore =
        List<bool>.generate(widget.children.length, (index) => false);
  }

  @override
  void didUpdateWidget(covariant YaruExpansionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _expandedStore =
          List<bool>.generate(widget.children.length, (index) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.children.length == widget.headers.length);

    return YaruBorderContainer(
      color: widget.color,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        physics:
            widget.scrollable ? null : const NeverScrollableScrollPhysics(),
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return _Expandable(
            expandIcon: widget.expandIcon,
            expandIconPadding: widget.expandIconPadding,
            isExpanded: _expandedStore[index],
            onChange: (_) {
              setState(() {
                _expandedStore[index] = !_expandedStore[index];
              });
              for (var n = 0; n < _expandedStore.length; n++) {
                if (n != index && _expandedStore[index] == true) {
                  setState(() {
                    _expandedStore[n] = false;
                  });
                }
              }
            },
            header: Padding(
              padding: widget.headerPadding,
              child: widget.headers[index],
            ),
            placeDivider:
                index != widget.children.length - 1 && widget.placeDividers,
            child: widget.children[index],
          );
        },
      ),
    );
  }
}

class _Expandable extends StatelessWidget {
  const _Expandable({
    required this.expandIcon,
    required this.expandIconPadding,
    required this.isExpanded,
    required this.onChange,
    required this.header,
    required this.child,
    required this.placeDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YaruExpandable(
          expandIcon: expandIcon,
          expandIconPadding: expandIconPadding,
          isExpanded: isExpanded,
          onChange: onChange,
          header: header,
          child: child,
        ),
        if (placeDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 1),
            child: Divider(),
          ),
      ],
    );
  }

  final Widget? expandIcon;
  final EdgeInsetsGeometry expandIconPadding;
  final bool isExpanded;
  final void Function(bool)? onChange;
  final Widget header;
  final Widget child;
  final bool placeDivider;
}
