import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
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
    return YaruScrollViewUndershoot.builder(
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(kYaruPagePadding),
          children: [
            YaruSection(
              headline: const Text('Auto scroll: off'),
              width: 700,
              child: YaruCarousel(
                height: 400,
                navigationControls: true,
                children: _getCarouselChildren(),
              ),
            ),
            const SizedBox(height: 20),
            YaruSection(
              headline: const Text('Auto scroll: on'),
              width: 700,
              child: YaruCarousel(
                controller: _autoScrollController,
                height: 400,
                children: _getCarouselChildren(),
              ),
            ),
            OverflowBar(
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
                ),
              ],
            ),
          ],
        );
      },
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
