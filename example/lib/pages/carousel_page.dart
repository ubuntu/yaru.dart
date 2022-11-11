import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  int length = 3;
  final _autoScrollController = YaruCarouselController(autoScroll: true);

  @override
  void dispose() {
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        YaruSection(
          headline: const Text('Auto scroll: off'),
          width: 700,
          child: YaruCarousel(
            children: _getCarouselChildren(),
            height: 400,
            navigationControls: true,
          ),
        ),
        const SizedBox(height: 20),
        YaruSection(
          headline: const Text('Auto scroll: on'),
          width: 700,
          child: YaruCarousel(
            controller: _autoScrollController,
            children: _getCarouselChildren(),
            height: 400,
          ),
        ),
        ButtonBar(
          buttonPadding: EdgeInsets.zero,
          children: [
            YaruOptionButton(
              onPressed: () => setState(() {
                length++;
              }),
              child: const Icon(YaruIcons.plus),
            ),
            const SizedBox(
              width: 10,
            ),
            YaruOptionButton(
              onPressed: () => setState(() {
                length >= 2 ? length-- : length = length;
              }),
              child: const Icon(YaruIcons.minus),
            )
          ],
        )
      ],
    );
  }

  List<Widget> _getCarouselChildren() {
    return List.generate(
      length,
      (_) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
          image: const DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/ubuntuhero.jpg'),
          ),
        ),
      ),
    );
  }
}
