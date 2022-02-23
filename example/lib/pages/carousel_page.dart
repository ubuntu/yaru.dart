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
      YaruCarousel(
        fit: BoxFit.fitHeight,
        images: List.generate(
          length,
          (_) => AssetImage('assets/ubuntuhero.jpg'),
        ),
        height: 400,
      ),
      YaruRow(
          trailingWidget: Text('length: $length'),
          actionWidget: Row(
            children: [
              YaruOptionButton(
                  onPressed: () => setState(() {
                        length++;
                      }),
                  iconData: YaruIcons.plus),
              SizedBox(
                width: 10,
              ),
              YaruOptionButton(
                  onPressed: () => setState(() {
                        length >= 2 ? length-- : length = length;
                      }),
                  iconData: YaruIcons.minus)
            ],
          ),
          enabled: true)
    ]);
  }
}
