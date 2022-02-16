import 'package:flutter/material.dart';

class YaruCarousel extends StatefulWidget {
  const YaruCarousel({
    Key? key,
    this.height = 500,
    this.width = 500,
    this.fit,
    this.centerSlice,
    this.showBorder = true,
    this.radius = 10.0,
    required this.images,
    this.initialIndex = 0,
    this.onTap,
  }) : super(key: key);

  /// The height of the images, defaults to 500.0.
  final double height;

  /// The width of the images, defaults to 500.0.
  final double width;

  /// How the images should be inscribed into the box.
  /// The default is [BoxFit.scaleDown] if [centerSlice] is null, and [BoxFit.fill] if [centerSlice] is not null.
  /// See the discussion at [paintImage] for more details.
  final BoxFit? fit;

  /// The center slice for the images. See [DecorationImage] for more details
  final Rect? centerSlice;

  /// Determines if a soft border is drawn around the [DecorationImage]s [BoxDecoration].
  /// By default it is set to [true].
  final bool showBorder;

  /// The value for the [Border.radius], by default it is 10.0.
  final double radius;

  /// The list of images. They can be any type of image implementing [ImageProvider].
  final List<ImageProvider> images;

  /// The index of the image that should be shown on first page load.
  final int initialIndex;

  /// An optional onTap callback used when clicking the current image.
  final Function()? onTap;

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
              itemCount: widget.images.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(widget.radius),
                  onTap: widget.onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                    margin: EdgeInsets.all(index == _index ? 10 : 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      border: widget.showBorder
                          ? Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.1))
                          : null,
                      image: DecorationImage(
                        fit: widget.fit,
                        centerSlice: widget.centerSlice,
                        image: widget.images[index],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(widget.images.length, (index) {
            return Container(
              margin: const EdgeInsets.all(5),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  color: _index == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  shape: BoxShape.circle),
            );
          }),
        )
      ],
    );
  }
}
