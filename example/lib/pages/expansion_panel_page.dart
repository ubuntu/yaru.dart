import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ExpansionPanelPage extends StatelessWidget {
  const ExpansionPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: YaruExpansionPanel(
          width: 500,
          headers: List.generate(
            10,
            (index) => Text(
              'Header $index',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          children: List.generate(
            10,
            (index) => Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text('Child $index'),
            ),
          ),
        ),
      ),
    );
  }
}
