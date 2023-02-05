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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kYaruPagePadding),
      children: [
        YaruPageIndicator(
          length: _length,
          page: _page,
          onTap: (page) => setState(() => _page = page),
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
            )
          ],
        )
      ],
    );
  }
}
