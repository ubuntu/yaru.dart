import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class UbuntuLogoPage extends StatefulWidget {
  const UbuntuLogoPage({Key? key}) : super(key: key);

  @override
  _UbuntuLogoPageState createState() => _UbuntuLogoPageState();
}

class _UbuntuLogoPageState extends State<UbuntuLogoPage> {
  @override
  Widget build(BuildContext context) {
    return YaruPage(
      children: [
        UbuntuLogo(),
      ],
    );
  }
}
