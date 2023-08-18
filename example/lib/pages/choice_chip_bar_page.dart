import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class ChoiceChipBarPage extends StatefulWidget {
  const ChoiceChipBarPage({super.key});

  @override
  State<ChoiceChipBarPage> createState() => _ChoiceChipBarPageState();
}

class _ChoiceChipBarPageState extends State<ChoiceChipBarPage> {
  final _labels = [
    for (var i = 0; i < 15; i++) 'Choice $i',
  ];

  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(_labels.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            YaruChoiceChipBar(
              yaruChoiceChipBarStyle: YaruChoiceChipBarStyle.stack,
              labels: _labels.map(Text.new).toList(),
              isSelected: _isSelected,
              onSelected: (index) => setState(() {
                _isSelected[index] = !_isSelected[index];
              }),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                children: [
                  for (int i = 0; i < _labels.length; i++)
                    if (_isSelected[i])
                      Text(
                        _labels[i],
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
