import 'package:flutter/material.dart';

import 'yaru_checkbox.dart';
import 'yaru_radio.dart';
import 'yaru_switch.dart';

const _kTogglableAnimationDuration = Duration(milliseconds: 150);
const _kTogglableSizeAnimationDuration = Duration(milliseconds: 100);
const _kIndicatorAnimationDuration = Duration(milliseconds: 200);
const _kIndicatorRadius = 20.0;
// Used to resize the canvas on active state. Must be an even number.
const _kTogglableActiveResizeFactor = 2;

/// A generic class to create a togglable widget
///
/// See also:
///
/// * [YaruCheckbox] and [YaruSwitch], for toggling a particular value on or off.
/// * [YaruRadio], for selecting among a set of explicit values.
abstract class YaruTogglable<T> extends StatefulWidget {
  const YaruTogglable({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  /// Value of this [YaruTogglable].
  final T value;

  /// By default, a [YaruTogglable] widget can only handle two state.
  /// If true, it will be able to display tree values.
  final bool tristate;

  /// Getter used to link [T] to a [bool] value.
  /// If true, the [YaruTogglable] will be considered as checked.
  bool? get checked;

  /// The [YaruTogglable] itself does not maintain any state. Instead, when the state of
  /// the [YaruTogglable] changes, the widget calls the [onChanged] callback.
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt.
  final ValueChanged<T>? onChanged;

  /// Determine if this [YaruTogglable] can handle events.
  bool get interactive;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;
}

abstract class YaruTogglableState<S extends YaruTogglable> extends State<S>
    with TickerProviderStateMixin {
  bool _hover = false;
  bool _focus = false;
  bool _active = false;
  bool? _oldChecked;

  late CurvedAnimation _position;
  late AnimationController _positionController;

  late CurvedAnimation _sizePosition;
  late AnimationController _sizeController;

  late CurvedAnimation _indicatorPosition;
  late AnimationController _indicatorController;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: handleTap),
  };

  EdgeInsetsGeometry get activableAreaPadding;
  Size get togglableSize;

  @override
  void initState() {
    super.initState();

    _oldChecked = widget.checked;

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
      _oldChecked = oldWidget.checked;

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
    if (_focus == value) {
      return;
    }

    setState(() => _focus = value);

    if (_focus) {
      _indicatorController.forward();
    } else {
      _indicatorController.reverse();
    }
  }

  void _handleHoverChange(bool value) {
    if (_hover == value) {
      return;
    }

    setState(() => _hover = value);

    if (_hover) {
      _indicatorController.forward();
    } else {
      _indicatorController.reverse();
    }
  }

  void _handleActiveChange(bool value) {
    if (_active == value) {
      return;
    }

    setState(() => _active = value);

    if (_active) {
      _sizeController.forward();
    } else {
      _sizeController.reverse();
    }
  }

  void handleTap([Intent? _]);

  Widget _buildSemantics({required Widget child}) {
    return Semantics(
      checked: widget.checked ?? false,
      enabled: widget.interactive,
      child: child,
    );
  }

  Widget _buildEventDetectors({required Widget child}) {
    return FocusableActionDetector(
      actions: _actionMap,
      enabled: widget.interactive,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onShowFocusHighlight: _handleFocusChange,
      onShowHoverHighlight: _handleHoverChange,
      mouseCursor: widget.interactive
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        excludeFromSemantics: !widget.interactive,
        onTapDown: (_) => _handleActiveChange(widget.interactive),
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
    final uncheckedColor = colorScheme.surface;
    final uncheckedBorderColor = colorScheme.onSurface.withOpacity(.3);
    final checkedColor = colorScheme.primary;
    final checkmarkColor = colorScheme.onPrimary;

    // Disabled colors
    final uncheckedDisabledColor = colorScheme.onSurface.withOpacity(.1);
    final uncheckedDisabledBorderColor = colorScheme.onSurface.withOpacity(.1);
    final checkedDisabledColor = colorScheme.onSurface.withOpacity(.2);
    final checkmarkDisabledColor = colorScheme.onSurface.withOpacity(.5);

    // Indicator colors
    final hoverIndicatorColor = colorScheme.onSurface.withOpacity(.05);
    final focusIndicatorColor = colorScheme.onSurface.withOpacity(.1);

    return _buildSemantics(
      child: _buildEventDetectors(
        child: Padding(
          padding: activableAreaPadding,
          child: SizedBox(
            width: togglableSize.width,
            height: togglableSize.height,
            child: Center(
              child: RepaintBoundary(
                child: CustomPaint(
                  size: togglableSize,
                  painter: painter
                    ..interactive = widget.interactive
                    ..hover = _hover
                    ..focus = _focus
                    ..active = _active
                    ..checked = widget.checked
                    ..oldChecked = _oldChecked
                    ..position = _position
                    ..sizePosition = _sizePosition
                    ..indicatorPosition = _indicatorPosition
                    ..uncheckedColor = uncheckedColor
                    ..uncheckedBorderColor = uncheckedBorderColor
                    ..checkedColor = checkedColor
                    ..checkmarkColor = checkmarkColor
                    ..disabledUncheckedColor = uncheckedDisabledColor
                    ..disabledUncheckedBorderColor =
                        uncheckedDisabledBorderColor
                    ..disabledCheckedColor = checkedDisabledColor
                    ..disabledCheckmarkColor = checkmarkDisabledColor
                    ..hoverIndicatorColor = hoverIndicatorColor
                    ..focusIndicatorColor = focusIndicatorColor,
                ),
              ),
            ),
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
  late Color uncheckedBorderColor;
  late Color checkedColor;
  late Color checkmarkColor;

  late Color disabledUncheckedColor;
  late Color disabledUncheckedBorderColor;
  late Color disabledCheckedColor;
  late Color disabledCheckmarkColor;

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

  void drawStateIndicator(Canvas canvas, Size canvasSize, Offset? offset) {
    if (interactive) {
      final defaultOffset = Offset(canvasSize.width / 2, canvasSize.height / 2);
      final color = focus ? focusIndicatorColor : hoverIndicatorColor;
      final paint = Paint()
        ..color =
            Color.lerp(Colors.transparent, color, indicatorPosition.value)!
        ..style = PaintingStyle.fill;

      canvas.drawCircle(offset ?? defaultOffset, _kIndicatorRadius, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final canvasSize = size;
    final t = position.value;
    final drawingOrigin = Offset(
      _kTogglableActiveResizeFactor / 2 * sizePosition.value,
      _kTogglableActiveResizeFactor / 2 * sizePosition.value,
    );
    final drawingSize = Size(
      canvasSize.width - _kTogglableActiveResizeFactor * sizePosition.value,
      canvasSize.height - _kTogglableActiveResizeFactor * sizePosition.value,
    );

    paintTogglable(canvas, size, drawingSize, drawingOrigin, t);
  }

  void paintTogglable(
    Canvas canvas,
    Size realSize,
    Size size,
    Offset origin,
    double t,
  );

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
