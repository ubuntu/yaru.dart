import 'dart:async';
import 'package:flutter/material.dart';

const _kAnimationDuration = Duration(milliseconds: 500);
const _kAnimationCurve = Curves.easeInOutCubic;

class YaruCarousel extends StatefulWidget {
  const YaruCarousel({
    super.key,
    this.height = 500,
    this.width = 500,
    required this.controller,
    required this.children,
    this.autoScroll = false,
    this.autoScrollDuration = const Duration(seconds: 1),
    this.placeIndicator = true,
    this.placeIndicatorMarginTop = 12.0,
    this.navigationControls = false,
    this.previousIcon,
    this.nextIcon,
  });

  /// The height of the children, defaults to 500.0.
  final double height;

  /// The width of the children, defaults to 500.0.
  final double width;

  final PageController controller;

  /// The list of child widgets shown in the carousel.
  final List<Widget> children;

  /// Enable an auto scrolling loop of all children
  final bool autoScroll;

  /// If [autoScroll] is enabled, this value determine the time spent on each carousel child
  final Duration autoScrollDuration;

  /// Display a place indicator
  ///
  /// Show a dot based indicator if there  is enough space,
  /// else use a text based indicator
  final bool placeIndicator;

  /// Margin between the carousel and the place indicator
  final double placeIndicatorMarginTop;

  /// Display previous and next navigation buttons
  final bool navigationControls;

  /// Icon used for the previous button
  /// Require [navigationControls] to be true
  final Widget? previousIcon;

  /// Icon used for the next button
  /// Require [navigationControls] to be true
  final Widget? nextIcon;

  @override
  State<YaruCarousel> createState() => _YaruCarouselState();
}

class _YaruCarouselState extends State<YaruCarousel> {
  late Timer _timer;
  late int _page;

  @override
  void initState() {
    super.initState();

    _page = widget.controller.initialPage;

    _startTimer();
  }

  @override
  void didUpdateWidget(YaruCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_page > widget.children.length - 1) {
      _animateToPage(widget.children.length - 1);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          _buildCarousel(),
          if (widget.placeIndicator && widget.children.length > 1) ...[
            SizedBox(
              height: widget.placeIndicatorMarginTop,
            ),
            _buildPlaceIndicator()
          ]
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    final carousel = PageView.builder(
      itemCount: widget.children.length,
      pageSnapping: true,
      controller: widget.controller,
      physics:
          // Disable physic when auto scroll is enable because we cannot
          // disable the timer when dragging the view
          widget.autoScroll ? const NeverScrollableScrollPhysics() : null,
      onPageChanged: (index) => setState(() => _page = index),
      itemBuilder: (context, index) => AnimatedScale(
        scale: _page == index ? 1.0 : .9,
        duration: _kAnimationDuration,
        curve: _kAnimationCurve,
        child: Container(
          child: _page == index - 1 || _page == index + 1
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _animateToPage(index),
                  child: IgnorePointer(
                    child: widget.children[index],
                  ),
                )
              : widget.children[index],
        ),
      ),
    );

    if (widget.navigationControls) {
      return Expanded(
        child: Stack(
          children: [
            carousel,
            _buildNavigationButton(
              Alignment.centerLeft,
              _isFirstPage() ? null : () => _animateToPreviousPage(),
              widget.previousIcon ?? const Icon(Icons.arrow_back),
            ),
            _buildNavigationButton(
              Alignment.centerRight,
              _isLastPage() ? null : () => _animateToNextPage(),
              widget.nextIcon ?? const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      );
    }

    return Expanded(child: carousel);
  }

  Widget _buildNavigationButton(
    AlignmentGeometry alignement,
    VoidCallback? onPressed,
    Widget icon,
  ) {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: onPressed != null ? 1 : 0,
        duration: _kAnimationDuration,
        curve: _kAnimationCurve,
        child: Align(
          alignment: alignement,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            onPressed: onPressed,
            child: icon,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceIndicator() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double dotSize = 12.0;

        for (var layout in [
          [48.0, constraints.maxWidth / 2],
          [24.0, constraints.maxWidth / 3 * 2],
          [12.0, constraints.maxWidth / 6 * 5]
        ]) {
          final double dotSpacing = layout[0];
          final double maxWidth = layout[1];

          if (dotSize * widget.children.length +
                  dotSpacing * (widget.children.length - 1) <
              maxWidth) {
            return _buildDotIndicator(dotSize, dotSpacing);
          }
        }

        return _buildTextIndicator();
      },
    );
  }

  Widget _buildDotIndicator(double dotSize, double dotSpacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        widget.children.length,
        (index) => GestureDetector(
          onTap: _page == index ? null : () => _animateToPage(index),
          child: Padding(
            padding: EdgeInsets.only(left: index != 0 ? dotSpacing : 0),
            child: AnimatedContainer(
              duration: _kAnimationDuration,
              curve: _kAnimationCurve,
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: _page == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextIndicator() {
    return Text(
      '${_page + 1}/${widget.children.length}',
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }

  bool _isFirstPage() {
    return _page == 0;
  }

  bool _isLastPage() {
    return _page == widget.children.length - 1;
  }

  void _animateToPage(int pageIndex) {
    widget.controller.animateToPage(
      pageIndex,
      duration: _kAnimationDuration,
      curve: _kAnimationCurve,
    );

    _restartTimer();
  }

  void _animateToPreviousPage() {
    widget.controller.previousPage(
      duration: _kAnimationDuration,
      curve: _kAnimationCurve,
    );

    _restartTimer();
  }

  void _animateToNextPage() {
    widget.controller.nextPage(
      duration: _kAnimationDuration,
      curve: _kAnimationCurve,
    );

    _restartTimer();
  }

  void _startTimer() {
    if (widget.autoScroll) {
      _timer = Timer(widget.autoScrollDuration + _kAnimationDuration, () {
        _animateToPage(_page >= widget.children.length ? 0 : _page++);
      });
    }
  }

  void _cancelTimer() {
    if (widget.autoScroll) {
      _timer.cancel();
    }
  }

  void _restartTimer() {
    _cancelTimer();
    _startTimer();
  }
}

class YaruCarouselController extends PageController {}
