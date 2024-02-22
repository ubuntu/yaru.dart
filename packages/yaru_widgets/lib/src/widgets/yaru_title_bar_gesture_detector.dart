import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class YaruTitleBarGestureDetector extends StatelessWidget {
  const YaruTitleBarGestureDetector({
    super.key,
    this.onDrag,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.behavior = HitTestBehavior.translucent,
    this.child,
  });

  final GestureDragStartCallback? onDrag;
  final GestureDoubleTapCallback? onDoubleTap;
  final GestureTapCallback? onSecondaryTap;
  final HitTestBehavior? behavior;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final settings = MediaQuery.maybeOf(context)?.gestureSettings;
    return RawGestureDetector(
      behavior: behavior,
      gestures: {
        PanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
          PanGestureRecognizer.new,
          (instance) => instance
            ..onStart = onDrag
            ..gestureSettings = settings,
        ),
        _PassiveTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_PassiveTapGestureRecognizer>(
          _PassiveTapGestureRecognizer.new,
          (instance) => instance
            ..onDoubleTap = onDoubleTap
            ..onSecondaryTap = onSecondaryTap
            ..gestureSettings = settings,
        ),
      },
      child: child,
    );
  }
}

class _PassiveTapGestureRecognizer extends TapGestureRecognizer {
  _PassiveTapGestureRecognizer() {
    onTapUp = (_) {};
    onTapCancel = () {};
  }

  GestureDoubleTapCallback? onDoubleTap;

  PointerDownEvent? _firstTapDown;
  PointerUpEvent? _firstTapUp;

  @protected
  @override
  void handleTapUp({
    required PointerDownEvent down,
    required PointerUpEvent up,
  }) {
    super.handleTapUp(down: down, up: up);
    if (onDoubleTap != null &&
        _firstTapDown != null &&
        _firstTapUp != null &&
        down.buttons == kPrimaryButton) {
      // the time from the first tap down to the second tap down
      final interval = down.timeStamp - _firstTapDown!.timeStamp;
      // the time from the first tap up to the second tap down
      final timeBetween = down.timeStamp - _firstTapUp!.timeStamp;
      // the distance between the first tap down and the first tap up
      final slop = (_firstTapDown!.position - _firstTapUp!.position).distance;
      // the distance between the first tap down and the second tap down
      final secondSlop = (_firstTapDown!.position - down.position).distance;
      if (interval < kDoubleTapTimeout &&
          timeBetween >= kDoubleTapMinTime &&
          slop <= kDoubleTapTouchSlop &&
          secondSlop <= kDoubleTapSlop) {
        invokeCallback<void>('onDoubleTap', onDoubleTap!);
        _firstTapDown = null;
        _firstTapUp = null;
        return;
      }
    }
    _firstTapDown = down;
    _firstTapUp = up;
  }

  @protected
  @override
  void handleTapCancel({
    required PointerDownEvent down,
    PointerCancelEvent? cancel,
    required String reason,
  }) {
    super.handleTapCancel(down: down, cancel: cancel, reason: reason);
    _firstTapDown = null;
    _firstTapUp = null;
  }
}
