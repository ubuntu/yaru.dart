import 'package:flutter/material.dart';
import 'package:yaru/src/widgets/yaru_paned_view_layout_delegate.dart';

typedef YaruPaneBuilder =
    Widget Function(BuildContext context, double availableSpace);

class YaruPanedView extends StatefulWidget {
  const YaruPanedView({
    super.key,
    required Widget this.pane,
    required Widget this.page,
    required this.layoutDelegate,
    this.onPaneSizeChange,
    this.includeSeparator = true,
  }) : paneBuilder = null,
       pageBuilder = null;

  const YaruPanedView.builder({
    super.key,
    required YaruPaneBuilder this.paneBuilder,
    required WidgetBuilder this.pageBuilder,
    required this.layoutDelegate,
    this.onPaneSizeChange,
    this.includeSeparator = true,
  }) : pane = null,
       page = null;

  /// Pane widget child.
  final Widget? pane;

  /// Pane widget child builder, taking the available space as a parameter.
  final YaruPaneBuilder? paneBuilder;

  /// Page widget child.
  final Widget? page;

  /// Page widget child builder.
  final WidgetBuilder? pageBuilder;

  /// Controls the size, side and resizing capacity of the pane.
  final YaruPanedViewLayoutDelegate layoutDelegate;

  /// Called each time the pane size change.
  final ValueChanged<double>? onPaneSizeChange;

  /// If true, a [Divider] will be added between the [pane] and the [page].
  final bool includeSeparator;

  @override
  State<YaruPanedView> createState() => _YaruPanedViewState();
}

const _kLeftPaneResizingRegionSize = 4.0;
const _kLeftPaneResizingRegionAnimationDuration = Duration(milliseconds: 250);

class _YaruPanedViewState extends State<YaruPanedView> {
  double? _paneSize;

  double? _oldPaneSize;
  double _paneSizeMove = 0.0;

  bool _isDragging = false;
  bool _isHovering = false;

  void updatePaneSize({
    required BoxConstraints constraints,
    required double? candidatePaneSize,
  }) {
    final oldPaneSize = _paneSize;

    _paneSize = widget.layoutDelegate.calculatePaneSize(
      availableSpace: widget.layoutDelegate.paneSide.isVertical
          ? constraints.maxHeight
          : constraints.maxWidth,
      candidatePaneSize: candidatePaneSize,
    );

    if (_paneSize != oldPaneSize) {
      widget.onPaneSizeChange?.call(_paneSize!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _maybeBuildGlobalMouseRegion(
      LayoutBuilder(
        builder: (context, constraints) {
          // Avoid left pane to overflow when resizing the window
          updatePaneSize(
            constraints: constraints,
            candidatePaneSize: _paneSize,
          );

          final page =
              widget.page ??
              widget.pageBuilder?.call(context) ??
              const SizedBox();
          final pane =
              widget.pane ??
              widget.paneBuilder?.call(context, _paneSize!) ??
              const SizedBox();

          return _buildFlexContainer([
            SizedBox(
              width: widget.layoutDelegate.paneSide.isHorizontal
                  ? _paneSize
                  : null,
              height: widget.layoutDelegate.paneSide.isVertical
                  ? _paneSize
                  : null,
              child: pane,
            ),
            if (widget.includeSeparator != false) _buildVerticalSeparator(),
            Expanded(
              child: widget.layoutDelegate.allowPaneResizing
                  ? Stack(
                      children: [
                        page,
                        _buildLeftPaneResizer(context, constraints, theme),
                      ],
                    )
                  : page,
            ),
          ]);
        },
      ),
    );
  }

  Widget _maybeBuildGlobalMouseRegion(Widget child) {
    if (widget.layoutDelegate.allowPaneResizing) {
      return MouseRegion(
        cursor: _isHovering || _isDragging
            ? widget.layoutDelegate.paneSide.isHorizontal
                  ? SystemMouseCursors.resizeColumn
                  : SystemMouseCursors.resizeRow
            : MouseCursor.defer,
        child: child,
      );
    }

    return child;
  }

  Widget _buildFlexContainer(List<Widget> children) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final top = widget.layoutDelegate.paneSide == YaruPaneSide.top;
    final left =
        widget.layoutDelegate.paneSide == YaruPaneSide.left ||
        (!isRtl && widget.layoutDelegate.paneSide == YaruPaneSide.start ||
            isRtl && widget.layoutDelegate.paneSide == YaruPaneSide.end);

    return widget.layoutDelegate.paneSide.isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: left ? TextDirection.ltr : TextDirection.rtl,
            children: children,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            verticalDirection: top
                ? VerticalDirection.down
                : VerticalDirection.up,
            children: children,
          );
  }

  Widget _buildVerticalSeparator() {
    return widget.layoutDelegate.paneSide.isVertical
        ? const Divider()
        : const VerticalDivider();
  }

  Widget _buildLeftPaneResizer(
    BuildContext context,
    BoxConstraints constraints,
    ThemeData theme,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final top = widget.layoutDelegate.paneSide == YaruPaneSide.top;
    final left =
        widget.layoutDelegate.paneSide == YaruPaneSide.left ||
        (!isRtl && widget.layoutDelegate.paneSide == YaruPaneSide.start ||
            isRtl && widget.layoutDelegate.paneSide == YaruPaneSide.end);
    final isHorizontal = widget.layoutDelegate.paneSide.isHorizontal;
    final isVertical = widget.layoutDelegate.paneSide.isVertical;

    return Positioned(
      width: isHorizontal ? _kLeftPaneResizingRegionSize : null,
      height: isVertical ? _kLeftPaneResizingRegionSize : null,
      top: isVertical
          ? top
                ? 0
                : null
          : 0,
      bottom: isVertical
          ? top
                ? null
                : 0
          : 0,
      left: isHorizontal
          ? left
                ? 0
                : null
          : 0,
      right: isHorizontal
          ? left
                ? null
                : 0
          : 0,
      child: AnimatedContainer(
        duration: _kLeftPaneResizingRegionAnimationDuration,
        color: _isHovering || _isDragging
            ? theme.dividerColor
            : theme.dividerColor.withValues(alpha: 0),
        child: MouseRegion(
          onEnter: (event) => setState(() {
            _isHovering = true;
          }),
          onExit: (event) => setState(() {
            _isHovering = false;
          }),
          child: GestureDetector(
            key: const ValueKey('YaruPanedView.leftPaneResizer'),
            onPanStart: (details) => setState(() {
              _isDragging = true;
              _oldPaneSize = _paneSize;
            }),
            onPanUpdate: (details) => setState(() {
              _paneSizeMove += isHorizontal
                  ? left
                        ? details.delta.dx
                        : -details.delta.dx
                  : top
                  ? details.delta.dy
                  : -details.delta.dy;
              updatePaneSize(
                constraints: constraints,
                candidatePaneSize: _oldPaneSize! + _paneSizeMove,
              );
            }),
            onPanEnd: (details) => setState(() {
              _isDragging = false;
              _paneSizeMove = 0.0;
            }),
          ),
        ),
      ),
    );
  }
}
