import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets_example/home_page.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: yaruLight,
      darkTheme: yaruDark,
      home: const HomePage(),
    );
  }
}
