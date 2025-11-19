import 'dart:async';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:yaru/widgets.dart';
import 'package:yaru/yaru.dart';

/// Display a list of widgets in a carousel view.
///
/// It comes with useful features like navigation controls,
/// a default place indicator and auto-scroll (through [YaruCarouselController]).
///
/// See also:
///
///  * [YaruPageIndicator], a responsive page indicator, used by default in this carousel.
class YaruCarousel extends StatefulWidget {
  /// Creates a [YaruCarousel].
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
    this.previousIconSemanticLabel,
    this.nextIconSemanticLabel,
    this.navigationHasFocusBorder,
  });

  /// The height of the children, defaults to 500.0.
  final double height;

  /// The width of the children, defaults to 500.0.
  final double width;

  /// An optional controller that can be used to enable the auto-scroll behavior.
  /// It can also be used to navigate to a specific page.
  final YaruCarouselController? controller;

  /// The list of child widgets shown in the carousel.
  final List<Widget> children;

  /// Display a place indicator.
  ///
  /// Show a dot based indicator if there is enough space,
  /// else use a text based indicator
  final bool placeIndicator;

  /// Margin between the carousel and the place indicator.
  final double placeIndicatorMarginTop;

  /// Display previous and next navigation buttons.
  final bool navigationControls;

  /// Icon used for the previous button.
  /// Require [navigationControls] to be true.
  final Widget? previousIcon;

  /// Icon used for the next button.
  /// Require [navigationControls] to be true.
  final Widget? nextIcon;

  /// Optional semantic label to add to the previous button icon.
  final String? previousIconSemanticLabel;

  /// Optional semantic label to add to the next button icon.
  final String? nextIconSemanticLabel;

  /// Optionally enable/disable the focus border for the navigation buttons.
  final bool? navigationHasFocusBorder;

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
            SizedBox(height: widget.placeIndicatorMarginTop),
            YaruPageIndicator.builder(
              length: widget.children.length,
              page: _page,
              onTap: (page) => _controller.animateToPage(page),
              itemBuilder: (index, selectedIndex, length) =>
                  YaruPageIndicatorItem(
                    selected: index == selectedIndex,
                    animationDuration: _controller.scrollAnimationDuration,
                    animationCurve: _controller.scrollAnimationCurve,
                  ),
            ),
          ],
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
                  child: IgnorePointer(child: widget.children[index]),
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
              widget.previousIcon ??
                  Icon(
                    YaruIcons.go_previous,
                    semanticLabel: widget.previousIconSemanticLabel,
                  ),
            ),
            _buildNavigationButton(
              Alignment.centerRight,
              _isLastPage() ? null : _controller.nextPage,
              widget.nextIcon ??
                  Icon(
                    YaruIcons.go_next,
                    semanticLabel: widget.nextIconSemanticLabel,
                  ),
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
    final button = OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      onPressed: onPressed,
      child: icon,
    );
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: onPressed != null ? 1 : 0,
        duration: _controller.scrollAnimationDuration,
        curve: _controller.scrollAnimationCurve,
        child: Align(
          alignment: alignment,
          child:
              widget.navigationHasFocusBorder ??
                  YaruTheme.maybeOf(context)?.focusBorders == true
              ? YaruFocusBorder.primary(child: button)
              : button,
        ),
      ),
    );
  }

  bool _isFirstPage() {
    return _page == 0;
  }

  bool _isLastPage() {
    return _page == widget.children.length - 1;
  }
}

/// A controller that can be used to enable the auto-scroll behavior of a [YaruCarousel].
/// It can also be used to navigate to a specific page.
class YaruCarouselController extends PageController {
  /// Creates a [YaruCarousel].
  YaruCarouselController({
    super.initialPage,
    super.keepPage,
    super.viewportFraction = 0.8,
    this.scrollAnimationDuration = const Duration(milliseconds: 500),
    this.scrollAnimationCurve = Curves.easeInOutCubic,
    this.autoScroll = false,
    this.autoScrollDuration = const Duration(seconds: 3),
  });

  /// Default duration of a transition between two pages.
  final Duration scrollAnimationDuration;

  /// Default curve used in a transition between two page.
  final Curve scrollAnimationCurve;

  /// Enable an auto scrolling loop of all children.
  final bool autoScroll;

  /// If [autoScroll] is enabled, this value determine the time spent on each carousel child.
  final Duration autoScrollDuration;

  Timer? _timer;
  bool _animating = false;

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
  }) async {
    if (!_animating) {
      _animating = true;
      cancelTimer();

      return super
          .animateToPage(
            page,
            duration: duration ?? scrollAnimationDuration,
            curve: curve ?? scrollAnimationCurve,
          )
          .then((value) {
            _animating = false;
            startTimer();
          });
    }
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
      curve: curve ?? scrollAnimationCurve,
    );
  }

  @override
  Future<void> previousPage({Duration? duration, Curve? curve}) {
    return super.previousPage(
      duration: duration ?? scrollAnimationDuration,
      curve: curve ?? scrollAnimationCurve,
    );
  }

  /// Start the auto-scroll timer.
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

  /// Cancel the auto-scroll timer.
  void cancelTimer() {
    if (autoScroll) {
      _timer!.cancel();
    }
  }
}
