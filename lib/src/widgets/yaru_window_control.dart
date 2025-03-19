import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaru/theme.dart';

/// The size of a [YaruWindowControl] on the [YaruWindowControlPlatform.yaru] platform.
const kYaruWindowControlSize = 24.0;

/// The size of a [YaruWindowControl] on the [YaruWindowControlPlatform.windows] platform.
const kYaruWindowsWindowControlSize = 46.0;

const _kWindowControlIconStrokeWidth = 1.0;
const _kWindowControlIconStrokeAlign = _kWindowControlIconStrokeWidth / 2;
const _kWindowControlIconAnimationDuration = Duration(milliseconds: 750);
const _kWindowControlAnimationCurve = Curves.linear;
const _kWindowControlBackgroundAnimationDuration = Duration(milliseconds: 150);

/// Defines the type of a [YaruWindowControl].
enum YaruWindowControlType {
  close,
  maximize,
  restore,
  minimize;

  static YaruWindowControlType? fromName(String name) =>
      YaruWindowControlType.values.firstWhereOrNull((e) => e.name == name);
}

/// Defines the style of a [YaruWindowControl].
enum YaruWindowControlPlatform {
  /// Yaru like window control.
  /// Circle shape and grey background.
  yaru,

  /// Windows like window control.
  /// Rectangle shape and grey (red for close) background on hover.
  windows,
}

