import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({Key? key}) : super(key: key);

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  int length = 3;

  @override
  Widget build(BuildContext context) {
    return YaruPage(children: [
      YaruSection(headline: 'Auto scroll: off', width: 700, children: [
        YaruCarousel(
          controller: YaruCarouselController(
            pagesLength: _getCarouselChildren().length,
          ),
          children: _getCarouselChildren(),
          height: 400,
          navigationControls: true,
          previousIcon: Icon(YaruIcons.go_previous),
          nextIcon: Icon(YaruIcons.go_next),
        ),
      ]),
      YaruSection(headline: 'Auto scroll: on', width: 700, children: [
        YaruCarousel(
          controller: YaruCarouselController(
            autoScroll: true,
            pagesLength: _getCarouselChildren().length,
          ),
          children: _getCarouselChildren(),
          height: 400,
          navigationControls: true,
        ),
      ]),
      ButtonBar(
        buttonPadding: EdgeInsets.zero,
        children: [
          YaruOptionButton(
              onPressed: () => setState(() {
                    length++;
                  }),
              child: Icon(YaruIcons.plus)),
          SizedBox(
            width: 10,
          ),
          YaruOptionButton(
              onPressed: () => setState(() {
                    length >= 2 ? length-- : length = length;
                  }),
              child: Icon(YaruIcons.minus))
        ],
      )
    ]);
  }

  List<Widget> _getCarouselChildren() {
    return List.generate(
      length,
      (_) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
          image: DecorationImage(
              fit: BoxFit.contain, image: AssetImage('assets/ubuntuhero.jpg')),
        ),
      ),
    );
  }
}
