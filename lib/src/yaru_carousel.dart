import 'package:flutter/material.dart';

const _kAnimationDuration = Duration(milliseconds: 500);
const _kAnimationCurve = Curves.easeInOutCubic;

class YaruCarousel extends StatefulWidget {
  const YaruCarousel({
    Key? key,
    this.height = 500,
    this.width = 500,
    required this.children,
    this.initialIndex = 0,
  }) : super(key: key);

  /// The height of the children, defaults to 500.0.
  final double height;

  /// The width of the children, defaults to 500.0.
  final double width;

  /// The list of child widgets shown in the carousel.
  final List<Widget> children;

  /// The index of the child that should be shown on first page load.
  final int initialIndex;

  @override
  State<YaruCarousel> createState() => _YaruCarouselState();
}

class _YaruCarouselState extends State<YaruCarousel> {
  late PageController _pageController;

  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: PageView.builder(
              itemCount: widget.children.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (index) => setState(() => _index = index),
              itemBuilder: (context, index) => AnimatedContainer(
                    duration: _kAnimationDuration,
                    curve: _kAnimationCurve,
                    margin: EdgeInsets.all(index == _index ? 10 : 20),
                    child: GestureDetector(
                      onTap:
                          _index == index ? null : () => _animateToPage(index),
                      child: widget.children[index],
                    ),
                  )),
        ),
        widget.children.length < 30
            ? SizedBox(
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
                        onTap: _index == index
                            ? null
                            : () => _animateToPage(index),
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
              )
            : SizedBox(
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
              )
      ],
    );
  }

  void _animateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: _kAnimationDuration,
      curve: _kAnimationCurve,
    );
  }
}
