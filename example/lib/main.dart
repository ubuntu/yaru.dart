import 'package:yaru_icons/widgets/yaru_icons.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const _from = 0xf101;
  static const _to = 0xf226;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(YaruIcons.ubuntu_logo),
        title: Text('Flutter Yaru Icons'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 72,
        children: List.generate(_to - _from + 1, (index) {
          final code = index + _from;
          return Column(
            children: [
              Icon(YaruIconsData(code), size: 48),
              Text('ex' + code.toRadixString(16)),
            ],
          );
        }),
      ),
    );
  }
}
