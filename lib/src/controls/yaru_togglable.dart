import 'package:flutter/material.dart';

const _kActivableAreaPadding = EdgeInsets.all(6);
const _kTogglableSize = Size.square(20);
const _kTogglableAnimationDuration = Duration(milliseconds: 150);
const _kTogglableSizeAnimationDuration = Duration(milliseconds: 100);
const _kIndicatorAnimationDuration = Duration(milliseconds: 200);
const _kIndicatorRadius = 20.0;

abstract class YaruTogglable<T> extends StatefulWidget {
  const YaruTogglable({
    super.key,
    required this.value,
    this.tristate = false,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  final T value;

  final bool tristate;

  bool? get checked;

  final ValueChanged<T?>? onChanged;

  bool get interactive => onChanged != null;

  final FocusNode? focusNode;

  final bool autofocus;
}

abstract class YaruTogglableState<S extends YaruTogglable> extends State<S>
    with TickerProviderStateMixin {
  bool hover = false;
  bool focus = false;
  bool active = false;
  bool? oldChecked;

  bool get interactive => widget.interactive;

  late CurvedAnimation _position;
  late AnimationController _positionController;

  late CurvedAnimation _sizePosition;
  late AnimationController _sizeController;

  late CurvedAnimation _indicatorPosition;
  late AnimationController _indicatorController;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: handleTap),
  };

  @override
  void initState() {
    super.initState();

    oldChecked = widget.checked;

    _positionController = AnimationController(
      duration: _kTogglableAnimationDuration,
      value: widget.checked == false ? 0.0 : 1.0,
      vsync: this,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.easeInQuad,
      reverseCurve: Curves.easeOutQuad,
    );

    _sizeController = AnimationController(
      duration: _kTogglableSizeAnimationDuration,
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
  void didUpdateWidget(covariant S oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.checked != widget.checked) {
      oldChecked = oldWidget.checked;

      if (widget.tristate) {
        if (widget.checked == null) {
          _positionController.value = 0.0;
        }
        if (widget.checked ?? true) {
          _positionController.forward();
        } else {
          _positionController.reverse();
        }
      } else {
        if (widget.checked ?? false) {
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

  void _handleFocusChange(bool value) {
    if (focus == value) {
      return;
    }

    setState(() => focus = value);

    if (focus) {
      _indicatorController.forward();
    } else {
      _indicatorController.reverse();
    }
  }

  void _handleHoverChange(bool value) {
    if (hover == value) {
      return;
    }

    setState(() => hover = value);

    if (hover) {
      _indicatorController.forward();
    } else {
      _indicatorController.reverse();
    }
  }

  void _handleActiveChange(bool value) {
    if (active == value) {
      return;
    }

    setState(() => active = value);

    if (active) {
      _sizeController.forward();
    } else {
      _sizeController.reverse();
    }
  }

  void handleTap([Intent? _]);

  Widget _buildSemantics({required Widget child}) {
    return Semantics(
      checked: widget.checked ?? false,
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
      onShowFocusHighlight: _handleFocusChange,
      onShowHoverHighlight: _handleHoverChange,
      mouseCursor:
          interactive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        excludeFromSemantics: !interactive,
        onTapDown: (_) => _handleActiveChange(interactive),
        onTap: handleTap,
        onTapUp: (_) => _handleActiveChange(false),
        onTapCancel: () => _handleActiveChange(false),
        child: AbsorbPointer(
          child: child,
        ),
      ),
    );
  }

  Widget buildToggleable(YaruTogglablePainter painter) {
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
            size: _kTogglableSize,
            painter: painter
              ..interactive = interactive
              ..hover = hover
              ..focus = focus
              ..active = active
              ..checked = widget.checked
              ..oldChecked = oldChecked
              ..position = _position
              ..sizePosition = _sizePosition
              ..indicatorPosition = _indicatorPosition
              ..uncheckedColor = uncheckedColor
              ..checkedColor = checkedColor
              ..checkmarkColor = checkmarkColor
              ..uncheckedDisabledColor = uncheckedDisabledColor
              ..checkedDisabledColor = checkedDisabledColor
              ..checkmarkDisabledColor = checkmarkDisabledColor
              ..hoverIndicatorColor = hoverIndicatorColor
              ..focusIndicatorColor = focusIndicatorColor,
          ),
        ),
      ),
    );
  }
}

abstract class YaruTogglablePainter extends ChangeNotifier
    implements CustomPainter {
  late bool interactive;
  late bool hover;
  late bool focus;
  late bool active;
  late bool? checked;
  late bool? oldChecked;

  late Color uncheckedColor;
  late Color checkedColor;
  late Color checkmarkColor;
  late Color uncheckedDisabledColor;
  late Color checkedDisabledColor;
  late Color checkmarkDisabledColor;
  late Color hoverIndicatorColor;
  late Color focusIndicatorColor;

  Animation<double> get position => _position!;
  Animation<double>? _position;
  set position(Animation<double> value) {
    if (value == _position) {
      return;
    }
    _position?.removeListener(notifyListeners);
    value.addListener(notifyListeners);
    _position = value;
    notifyListeners();
  }

  Animation<double> get sizePosition => _sizePosition!;
  Animation<double>? _sizePosition;
  set sizePosition(Animation<double> value) {
    if (value == _sizePosition) {
      return;
    }
    _sizePosition?.removeListener(notifyListeners);
    value.addListener(notifyListeners);
    _sizePosition = value;
    notifyListeners();
  }

  Animation<double> get indicatorPosition => _indicatorPosition!;
  Animation<double>? _indicatorPosition;
  set indicatorPosition(Animation<double> value) {
    if (value == _indicatorPosition) {
      return;
    }
    _indicatorPosition?.removeListener(notifyListeners);
    value.addListener(notifyListeners);
    _indicatorPosition = value;
    notifyListeners();
  }

  void drawStateIndicator(Canvas canvas, Size canvasSize) {
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
