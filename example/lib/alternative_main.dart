import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:yaru_widgets_example/example_page_items.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yaru Wide- / NarrowLayout Example',
      theme: yaruLight,
      darkTheme: yaruDark,
      home: const WideNarrowHomePage(),
    );
  }
}

class WideNarrowHomePage extends StatefulWidget {
  const WideNarrowHomePage({Key? key}) : super(key: key);

  @override
  State<WideNarrowHomePage> createState() => _WideNarrowHomePageState();
}

class _WideNarrowHomePageState extends State<WideNarrowHomePage> {
  var _index = -1;
  var _previousIndex = 0;

  void _setIndex(int index) {
    _previousIndex = _index;
    _index = index;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth > 600
                ? YaruWideLayout(
                    labelType: NavigationRailLabelType.none,
                    pageItems: examplePageItems.take(15).toList(),
                    initialIndex: _index == -1 ? _previousIndex : _index,
                    onSelected: _setIndex,
                  )
                : YaruNarrowLayout(
                    showSelectedLabels: false,
                    pageItems: examplePageItems.take(15).toList(),
                    initialIndex: _index == -1 ? _previousIndex : _index,
                    onSelected: _setIndex,
                  )),
      ),
    );
  }
}
