import 'dart:async';
import 'package:flutter/material.dart';

const _kAnimationDuration = Duration(milliseconds: 500);
const _kAnimationCurve = Curves.easeInOutCubic;

class YaruCarousel extends StatefulWidget {
  const YaruCarousel(
      {Key? key,
      this.height = 500,
      this.width = 500,
      required this.children,
      this.initialIndex = 0,
      this.autoScroll = false,
      this.autoScrollDuration = const Duration(seconds: 1),
      this.placeIndicator = true,
      this.placeIndicatorMarginTop = 12.0,
      this.viewportFraction = 0.8})
      : super(key: key);

  /// The height of the children, defaults to 500.0.
  final double height;

  /// The width of the children, defaults to 500.0.
  final double width;

  /// The list of child widgets shown in the carousel.
  final List<Widget> children;

  /// The index of the child that should be shown on first page load.
  final int initialIndex;

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

  /// The fraction of the viewport that each page should occupy.
  final double viewportFraction;

  @override
  State<YaruCarousel> createState() => _YaruCarouselState();
}

class _YaruCarouselState extends State<YaruCarousel> {
  late PageController _pageController;
  late Timer _timer;
  late int _index;

  @override
  void initState() {
    super.initState();

    _index = widget.initialIndex;
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _index,
    );

    if (widget.autoScroll) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(YaruCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_index > widget.children.length - 1) {
      _animateToPage(widget.children.length - 1);
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.autoScroll) {
      _cancelTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Column(
          children: [
            _buildCarousel(),
            ...(widget.placeIndicator && widget.children.length > 1
                ? [
                    SizedBox(
                      height: widget.placeIndicatorMarginTop,
                    ),
                    _buildPlaceIndicator()
                  ]
                : [])
          ],
        ));
  }

  Widget _buildCarousel() {
    return Expanded(
        child: PageView.builder(
      itemCount: widget.children.length,
      pageSnapping: true,
      controller: _pageController,
      physics:
          // Disable physic when auto scroll is enable because we cannot
          // disable the timer when dragging the view
          widget.autoScroll ? const NeverScrollableScrollPhysics() : null,
      onPageChanged: (index) => setState(() => _index = index),
      itemBuilder: (context, index) => AnimatedScale(
        scale: _index == index ? 1.0 : .9,
        duration: _kAnimationDuration,
        curve: _kAnimationCurve,
        child: Container(
          child: _index == index - 1 || _index == index + 1
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
    ));
  }

  Widget _buildPlaceIndicator() {
    return LayoutBuilder(builder: (context, constraints) {
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
    });
  }

  Widget _buildDotIndicator(double dotSize, double dotSpacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        widget.children.length,
        (index) => GestureDetector(
          onTap: _index == index ? null : () => _animateToPage(index),
          child: Padding(
            padding: EdgeInsets.only(left: index != 0 ? dotSpacing : 0),
            child: AnimatedContainer(
              duration: _kAnimationDuration,
              curve: _kAnimationCurve,
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                  color: _index == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextIndicator() {
    return Text(
      '${_index + 1}/${widget.children.length}',
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.center,
    );
  }

  void _animateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: _kAnimationDuration,
      curve: _kAnimationCurve,
    );

    if (widget.autoScroll) {
      _cancelTimer();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.autoScrollDuration, (timer) {
      _animateToPage(_index >= widget.children.length ? 0 : _index++);
    });
  }

  void _cancelTimer() {
    _timer.cancel();
  }
}
