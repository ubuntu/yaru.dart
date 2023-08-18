import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class PageIndicatorPage extends StatefulWidget {
  const PageIndicatorPage({super.key});

  @override
  State<PageIndicatorPage> createState() => _PageIndicatorPageState();
}

class _PageIndicatorPageState extends State<PageIndicatorPage> {
  int _page = 0;
  int _length = 5;
  double _dotSize = 12.0;
  double _dotSpacing = 48.0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        YaruPageIndicator.builder(
          length: _length,
          page: _page,
          onTap: (page) => setState(() => _page = page),
          itemSizeBuilder: (_, __, ___) => Size.square(_dotSize + 8),
          layoutDelegate:
              YaruPageIndicatorSteppedDelegate(baseItemSpacing: _dotSpacing),
          itemBuilder: (index, selectedIndex, length) => YaruPageIndicatorItem(
            selected: index == selectedIndex,
            size: Size.square(index == selectedIndex ? _dotSize + 8 : _dotSize),
            animationDuration: const Duration(milliseconds: 250),
          ),
        ),
        const SizedBox(height: 15),
        YaruPageIndicator.builder(
          length: _length,
          page: _page,
          onTap: (page) => setState(() => _page = page),
          itemSizeBuilder: (_, __, ___) => Size.square(_dotSize + 8),
          layoutDelegate:
              YaruPageIndicatorSteppedDelegate(baseItemSpacing: _dotSpacing),
          itemBuilder: (index, selectedIndex, length) => YaruPageIndicatorItem(
            selected: index <= selectedIndex,
            size: Size.square(index <= selectedIndex ? _dotSize + 8 : _dotSize),
            animationDuration: const Duration(milliseconds: 250),
          ),
        ),
        const SizedBox(height: 15),
        ButtonBar(
          buttonPadding: EdgeInsets.zero,
          children: [
            YaruOptionButton(
              onPressed: () => setState(() {
                _length++;
              }),
              child: const Icon(YaruIcons.plus),
            ),
            const SizedBox(
              width: 10,
            ),
            YaruOptionButton(
              onPressed: () => setState(() {
                _length = _length > 1 ? _length - 1 : _length;
                _page = _length - 1 < _page ? _length - 1 : _page;
              }),
              child: const Icon(YaruIcons.minus),
            ),
          ],
        ),
        Slider(
          min: 6.0,
          max: 24.0,
          value: _dotSize,
          onChanged: (scale) => setState(() => _dotSize = scale),
        ),
        Slider(
          min: 12.0,
          max: 96.0,
          value: _dotSpacing,
          onChanged: (scale) => setState(() => _dotSpacing = scale),
        ),
      ],
    );
  }
}
