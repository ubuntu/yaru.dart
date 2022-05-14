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
      this.autoScrollDuration = const Duration(seconds: 1)})
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
      viewportFraction: 0.8,
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
    return Column(
      children: [_buildCarousel(), _buildPlaceIndicator()],
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: PageView.builder(
          itemCount: widget.children.length,
          pageSnapping: true,
          controller: _pageController,
          physics:
              // Disable physic when auto scroll is enable because we cannot
              // disable the timer when dragging the view
              widget.autoScroll ? const NeverScrollableScrollPhysics() : null,
          onPageChanged: (index) => setState(() => _index = index),
          itemBuilder: (context, index) => AnimatedContainer(
                duration: _kAnimationDuration,
                curve: _kAnimationCurve,
                margin: EdgeInsets.all(index == _index ? 10 : 20),
                child: _index == index - 1 || _index == index + 1
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _animateToPage(index),
                        child: IgnorePointer(
                          child: widget.children[index],
                        ),
                      )
                    : widget.children[index],
              )),
    );
  }

  Widget _buildPlaceIndicator() {
    // If children are lower than 30, return a dot based indicator
    if (widget.children.length < 30) {
      return SizedBox(
        width: widget.children.length < 5
            ? widget.width / 3
            : widget.children.length < 10
                ? widget.width / 2
                : widget.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            widget.children.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: _index == index ? null : () => _animateToPage(index),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: _index == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                      shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Else return a text based indicator
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$_index/${widget.children.length}',
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
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
