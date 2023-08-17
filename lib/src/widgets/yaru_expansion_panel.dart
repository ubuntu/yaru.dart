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
  Widget build(BuildContext context) {
    assert(widget.children.length == widget.headers.length);

    return YaruBorderContainer(
      color: widget.color,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int index = 0; index < widget.children.length; index++)
            Column(
              children: [
                YaruExpandable(
                  expandIcon: widget.expandIcon,
                  expandIconPadding: widget.expandIconPadding,
                  isExpanded: _expandedStore[index],
                  onChange: (_) {
                    setState(() {
                      _expandedStore[index] = !_expandedStore[index];

                      for (var n = 0; n < _expandedStore.length; n++) {
                        if (n != index && _expandedStore[index] == true) {
                          _expandedStore[n] = false;
                        }
                      }
                    });
                  },
                  header: Padding(
                    padding: widget.headerPadding,
                    child: widget.headers[index],
                  ),
                  child: widget.children[index],
                ),
                if (index != widget.children.length - 1 && widget.placeDividers)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: Divider(
                      height: 0.0,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