class YaruWindowControl extends StatefulWidget {
  const YaruWindowControl({
    super.key,
    required this.type,
    this.platform = YaruWindowControlPlatform.yaru,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  /// Type of this window control, see [YaruWindowControlType].
  /// Ex: close, maximize...
  final YaruWindowControlType type;

  /// Platform style of this window control, see [YaruWindowControlPlatform].
  ///
  /// Set to null if you want to auto select the correct platform.
  /// When [Platform.isWindows] is true, [YaruWindowControlPlatform.windows] will be used,
  /// [YaruWindowControlPlatform.yaru] will be used in all the other cases.
  final YaruWindowControlPlatform? platform;

  /// An optional callback that is called when the button is pressed.
  /// If null, the button will be displayed in a disabled state.
  final GestureTapCallback? onTap;

  /// Color used to draw the control icon.
  /// Leave to null, or return null, to use the default value.
  final WidgetStateProperty<Color?>? iconColor;

  /// Color used to draw the control background decoration.
  /// Leave to null, or return null, to use the default value.
  final WidgetStateProperty<Color?>? backgroundColor;

  @override
  State<YaruWindowControl> createState() {
    return _YaruWindowControlState();
  }
}

class _YaruWindowControlState extends State<YaruWindowControl>
    with TickerProviderStateMixin {
  bool _hovered = false;
  bool _active = false;
  bool get interactive => widget.onTap != null;

  late YaruWindowControlType oldType;

  YaruWindowControlPlatform get style {
    if (widget.platform != null) {
      return widget.platform!;
    }

    return !kIsWeb && Platform.isWindows
        ? YaruWindowControlPlatform.windows
        : YaruWindowControlPlatform.yaru;
  }

  late CurvedAnimation _animationProgress;
  late AnimationController _animationController;

  Set<WidgetState> get _states {
    final states = <WidgetState>{};

    if (_hovered) {
      states.add(WidgetState.hovered);
    }
    if (_active) {
      states.add(WidgetState.pressed);
    }
    if (!interactive) {
      states.add(WidgetState.disabled);
    }

    return states;
  }

  @override
  void initState() {
    super.initState();

    oldType = widget.type;

    _animationController = AnimationController(
      duration: _kWindowControlIconAnimationDuration,
      value: widget.type == YaruWindowControlType.maximize ? 0.0 : 1.0,
      vsync: this,
    );
    _animationProgress = CurvedAnimation(
      parent: _animationController,
      curve: _kWindowControlAnimationCurve,
    );
  }

  @override
  void didUpdateWidget(YaruWindowControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.type != widget.type) {
      oldType = widget.type;

      if (oldWidget.type == YaruWindowControlType.maximize &&
          widget.type == YaruWindowControlType.restore) {
        _animationController.forward();
      } else if (oldWidget.type == YaruWindowControlType.restore &&
          widget.type == YaruWindowControlType.maximize) {
        _animationController.reverse();
      } else if (widget.type == YaruWindowControlType.restore) {
        _animationController.value = 0.0;
      } else if (widget.type == YaruWindowControlType.maximize) {
        _animationController.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHoverChange(bool hovered) {
    if (_hovered == hovered) {
      return;
    }

    setState(() {
      _hovered = hovered;

      if (!hovered) {
        _active = false;
      }
    });
  }

  void _handleActiveChange(bool active) {
    if (_active == active) {
      return;
    }

    setState(() {
      _active = active;
    });
  }

  Widget _buildEventDetectors({required Widget child}) {
    return MouseRegion(
      onEnter: (_) => _handleHoverChange(true),
      onExit: (_) => _handleHoverChange(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _handleActiveChange(true),
        onTapUp: (_) => _handleActiveChange(false),
        child: child,
      ),
    );
  }

  Color _getBackgoundColor(ColorScheme colorScheme) {
    final backgroundColor = widget.backgroundColor?.resolve(_states);
    if (backgroundColor != null) return backgroundColor;

    switch (style) {
      case YaruWindowControlPlatform.yaru:
        return _getYaruBackgroundColor(colorScheme);
      case YaruWindowControlPlatform.windows:
        return _getWindowsBackgroundColor(colorScheme);
    }
  }

  Color _getYaruBackgroundColor(ColorScheme colorScheme) {
    final onSurface = colorScheme.onSurface;

    if (!interactive) {
      return onSurface.withValues(alpha: 0.05);
    }

    return _active
        ? onSurface.withValues(alpha: 0.2)
        : _hovered
            ? onSurface.withValues(alpha: 0.15)
            : onSurface.withValues(alpha: 0.1);
  }

  Color _getWindowsBackgroundColor(ColorScheme colorScheme) {
    if (!interactive) {
      return Colors.transparent;
    }

    final onSurface = Theme.of(context).colorScheme.onSurface;
    const closeButtonHoverBackgroundColor = Color(0xffe81123);

    if (widget.type == YaruWindowControlType.close) {
      return closeButtonHoverBackgroundColor.withValues(
        alpha: _active
            ? 0.5
            : _hovered
                ? 1.0
                : 0.0,
      );
    }

    return _active
        ? onSurface.withValues(alpha: 0.15)
        : _hovered
            ? onSurface.withValues(alpha: 0.1)
            : Colors.transparent;
  }

  Color _getIconColor(ColorScheme colorScheme) {
    final color = switch (style) {
      YaruWindowControlPlatform.yaru => _getYaruIconColor(colorScheme),
      YaruWindowControlPlatform.windows => _getWindowsIconColor(colorScheme)
    };

    return color.withValues(alpha: interactive ? 1.0 : 0.5);
  }

  Color _getYaruIconColor(ColorScheme colorScheme) {
    return widget.iconColor?.resolve(_states) ?? colorScheme.onSurface;
  }

  Color _getWindowsIconColor(ColorScheme colorScheme) {
    final color = widget.iconColor?.resolve(_states) ?? colorScheme.onSurface;
    if (interactive && _hovered && widget.type == YaruWindowControlType.close) {
      return Colors.white;
    }
    return color;
  }

  double get _iconSize {
    switch (style) {
      case YaruWindowControlPlatform.yaru:
        return 8.0;
      case YaruWindowControlPlatform.windows:
        return 10.0;
    }
  }

  Widget _buildBoxDecoration({
    required Widget child,
    required ColorScheme colorScheme,
  }) {
    switch (style) {
      case YaruWindowControlPlatform.yaru:
        return _buildYaruBoxDecoration(child, colorScheme);
      case YaruWindowControlPlatform.windows:
        return _buildWindowsBoxDecoration(child, colorScheme);
    }
  }

  Widget _buildYaruBoxDecoration(
    Widget child,
    ColorScheme colorScheme,
  ) {
    return AnimatedContainer(
      duration: _kWindowControlBackgroundAnimationDuration,
      decoration: BoxDecoration(
        color: _getBackgoundColor(colorScheme),
        border: colorScheme.isHighContrast
            ? Border.all(
                color: colorScheme.outlineVariant,
                strokeAlign: BorderSide.strokeAlignOutside,
              )
            : null,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: kYaruWindowControlSize,
        child: child,
      ),
    );
  }

  Widget _buildWindowsBoxDecoration(
    Widget child,
    ColorScheme colorScheme,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _getBackgoundColor(colorScheme),
        border: colorScheme.isHighContrast
            ? Border.all(
                color: colorScheme.outlineVariant,
                strokeAlign: BorderSide.strokeAlignOutside,
              )
            : null,
      ),
      child: SizedBox.square(
        dimension: kYaruWindowsWindowControlSize,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _buildEventDetectors(
      child: RepaintBoundary(
        child: _buildBoxDecoration(
          colorScheme: colorScheme,
          child: Center(
            child: AnimatedBuilder(
              animation: _animationProgress,
              builder: (context, child) => CustomPaint(
                size: Size.square(_iconSize),
                painter: _YaruWindowControlIconPainter(
                  type: widget.type,
                  style: style,
                  iconColor: _getIconColor(colorScheme),
                  progress: _animationProgress.value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _YaruWindowControlIconPainter extends CustomPainter {
  _YaruWindowControlIconPainter({
    required this.type,
    required this.style,
    required this.iconColor,
    required this.progress,
  });

  final YaruWindowControlType type;
  final YaruWindowControlPlatform style;
  final Color iconColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      _kWindowControlIconStrokeAlign,
      _kWindowControlIconStrokeAlign,
      size.width - _kWindowControlIconStrokeAlign * 2,
      size.height - _kWindowControlIconStrokeAlign * 2,
    );

    switch (type) {
      case YaruWindowControlType.close:
        _drawClose(canvas, rect);
        break;
      case YaruWindowControlType.minimize:
        _drawMinimize(canvas, rect);
        break;
      case YaruWindowControlType.restore:
      case YaruWindowControlType.maximize:
        _drawRestoreMaximize(canvas, rect);
        break;
    }
  }

  void _drawClose(Canvas canvas, Rect rect) {
    canvas.drawLine(rect.topLeft, rect.bottomRight, _getIconPaint());
    canvas.drawLine(rect.topRight, rect.bottomLeft, _getIconPaint());
  }

  void _drawRestoreMaximize(Canvas canvas, Rect rect) {
    switch (style) {
      case YaruWindowControlPlatform.yaru:
        _drawYaruRestoreMaximize(canvas, rect);
        break;
      case YaruWindowControlPlatform.windows:
        _drawWindowsRestoreMaximize(canvas, rect);
        break;
    }
  }

  void _drawYaruRestoreMaximize(Canvas canvas, Rect drawRect) {
    final step1Progress = (progress * 2).clamp(0.0, 1.0);
    const gap = _kWindowControlIconStrokeWidth + 1;
    final rect = Rect.fromLTRB(
      drawRect.left,
      drawRect.top + gap * step1Progress,
      drawRect.right - gap * step1Progress,
      drawRect.bottom,
    );
    canvas.drawRect(rect, _getIconPaint());

    if (progress >= 0.5) {
      final step2Progress = (progress - 0.5) * 2;
      final path = Path()
        ..moveTo(
          drawRect.topLeft.dx + (1 + _kWindowControlIconStrokeAlign),
          drawRect.topLeft.dy,
        )
        ..lineTo(
          drawRect.topRight.dx,
          drawRect.topRight.dy,
        )
        ..lineTo(
          drawRect.bottomRight.dx,
          drawRect.bottomRight.dy - (1 + _kWindowControlIconStrokeAlign),
        );
      canvas.drawPath(
        path,
        _getIconPaint(iconColor.scale(alpha: -1.0 + 0.5 * step2Progress)),
      );
    }
  }

  void _drawWindowsRestoreMaximize(Canvas canvas, Rect drawRect) {
    const gap = _kWindowControlIconStrokeWidth + 1;

    final step1Progress = (progress * 2).clamp(0.0, 1.0);
    final rect1 = Rect.fromLTRB(
      drawRect.left,
      drawRect.top + gap * step1Progress,
      drawRect.right - gap * step1Progress,
      drawRect.bottom,
    );

    if (progress >= 0.5) {
      final step2Progress = (progress - 0.5) * 2;
      final rect2 = Rect.fromLTRB(
        drawRect.left + gap,
        drawRect.top,
        drawRect.right,
        drawRect.bottom - gap,
      );
      canvas.saveLayer(Rect.largest, Paint());
      canvas.drawRect(
        rect2,
        _getIconPaint(
          iconColor.scale(alpha: -1.0 + step2Progress),
        ),
      );
      canvas.drawRect(rect1, _getFillDiffPaint());
      canvas.restore();
    }

    canvas.drawRect(rect1, _getIconPaint());
  }

  void _drawMinimize(Canvas canvas, Rect rect) {
    switch (style) {
      case YaruWindowControlPlatform.yaru:
        _drawYaruMinimize(canvas, rect);
        break;
      case YaruWindowControlPlatform.windows:
        _drawWindowsMinimize(canvas, rect);
        break;
    }
  }

  void _drawYaruMinimize(Canvas canvas, Rect rect) {
    canvas.drawLine(
      Offset(rect.bottomLeft.dx, rect.bottomLeft.dy - 1.0),
      Offset(rect.bottomRight.dx, rect.bottomRight.dy - 1.0),
      _getIconPaint(),
    );
  }

  void _drawWindowsMinimize(Canvas canvas, Rect rect) {
    canvas.drawLine(
      Offset(rect.bottomLeft.dx, rect.centerLeft.dy - 0.5),
      Offset(rect.bottomRight.dx, rect.centerRight.dy - 0.5),
      _getIconPaint(),
    );
  }

  Paint _getIconPaint([Color? color]) {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kWindowControlIconStrokeWidth
      ..color = color ?? iconColor
      ..strokeCap = StrokeCap.square;
  }

  Paint _getFillDiffPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black
      ..blendMode = BlendMode.dstOut;
  }

  @override
  bool shouldRepaint(_YaruWindowControlIconPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.style != style ||
      oldDelegate.progress != progress ||
      oldDelegate.iconColor != iconColor;
}
