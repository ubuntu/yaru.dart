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

class _YaruCheckboxState extends State<YaruCheckbox> {
  bool _hover = false;
  bool _focus = false;
  bool _active = false;

  bool get interactive => widget.onChanged != null;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _handleTap),
  };

  void _handleTap([Intent? _]) {
    if (!interactive) {
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
          child: CustomPaint(
            size: _kCheckboxSize,
            painter: _YaruCheckboxPainter(
              interactive: interactive,
              hover: _hover,
              focus: _focus,
              active: _active,
              value: widget.value,
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
    );
  }

  Widget _buildSemantics({required Widget child}) {
    return Semantics(
      checked: widget.value ?? false,
      enabled: interactive,
      child: child,
    );
  }

  Widget _buildEventDetectors({required Widget child}) {
    return FocusableActionDetector(
      actions: _actionMap,
      enabled: interactive,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onShowFocusHighlight: (focus) => setState(() => _focus = focus),
      onShowHoverHighlight: (hover) => setState(() => _hover = hover),
      mouseCursor:
          interactive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        excludeFromSemantics: !interactive,
        onTapDown: (_) => setState(() => _active = interactive),
        onTap: _handleTap,
        onTapUp: (_) => setState(() => _active = false),
        onTapCancel: () => setState(() => _active = false),
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
        ? const Offset(
            _kCheckboxActiveResizeFactor / 2,
            _kCheckboxActiveResizeFactor / 2,
          )
        : Offset.zero;

    final size = active
        ? Size(
            canvasSize.width - _kCheckboxActiveResizeFactor,
            canvasSize.height - _kCheckboxActiveResizeFactor,
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
    if (hover || focus) {
      canvas.drawCircle(
        Offset(canvasSize.width / 2, canvasSize.height / 2),
        20,
        Paint()
          ..color = focus ? focusIndicatorColor : hoverIndicatorColor
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
