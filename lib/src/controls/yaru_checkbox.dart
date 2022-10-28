import 'package:flutter/material.dart';

const _kActivableAreaPadding = EdgeInsets.all(5);
const _kCheckboxSize = Size.square(22);
const _kCheckboxBorderRadius = Radius.circular(4);
const _kCheckboxDashStroke = 2.0;
const _kCheckboxActiveResizeFactor = 2; // Need to be an even number

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

  bool get _interactive => widget.onChanged != null;

  late CurvedAnimation _indicatorPosition;
  late AnimationController _indicatorController;

  late CurvedAnimation _sizePosition;
  late AnimationController _sizeController;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _handleTap),
  };

  @override
  void initState() {
    super.initState();

    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _indicatorPosition = CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.easeOut,
    );

    _sizeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _sizePosition = CurvedAnimation(
      parent: _sizeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _indicatorController.dispose();
    _sizeController.dispose();
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
                indicatorPosition: _indicatorPosition,
                sizePosition: _sizePosition,
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
    required this.indicatorPosition,
    required this.sizePosition,
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

  final CurvedAnimation indicatorPosition;
  final CurvedAnimation sizePosition;

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
    final origin = active
        ? Offset(
            _kCheckboxActiveResizeFactor / 2 * sizePosition.value,
            _kCheckboxActiveResizeFactor / 2 * sizePosition.value,
          )
        : Offset.zero;

    final size = active
        ? Size(
            canvasSize.width -
                _kCheckboxActiveResizeFactor * sizePosition.value,
            canvasSize.height -
                _kCheckboxActiveResizeFactor * sizePosition.value,
          )
        : canvasSize;

    _drawStateIndicator(canvas, canvasSize);
    _drawBox(canvas, size, origin);

    if (value == true) {
      _drawCheckMark(canvas, size, origin);
    } else if (value == null) {
      _drawDash(canvas, size, origin);
    }
  }

  void _drawStateIndicator(Canvas canvas, Size canvasSize) {
    if (interactive) {
      final color = focus ? focusIndicatorColor : hoverIndicatorColor;

      canvas.drawCircle(
        Offset(canvasSize.width / 2, canvasSize.height / 2),
        20,
        Paint()
          ..color =
              Color.lerp(Colors.transparent, color, indicatorPosition.value)!
          ..style = PaintingStyle.fill,
      );
    }
  }

  void _drawBox(Canvas canvas, Size size, Offset origin) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height),
        _kCheckboxBorderRadius,
      ),
      Paint()
        ..color = interactive
            ? value != false
                ? checkedColor
                : uncheckedColor
            : value != false
                ? checkedDisabledColor
                : uncheckedDisabledColor
        ..style = PaintingStyle.fill,
    );
  }

  void _drawCheckMark(Canvas canvas, Size size, Offset origin) {
    final path = Path();

    final start1 = Offset(size.width * 0.2198, size.height * 0.3973);
    final start2 = Offset(size.width * 0.1598, size.height * 0.4615);
    final mid1 = Offset(size.width * 0.4297, size.height * 0.5684);
    final mid2 = Offset(size.width * 0.4297, size.height * 0.7455);
    final end1 = Offset(size.width * 0.7881, size.height * 0.2545);
    final end2 = Offset(size.width * 0.8402, size.height * 0.3135);

    path.moveTo(origin.dx + start1.dx, origin.dy + start1.dy);
    path.lineTo(origin.dx + mid1.dx, origin.dy + mid1.dy);
    path.lineTo(origin.dx + end1.dx, origin.dy + end1.dy);
    path.lineTo(origin.dx + end2.dx, origin.dy + end2.dy);
    path.lineTo(origin.dx + mid2.dx, origin.dy + mid2.dy);
    path.lineTo(origin.dx + start2.dx, origin.dy + start2.dy);
    path.close();

    canvas.drawPath(
      path,
      _getCheckmarkPaint(true),
    );
  }

  void _drawDash(Canvas canvas, Size size, Offset origin) {
    final start = Offset(size.width * 0.25, size.height * 0.5);
    final end = Offset(size.width * 0.75, size.height * 0.5);

    canvas.drawLine(origin + start, origin + end, _getCheckmarkPaint(false));
  }

  Paint _getCheckmarkPaint(bool fill) {
    return Paint()
      ..color = interactive ? checkmarkColor : checkmarkDisabledColor
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = _kCheckboxDashStroke;
  }

  @override
  bool shouldRepaint(covariant _YaruCheckboxPainter oldDelegate) => true;
}
