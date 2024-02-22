import 'package:flutter/material.dart';

const _kAnimationDuration = Duration(milliseconds: 150);
const _kUndershotSize = 3.0;

enum _UndershootPosition {
  start,
  end;

  bool get isStart => this == _UndershootPosition.start;
  bool get isEnd => this == _UndershootPosition.end;
}

extension _AxisExtension on Axis {
  bool get isVertical => this == Axis.vertical;
  bool get isHorizontal => this == Axis.horizontal;
}

/// A widget that displays an undershoot at the start and/or end of a scroll view,
/// when the scroll offset is not at the very beginning or end.
///
/// See also:
///  * [YaruScrollViewUndershoot.builder], if you dont't want to create a [ScrollController] yourself.
class YaruScrollViewUndershoot extends StatefulWidget {
  /// Create a widget that displays an undershoot at the start and/or end of a scroll view,
  /// when the scroll offset is not at the very beginning or end.
  ///
  /// Use [YaruScrollViewUndershoot.builder] if you don't want to manage the scroll controller by yourself.
  const YaruScrollViewUndershoot({
    super.key,
    required ScrollController this.controller,
    this.scrollDirection = Axis.vertical,
    this.startUndershoot = true,
    this.endUndershoot = true,
    required Widget this.child,
  }) : builder = null;

  // Create a widget that displays an undershoot at the start and/or end of a scroll view,
  /// when the scroll offset is not at the very beginning or end.
  ///
  /// Use [YaruScrollViewUndershoot] if you want to manage the scroll controller by yourself.
  const YaruScrollViewUndershoot.builder({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.startUndershoot = true,
    this.endUndershoot = true,
    required this.builder,
  })  : controller = null,
        child = null;

  /// Controller that manage the related scroll view.
  final ScrollController? controller;

  /// Scroll direction of the related scroll view.
  final Axis scrollDirection;

  /// If true, this widget will show an undershoot
  /// when the scroll offset is not at the very beginning.
  final bool startUndershoot;

  /// If true, this widget will show an undershoot
  /// when the scroll offset is not at the very end.
  final bool endUndershoot;

  /// The child of this widget.
  /// Should be the scroll view, managed by the [controller].
  final Widget? child;

  /// The child of this widget.
  /// It passes a controller that needs to manage the related scroll view.
  final Widget Function(BuildContext, ScrollController)? builder;

  @override
  State<YaruScrollViewUndershoot> createState() =>
      _YaruScrollViewUndershootState();
}

class _YaruScrollViewUndershootState extends State<YaruScrollViewUndershoot> {
  late ScrollController _controller;

  var _hasReachedStart = true;
  var _hasReachedEnd = true;

  @override
  void initState() {
    super.initState();

    _controller =
        widget.controller != null ? widget.controller! : ScrollController();

    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _onScroll(),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _controller.offset;
    final minScrollExtent = _controller.position.minScrollExtent;
    final maxScrollExtent = _controller.position.maxScrollExtent;

    final hasReachedEnd = offset >= maxScrollExtent;
    final hasReachedStart = offset <= minScrollExtent;

    if (_hasReachedStart != hasReachedStart) {
      setState(() {
        _hasReachedStart = hasReachedStart;
      });
    }
    if (_hasReachedEnd != hasReachedEnd) {
      setState(() {
        _hasReachedEnd = hasReachedEnd;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    return Stack(
      children: [
        widget.builder != null
            ? widget.builder!.call(context, _controller)
            : widget.child!,
        if (widget.startUndershoot)
          _buildUndershoot(
            position: _UndershootPosition.start,
            light: light,
          ),
        if (widget.endUndershoot)
          _buildUndershoot(
            position: _UndershootPosition.end,
            light: light,
          ),
      ],
    );
  }

  Widget _buildUndershoot({
    required _UndershootPosition position,
    required bool light,
  }) {
    final top = widget.scrollDirection.isHorizontal || position.isStart;
    final bottom = widget.scrollDirection.isHorizontal || position.isEnd;
    final left = widget.scrollDirection.isVertical || position.isStart;
    final right = widget.scrollDirection.isVertical || position.isEnd;
    final visible = position.isStart ? !_hasReachedStart : !_hasReachedEnd;
    final alignment = () {
      if (widget.scrollDirection.isHorizontal) {
        if (position.isStart) {
          return Alignment.centerLeft;
        }
        return Alignment.centerRight;
      }

      if (position.isStart) {
        return Alignment.topCenter;
      }
      return Alignment.bottomCenter;
    }();

    return Positioned(
      top: top ? 0 : null,
      bottom: bottom ? 0 : null,
      left: left ? 0 : null,
      right: right ? 0 : null,
      child: AnimatedOpacity(
        duration: _kAnimationDuration,
        opacity: visible ? 1 : 0,
        child: Container(
          height: widget.scrollDirection.isVertical ? _kUndershotSize : null,
          width: widget.scrollDirection.isHorizontal ? _kUndershotSize : null,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: alignment,
              end: -alignment,
              colors: [
                Colors.black.withOpacity(light ? 0.1 : 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
