import 'package:flutter/material.dart';

import 'package:yaru/constants.dart';
import 'package:yaru/widgets.dart';

class YaruExpansionPanel extends StatefulWidget {
  /// Takes two lists of [children] and [headers]
  /// and wraps them inside a [ListView] of [YaruExpandable]s
  /// surrounded by a [YaruBorderContainer]
  const YaruExpansionPanel({
    super.key,
    required this.children,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(kYaruContainerRadius)),
    this.border,
    required this.headers,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.expandIconPadding = const EdgeInsets.all(10),
    this.headerPadding = const EdgeInsets.only(left: 20),
    this.color,
    this.placeDividers = true,
    this.expandIcon,
    this.shrinkWrap = false,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.collapseOnExpand = true,
  }) : assert(headers.length == children.length);

  /// A list of [Widget]s
  /// where each child is put it in a [YaruExpandable] as its child.
  /// The length mus be equal to the length of the [headers]

  final List<Widget> children;

  /// A list of [Widget]s
  /// where each element is put it a [YaruExpandable] as its header.
  /// The length mus be equal to the length of the [children]
  final List<Widget> headers;

  /// The [BorderRadius] forwarded to [YaruBorderContainer]
  final BorderRadius borderRadius;

  /// The [BoxBorder] forwarded to [YaruBorderContainer]
  final BoxBorder? border;

  /// The width, which is forwarded to [YaruBorderContainer]
  final double? width;

  /// The height, forwarded to [YaruBorderContainer]
  final double? height;

  /// [EdgeInsetsGeometry] forwarded as the padding to [YaruBorderContainer]
  final EdgeInsetsGeometry? padding;

  /// [EdgeInsetsGeometry] forwarded as the margin to [YaruBorderContainer]
  final EdgeInsetsGeometry? margin;

  /// [EdgeInsetsGeometry] forwarded to each header
  final EdgeInsetsGeometry expandIconPadding;

  /// [EdgeInsetsGeometry] forwarded to each header
  final EdgeInsetsGeometry headerPadding;

  /// The [Color] forwarded to [YaruBorderContainer]
  final Color? color;

  /// Defines if a [Divider] follows each [YaruExpandable]
  /// in the [ListView]
  final bool placeDividers;

  /// The [Widget] used as the icon to expand a [YaruExpandable]
  final Widget? expandIcon;

  /// Forwarded to the internal [ListView]
  final bool shrinkWrap;

  /// Forwarded to the internal [ListView]
  final ScrollPhysics scrollPhysics;

  /// Defines if all other [YaruExpandable]s should collapse
  /// if one expands.
  final bool collapseOnExpand;

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
      border: widget.border,
      borderRadius: widget.borderRadius,
      color: widget.color,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      child: widget.placeDividers
          ? ListView.separated(
              shrinkWrap: widget.shrinkWrap,
              physics: widget.scrollPhysics,
              itemCount: widget.children.length,
              itemBuilder: _itemBuilder,
              separatorBuilder: (context, index) {
                if (index != widget.children.length - 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: Divider(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          : ListView.builder(
              shrinkWrap: widget.shrinkWrap,
              physics: widget.scrollPhysics,
              itemCount: widget.children.length,
              itemBuilder: _itemBuilder,
            ),
    );
  }

  Widget? _itemBuilder(context, index) {
    return YaruExpandable(
      expandIcon: widget.expandIcon,
      expandIconPadding: widget.expandIconPadding,
      isExpanded: _expandedStore[index],
      onChange: widget.collapseOnExpand
          ? (_) {
              _expandedStore[index] = !_expandedStore[index];
              for (var n = 0; n < _expandedStore.length; n++) {
                if (n != index && _expandedStore[index]) {
                  setState(() => _expandedStore[n] = false);
                }
              }
            }
          : null,
      header: Padding(
        padding: widget.headerPadding,
        child: widget.headers[index],
      ),
      child: widget.children[index],
    );
  }
}
