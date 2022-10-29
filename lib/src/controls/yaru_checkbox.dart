import 'package:flutter/material.dart';

const _kActivableAreaPadding = EdgeInsets.all(5);
const _kCheckboxSize = Size.square(22);
const _kCheckboxBorderRadius = Radius.circular(4);
const _kCheckboxDashStroke = 2.0;
const _kDashSizeFactor = 0.52;
const _kCheckboxActiveResizeFactor = 2; // Need to be an even number
const _kCheckboxAnimationDuration = Duration(milliseconds: 150);
const _kCheckboxSizeAnimationDuration = Duration(milliseconds: 100);
const _kIndicatorAnimationDuration = Duration(milliseconds: 200);
const _kIndicatorRadius = 20.0;

class YaruCheckbox extends StatefulWidget {
  const YaruCheckbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
  }) : assert(tristate || value != null);

  final bool? value;

  final bool tristate;

  final ValueChanged<bool?>? onChanged;

  final FocusNode? focusNode;

  final bool autofocus;

  @override
  State<YaruCheckbox> createState() {
    return _YaruCheckboxState();
  }
}

class _YaruCheckboxState extends State<YaruCheckbox>
    with TickerProviderStateMixin {
  bool _hover = false;
  bool _focus = false;
  bool _active = false;
  bool? _oldValue;

  bool get _interactive => widget.onChanged != null;

  late CurvedAnimation _position;
  late AnimationController _positionController;

  late CurvedAnimation _sizePosition;
  late AnimationController _sizeController;

  late CurvedAnimation _indicatorPosition;
  late AnimationController _indicatorController;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _handleTap),
  };

  @override
  void initState() {
    super.initState();

    _oldValue = widget.value;

    _positionController = AnimationController(
      duration: _kCheckboxAnimationDuration,
      value: widget.value == false ? 0.0 : 1.0,
      vsync: this,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.easeInQuad,
      reverseCurve: Curves.easeOutQuad,
    );

    _sizeController = AnimationController(
      duration: _kCheckboxSizeAnimationDuration,
      vsync: this,
    );
    _sizePosition = CurvedAnimation(
      parent: _sizeController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    _indicatorController = AnimationController(
      duration: _kIndicatorAnimationDuration,
      vsync: this,
    );
    _indicatorPosition = CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didUpdateWidget(covariant YaruCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;

      if (widget.tristate) {
        if (widget.value == null) {
          _positionController.value = 0.0;
        }
        if (widget.value ?? true) {
          _positionController.forward();
        } else {
          _positionController.reverse();
        }
      } else {
        if (widget.value ?? false) {
          _positionController.forward();
        } else {
          _positionController.reverse();
        }
      }

      _sizeController.forward().then((_) {
        _sizeController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _indicatorController.dispose();
    _sizeController.dispose();

    super.dispose();
  }

  void _handleFocusChange(bool focus) {
    if (focus == _focus) {
      return;
    }

    setState(() => _focus = focus);

    if (_focus) {
      _indicatorController.forward();
    } else {
      _indicatorController.reverse();
    }
  }

  void _handleHoverChange(bool hover) {
    if (hover == _hover) {
      return;
    }

    setState(() => _hover = hover);

    if (_hover) {
      _indicatorController.forward();
    } else {
      _indicatorController.reverse();
    }
  }

  void _handleActiveChange(bool active) {
    if (active == _active) {
      return;
    }

    setState(() => _active = active);

    if (_active) {
      _sizeController.forward();
    } else {
      _sizeController.reverse();
    }
  }

  void _handleTap([Intent? _]) {
    if (!_interactive) {
      return;
    }
    switch (widget.value) {
      case false:
        widget.onChanged!(true);
        break;
      case true:
        widget.onChanged!(widget.tristate ? null : false);
        break;
      case null:
        widget.onChanged!(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Normal colors
    final uncheckedColor = colorScheme.onSurface.withOpacity(.3);
    final checkedColor = colorScheme.primary;
    final checkmarkColor = colorScheme.onPrimary;

    // Disabled colors
    final uncheckedDisabledColor = colorScheme.onSurface.withOpacity(.1);
    final checkedDisabledColor = colorScheme.onSurface.withOpacity(.2);
    final checkmarkDisabledColor = colorScheme.onSurface.withOpacity(.5);

    // Indicator colors
    final hoverIndicatorColor = colorScheme.onSurface.withOpacity(.05);
    final focusIndicatorColor = colorScheme.onSurface.withOpacity(.1);

    return _buildSemantics(
      child: _buildEventDetectors(
        child: Padding(
          padding: _kActivableAreaPadding,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _indicatorController,
              _sizeController,
            ]),
            builder: (context, child) => CustomPaint(
              size: _kCheckboxSize,
              painter: _YaruCheckboxPainter(
                interactive: _interactive,
                hover: _hover,
                focus: _focus,
                active: _active,
                value: widget.value,
                oldValue: _oldValue,
                position: _position,
                sizePosition: _sizePosition,
                indicatorPosition: _indicatorPosition,
                uncheckedColor: uncheckedColor,
                checkedColor: checkedColor,
                checkmarkColor: checkmarkColor,
                uncheckedDisabledColor: uncheckedDisabledColor,
                checkedDisabledColor: checkedDisabledColor,
                checkmarkDisabledColor: checkmarkDisabledColor,
                hoverIndicatorColor: hoverIndicatorColor,
                focusIndicatorColor: focusIndicatorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSemantics({required Widget child}) {
    return Semantics(
      checked: widget.value ?? false,
      enabled: _interactive,
      child: child,
    );
  }

  Widget _buildEventDetectors({required Widget child}) {
    return FocusableActionDetector(
      actions: _actionMap,
      enabled: _interactive,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onShowFocusHighlight: _handleFocusChange,
      onShowHoverHighlight: _handleHoverChange,
      mouseCursor:
          _interactive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        excludeFromSemantics: !_interactive,
        onTapDown: (_) => _handleActiveChange(_interactive),
        onTap: _handleTap,
        onTapUp: (_) => _handleActiveChange(false),
        onTapCancel: () => _handleActiveChange(false),
        child: AbsorbPointer(
          child: child,
        ),
      ),
    );
  }
}

class _YaruCheckboxPainter extends CustomPainter {
  _YaruCheckboxPainter({
    required this.interactive,
    required this.hover,
    required this.focus,
    required this.active,
    required this.value,
    required this.oldValue,
    required this.position,
    required this.sizePosition,
    required this.indicatorPosition,
    required this.uncheckedColor,
    required this.checkedColor,
    required this.checkmarkColor,
    required this.uncheckedDisabledColor,
    required this.checkedDisabledColor,
    required this.checkmarkDisabledColor,
    required this.hoverIndicatorColor,
    required this.focusIndicatorColor,
  });

  final bool interactive;
  final bool hover;
  final bool focus;
  final bool active;
  final bool? value;
  final bool? oldValue;

  final CurvedAnimation position;
  final CurvedAnimation sizePosition;
  final CurvedAnimation indicatorPosition;

  final Color uncheckedColor;
  final Color checkedColor;
  final Color checkmarkColor;
  final Color uncheckedDisabledColor;
  final Color checkedDisabledColor;
  final Color checkmarkDisabledColor;
  final Color hoverIndicatorColor;
  final Color focusIndicatorColor;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final t = position.value;
    final drawingOrigin = Offset(
      _kCheckboxActiveResizeFactor / 2 * sizePosition.value,
      _kCheckboxActiveResizeFactor / 2 * sizePosition.value,
    );
    final drawingSize = Size(
      canvasSize.width - _kCheckboxActiveResizeFactor * sizePosition.value,
      canvasSize.height - _kCheckboxActiveResizeFactor * sizePosition.value,
    );

    _drawStateIndicator(canvas, canvasSize);
    _drawBox(
      canvas,
      drawingSize,
      drawingOrigin,
      oldValue == false || value == false ? t : 1,
    );

    // Four cases: false to null, false to true, null to false, true to false
    if (oldValue == false || value == false) {
      if (oldValue == true || value == true) {
        _drawCheckMark(canvas, drawingSize, drawingOrigin, t);
      } else if (oldValue == null || value == null) {
        _drawDash(canvas, drawingSize, drawingOrigin, t);
      }
    }
    // Two cases: null to true, true to null
    else {
      if (t <= 0.5) {
        final tShrink = 1 - t * 2;
        if (oldValue == true) {
          _drawCheckMark(canvas, drawingSize, drawingOrigin, tShrink);
        } else {
          _drawDash(canvas, drawingSize, drawingOrigin, tShrink);
        }
      } else {
        final tExpand = (t - 0.5) * 2.0;
        if (value == true) {
          _drawCheckMark(canvas, drawingSize, drawingOrigin, tExpand);
        } else {
          _drawDash(canvas, drawingSize, drawingOrigin, tExpand);
        }
      }
    }
  }

  void _drawStateIndicator(Canvas canvas, Size canvasSize) {
    if (interactive) {
      final color = focus ? focusIndicatorColor : hoverIndicatorColor;

      canvas.drawCircle(
        Offset(canvasSize.width / 2, canvasSize.height / 2),
        _kIndicatorRadius,
        Paint()
          ..color =
              Color.lerp(Colors.transparent, color, indicatorPosition.value)!
          ..style = PaintingStyle.fill,
      );
    }
  }

  void _drawBox(Canvas canvas, Size size, Offset origin, double t) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height),
        _kCheckboxBorderRadius,
      ),
      Paint()
        ..color = interactive
            ? Color.lerp(uncheckedColor, checkedColor, t)!
            : Color.lerp(uncheckedDisabledColor, checkedDisabledColor, t)!
        ..style = PaintingStyle.fill,
    );
  }

  void _drawCheckMark(Canvas canvas, Size size, Offset origin, double t) {
    final path = Path();

    final start = Offset(size.width * 0.1818, size.height * 0.4545);
    final mid = Offset(size.width * 0.4091, size.height * 0.6818);
    final end = Offset(size.width * 0.8128, size.height * 0.2781);

    if (t < 0.5) {
      final strokeT = t * 2.0;
      final drawMid = Offset.lerp(start, mid, strokeT)!;

      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
      path.lineTo(origin.dx + start.dx, origin.dy + start.dy);
    } else {
      final strokeT = (t - 0.5) * 2.0;
      final drawEnd = Offset.lerp(mid, end, strokeT)!;

      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }

    canvas.drawPath(
      path,
      _getCheckmarkPaint(),
    );
  }

  void _drawDash(Canvas canvas, Size size, Offset origin, double t) {
    const dashMarginFactor = (1 - _kDashSizeFactor) / 2;

    final start = Offset(size.width * dashMarginFactor, size.height * 0.5);
    final mid = Offset(size.width * 0.5, size.height * 0.5);
    final end = Offset(size.width * (1 - dashMarginFactor), size.height * 0.5);

    final drawStart = Offset.lerp(start, mid, 1.0 - t)!;
    final drawEnd = Offset.lerp(mid, end, t)!;

    canvas.drawLine(
      origin + drawStart,
      origin + drawEnd,
      _getCheckmarkPaint(),
    );
  }

  Paint _getCheckmarkPaint() {
    return Paint()
      ..color = interactive ? checkmarkColor : checkmarkDisabledColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kCheckboxDashStroke;
  }

  @override
  bool shouldRepaint(covariant _YaruCheckboxPainter oldDelegate) => true;
}
