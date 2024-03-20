import 'package:flutter/material.dart';

class YaruEdgeFocusInterceptor extends StatefulWidget {
  const YaruEdgeFocusInterceptor({
    super.key,
    required this.child,
    required this.onFocusFromPreviousNode,
    required this.onFocusFromNextNode,
  });

  final Widget child;

  final void Function() onFocusFromPreviousNode;

  final void Function() onFocusFromNextNode;

  @override
  State<YaruEdgeFocusInterceptor> createState() =>
      _YaruEdgeFocusInterceptorState();
}

class _YaruEdgeFocusInterceptorState extends State<YaruEdgeFocusInterceptor> {
  late final FocusNode _outerFocusNode;
  late final FocusNode _previousFocusNode;
  late final FocusNode _nextFocusNode;

  @override
  void initState() {
    super.initState();

    _outerFocusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
    _previousFocusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
    _nextFocusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _outerFocusNode.dispose();
    _previousFocusNode.dispose();
    _nextFocusNode.dispose();

    super.dispose();
  }

  Widget _buildEdgeFocusWidget({
    required bool previous,
    required void Function() callback,
  }) {
    return Focus(
      focusNode: previous ? _previousFocusNode : _nextFocusNode,
      canRequestFocus: !_outerFocusNode.hasFocus,
      onFocusChange: (focus) {
        if (!focus) return;

        callback();

        if (previous) {
          _previousFocusNode.nextFocus();
        } else {
          _nextFocusNode.previousFocus();
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _outerFocusNode,
      canRequestFocus: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEdgeFocusWidget(
            previous: true,
            callback: widget.onFocusFromPreviousNode,
          ),
          widget.child,
          _buildEdgeFocusWidget(
            previous: false,
            callback: widget.onFocusFromNextNode,
          ),
        ],
      ),
    );
  }
}
