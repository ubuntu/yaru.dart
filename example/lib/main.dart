import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart' as yaru_theme;
import 'package:yaru_widgets_example/yaru_home.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: yaru_theme.lightTheme,
      darkTheme: yaru_theme.darkTheme,
      home: const YaruHome(),
    );
  }
}
