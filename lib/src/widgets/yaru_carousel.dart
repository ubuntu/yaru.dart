import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

class YaruCarousel extends StatefulWidget {
  const YaruCarousel({
    super.key,
    this.height = 500,
    this.width = 500,
    this.controller,
    required this.children,
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

  final YaruCarouselController? controller;

  /// The list of child widgets shown in the carousel.
  final List<Widget> children;

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
  late int _page;
  late YaruCarouselController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? YaruCarouselController();
    _page = _controller.initialPage;
  }

  @override
  void didUpdateWidget(YaruCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      final oldInitialPage = _controller.initialPage;
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? YaruCarouselController();
      if (oldInitialPage != _controller.initialPage) {
        _page = _controller.initialPage;
      }
    }

    if (_page > widget.children.length - 1) {
      _page = widget.children.length - 1;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
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
      controller: _controller,
      physics:
          // Disable physic when auto scroll is enable because we cannot
          // disable the timer when dragging the view
          _controller.autoScroll ? const NeverScrollableScrollPhysics() : null,
      onPageChanged: (index) => setState(() => _page = index),
      itemBuilder: (context, index) => AnimatedScale(
        scale: _page == index ? 1.0 : .9,
        duration: _controller.scrollAnimationDuration,
        curve: _controller.scrollAnimationCurve,
        child: Container(
          child: _page == index - 1 || _page == index + 1
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _controller.animateToPage(index),
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
              _isFirstPage() ? null : _controller.previousPage,
              widget.previousIcon ?? const Icon(YaruIcons.go_previous),
            ),
            _buildNavigationButton(
              Alignment.centerRight,
              _isLastPage() ? null : _controller.nextPage,
              widget.nextIcon ?? const Icon(YaruIcons.go_next),
            ),
          ],
        ),
      );
    }

    return Expanded(child: carousel);
  }

  Widget _buildNavigationButton(
    AlignmentGeometry alignment,
    VoidCallback? onPressed,
    Widget icon,
  ) {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: onPressed != null ? 1 : 0,
        duration: _controller.scrollAnimationDuration,
        curve: _controller.scrollAnimationCurve,
        child: Align(
          alignment: alignment,
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
        const dotSize = 12.0;

        for (final layout in [
          [48.0, constraints.maxWidth / 2],
          [24.0, constraints.maxWidth / 3 * 2],
          [12.0, constraints.maxWidth / 6 * 5]
        ]) {
          final dotSpacing = layout[0];
          final maxWidth = layout[1];

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
          onTap: _page == index ? null : () => _controller.animateToPage(index),
          child: Padding(
            padding: EdgeInsets.only(left: index != 0 ? dotSpacing : 0),
            child: AnimatedContainer(
              duration: _controller.scrollAnimationDuration,
              curve: _controller.scrollAnimationCurve,
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
}

class YaruCarouselController extends PageController {
  YaruCarouselController({
    super.initialPage,
    super.keepPage,
    super.viewportFraction = 0.8,
    this.scrollAnimationDuration = const Duration(milliseconds: 500),
    this.scrollAnimationCurve = Curves.easeInOutCubic,
    this.autoScroll = false,
    this.autoScrollDuration = const Duration(seconds: 3),
  });

  final Duration scrollAnimationDuration;

  final Curve scrollAnimationCurve;

  /// Enable an auto scrolling loop of all children
  final bool autoScroll;

  /// If [autoScroll] is enabled, this value determine the time spent on each carousel child
  final Duration autoScrollDuration;

  Timer? _timer;

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    startTimer();
  }

  @override
  void detach(ScrollPosition position) {
    super.detach(position);
    cancelTimer();
    _timer = null;
  }

  @override
  Future<void> animateToPage(
    int page, {
    Duration? duration,
    Curve? curve,
  }) {
    cancelTimer();

    return super
        .animateToPage(
          page,
          duration: duration ?? scrollAnimationDuration,
          curve: scrollAnimationCurve,
        )
        .then((value) => startTimer());
  }

  @override
  void jumpToPage(int page) {
    super.jumpToPage(page);
    cancelTimer();
    startTimer();
  }

  @override
  Future<void> nextPage({Duration? duration, Curve? curve}) {
    return super.nextPage(
      duration: duration ?? scrollAnimationDuration,
      curve: scrollAnimationCurve,
    );
  }

  @override
  Future<void> previousPage({Duration? duration, Curve? curve}) {
    return super.previousPage(
      duration: duration ?? scrollAnimationDuration,
      curve: scrollAnimationCurve,
    );
  }

  void startTimer() {
    if (autoScroll && hasClients) {
      _timer = Timer(autoScrollDuration, () {
        final carousel = position.context.notificationContext
            ?.findAncestorWidgetOfExactType<YaruCarousel>();
        final pagesLength = carousel?.children.length ?? 0;
        animateToPage(page!.round() + 1 >= pagesLength ? 0 : page!.round() + 1);
      });
    }
  }

  void cancelTimer() {
    if (autoScroll) {
      _timer!.cancel();
    }
  }
}
