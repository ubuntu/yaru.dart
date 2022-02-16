import 'package:flutter/material.dart';

class YaruCarousel extends StatefulWidget {
  const YaruCarousel({
    Key? key,
    this.width = 500,
    this.fit,
    required this.urls,
    this.initialIndex = 0,
  }) : super(key: key);

  final double width;
  final BoxFit? fit;
  final List<String> urls;
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
          width: widget.width,
          height: 400,
          child: PageView.builder(
              itemCount: widget.urls.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  margin: EdgeInsets.all(index == _index ? 10 : 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1)),
                      image: DecorationImage(
                          fit: widget.fit,
                          image: NetworkImage(widget.urls[index]))),
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(widget.urls.length, (index) {
            return Container(
              margin: const EdgeInsets.all(3),
              width: 10,
              height: 10,
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
